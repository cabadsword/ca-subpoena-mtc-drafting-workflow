param(
    [string]$WorkspaceRoot = (Get-Location).Path,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    throw "Python was not found in PATH. OCR intake needs Python with PyMuPDF; OCR pages additionally need pytesseract and the Tesseract engine."
}

$script = @'
import argparse
import csv
import datetime as dt
import hashlib
import os
import re
import shutil
import sys
import tempfile
from pathlib import Path

try:
    import fitz
except Exception:
    fitz = None

try:
    import pytesseract
    from PIL import Image
except Exception:
    pytesseract = None
    Image = None


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def safe_name(path):
    stem = re.sub(r"[^A-Za-z0-9._-]+", "_", Path(path).stem).strip("_")
    return stem[:120] or "pdf"


def load_index(index_path):
    rows = {}
    if not index_path.exists():
        return rows
    with index_path.open("r", newline="", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            rows[row.get("SourcePath", "")] = row
    return rows


def write_index(index_path, rows):
    fields = [
        "SourcePath",
        "FileName",
        "FileSize",
        "LastWriteTime",
        "Hash",
        "PageCount",
        "Status",
        "PagesWithEmbeddedText",
        "PagesOCRed",
        "LowConfidencePages",
        "OutputTextPath",
        "ProcessedAt",
        "Notes",
    ]
    with index_path.open("w", newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for key in sorted(rows):
            writer.writerow({field: rows[key].get(field, "") for field in fields})


def find_pdfs(root):
    source_dirs = [root, root / "Exhibits", root / "Context (not exhibit)", root / "Authorities"]
    skip_names = {".ocr_temp_work", "Intermediary work", "Skills"}
    seen = set()
    pdfs = []
    for source_dir in source_dirs:
        if not source_dir.exists():
            continue
        if source_dir == root:
            for item in source_dir.iterdir():
                if item.is_file() and item.suffix.lower() == ".pdf":
                    resolved = item.resolve()
                    if resolved not in seen:
                        seen.add(resolved)
                        pdfs.append(item)
            continue
        for item in source_dir.rglob("*.pdf"):
            if any(part in skip_names for part in item.parts):
                continue
            resolved = item.resolve()
            if resolved not in seen:
                seen.add(resolved)
                pdfs.append(item)
    return sorted(pdfs, key=lambda p: str(p).lower())


def page_text(page):
    try:
        return (page.get_text("text") or "").strip()
    except Exception:
        return ""


def ocr_page(page):
    if pytesseract is None or Image is None or shutil.which("tesseract") is None:
        return None
    zoom = 2.0
    matrix = fitz.Matrix(zoom, zoom)
    pix = page.get_pixmap(matrix=matrix, alpha=False)
    mode = "RGB" if pix.n < 4 else "RGBA"
    image = Image.frombytes(mode, [pix.width, pix.height], pix.samples)
    return (pytesseract.image_to_string(image) or "").strip()


def process_pdf(pdf, ocr_dir, force, old_row):
    stat = pdf.stat()
    file_hash = sha256(pdf)
    last_write = dt.datetime.fromtimestamp(stat.st_mtime).isoformat(timespec="seconds")
    source_path = str(pdf.resolve())

    if not force and old_row:
        unchanged = (
            old_row.get("Hash") == file_hash
            and old_row.get("FileSize") == str(stat.st_size)
            and old_row.get("LastWriteTime") == last_write
            and old_row.get("OutputTextPath")
            and Path(old_row.get("OutputTextPath")).exists()
        )
        if unchanged:
            row = dict(old_row)
            row["Status"] = "Skipped unchanged"
            row["ProcessedAt"] = dt.datetime.now().isoformat(timespec="seconds")
            return row

    output_path = ocr_dir / f"{safe_name(pdf)}.ocr.txt"
    if fitz is None:
        output_path.write_text(
            f"SOURCE: {source_path}\nPAGES: unknown\n\nPyMuPDF is not available, so text extraction could not run.\n",
            encoding="utf-8",
        )
        return {
            "SourcePath": source_path,
            "FileName": pdf.name,
            "FileSize": str(stat.st_size),
            "LastWriteTime": last_write,
            "Hash": file_hash,
            "PageCount": "",
            "Status": "Unreadable / needs manual review",
            "PagesWithEmbeddedText": "",
            "PagesOCRed": "",
            "LowConfidencePages": "",
            "OutputTextPath": str(output_path),
            "ProcessedAt": dt.datetime.now().isoformat(timespec="seconds"),
            "Notes": "PyMuPDF not available.",
        }

    doc = fitz.open(pdf)
    pages = []
    embedded_pages = []
    ocr_pages = []
    needs_ocr = []
    notes = []

    for i, page in enumerate(doc, start=1):
        text = page_text(page)
        if len(text) >= 40:
            embedded_pages.append(str(i))
            pages.append((i, text))
            continue
        ocr_text = ocr_page(page)
        if ocr_text is not None and len(ocr_text.strip()) > 0:
            ocr_pages.append(str(i))
            pages.append((i, ocr_text))
        else:
            needs_ocr.append(str(i))
            pages.append((i, text))

    with output_path.open("w", encoding="utf-8") as f:
        f.write(f"SOURCE: {source_path}\n")
        f.write(f"PAGES: {doc.page_count}\n\n")
        for page_num, text in pages:
            f.write(f"--- Page {page_num} ---\n")
            if text:
                f.write(text.rstrip() + "\n\n")
            else:
                f.write("[No extractable text on this page.]\n\n")

    if needs_ocr and not ocr_pages:
        status = "Needs OCR engine"
        notes.append("Install Tesseract and pytesseract for OCR of image pages.")
    elif needs_ocr:
        status = "Partially OCRed"
        notes.append("Some pages still need manual review or OCR tooling.")
    elif ocr_pages:
        status = "Partially OCRed" if embedded_pages else "Fully OCRed"
    else:
        status = "Text extracted"

    return {
        "SourcePath": source_path,
        "FileName": pdf.name,
        "FileSize": str(stat.st_size),
        "LastWriteTime": last_write,
        "Hash": file_hash,
        "PageCount": str(doc.page_count),
        "Status": status,
        "PagesWithEmbeddedText": ",".join(embedded_pages),
        "PagesOCRed": ",".join(ocr_pages),
        "LowConfidencePages": ",".join(needs_ocr),
        "OutputTextPath": str(output_path),
        "ProcessedAt": dt.datetime.now().isoformat(timespec="seconds"),
        "Notes": " ".join(notes),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--workspace-root", required=True)
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()

    root = Path(args.workspace_root).resolve()
    ocr_dir = root / "Intermediary work" / "OCR"
    ocr_dir.mkdir(parents=True, exist_ok=True)
    index_path = ocr_dir / "OCR Index.csv"
    rows = load_index(index_path)

    for pdf in find_pdfs(root):
        source_path = str(pdf.resolve())
        try:
            rows[source_path] = process_pdf(pdf, ocr_dir, args.force, rows.get(source_path))
            print(f"{rows[source_path]['Status']}: {pdf.name}")
        except Exception as exc:
            stat = pdf.stat()
            rows[source_path] = {
                "SourcePath": source_path,
                "FileName": pdf.name,
                "FileSize": str(stat.st_size),
                "LastWriteTime": dt.datetime.fromtimestamp(stat.st_mtime).isoformat(timespec="seconds"),
                "Hash": "",
                "PageCount": "",
                "Status": "Unreadable / needs manual review",
                "PagesWithEmbeddedText": "",
                "PagesOCRed": "",
                "LowConfidencePages": "",
                "OutputTextPath": "",
                "ProcessedAt": dt.datetime.now().isoformat(timespec="seconds"),
                "Notes": str(exc),
            }
            print(f"Unreadable / needs manual review: {pdf.name}: {exc}")

    write_index(index_path, rows)
    print(f"OCR index: {index_path}")


if __name__ == "__main__":
    main()
'@

$tmp = Join-Path $env:TEMP ("ocr_pdf_intake_{0}.py" -f ([Guid]::NewGuid().ToString("N")))
Set-Content -LiteralPath $tmp -Value $script -Encoding UTF8
try {
    $argsList = @($tmp, "--workspace-root", $WorkspaceRoot)
    if ($Force) { $argsList += "--force" }
    & $python.Source @argsList
}
finally {
    Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
}
