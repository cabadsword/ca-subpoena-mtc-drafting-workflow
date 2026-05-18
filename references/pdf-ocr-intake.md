# PDF OCR Intake

Use this at the beginning of a subpoena MTC workspace and whenever the user adds PDFs.

## Goals

- Make PDFs searchable before drafting.
- Preserve the original PDF page order.
- Preserve original source filenames.
- Avoid reprocessing unchanged PDFs.
- Never modify original exhibit, context, or authority PDFs.

## Scan Locations

Scan these folders if present:

- workspace root
- `Exhibits`
- `Context (not exhibit)`
- `Authorities`

Do not treat `.ocr_temp_work`, render folders, preview folders, or Office temp folders as source evidence unless the user specifically points to them.

## Output Location

Store OCR work product in:

```text
Intermediary work\OCR
```

Create:

- one page-stable text sidecar per PDF
- an OCR index CSV
- optional per-page helper files if needed

Use text sidecar format:

```text
SOURCE: <pdf path>
PAGES: <page count>

--- Page 1 ---
<text>

--- Page 2 ---
<text>
```

## Efficient Intake Method

1. Get PDF path, size, modified time, and hash if practical.
2. Check OCR index/cache. Skip unchanged PDFs.
3. Extract embedded text first.
4. Mark pages with little/no text as image-based or low-text.
5. OCR only low-text/image pages.
6. Merge extracted text and OCR text back into original page order.
7. Update the OCR index.

## Image / Manual Fallback

If embedded text and OCR do not recover key content:

- inspect the page visually or use image recognition
- accept user-supplied extracted images for the missing page or attachment
- create a source note identifying the fallback image and the original PDF/page
- add manually transcribed text to the OCR sidecar in the correct page slot or a clearly labeled review file

Before drafting a Separate Statement, visually/OCR verify:

- exact subpoena request text
- exact objection text
- page:line references if the source is line-numbered

## OCR Index Columns

Use these columns:

- SourcePath
- FileName
- FileSize
- LastWriteTime
- Hash
- PageCount
- Status
- PagesWithEmbeddedText
- PagesOCRed
- LowConfidencePages
- OutputTextPath
- ProcessedAt
- Notes

Status values:

- `Text extracted`
- `Partially OCRed`
- `Fully OCRed`
- `Needs OCR engine`
- `Unreadable / needs manual review`
- `Skipped unchanged`

## Page Order Rule

Never reorder pages. If OCR is done only for selected pages, insert the OCR text into the same page number slot in the combined text file.

## Source Filename Rule

Do not rename original source PDFs or images in `Exhibits`, `Context (not exhibit)`, or `Authorities` unless expressly instructed. If numbered copies are useful, create a separate copy set or number intermediary artifacts only.

## When OCR Is Unavailable

If OCR tooling is missing, still extract embedded text and update the OCR index. Mark image-based pages as `Needs OCR engine` and identify the page numbers so the user knows what remains blocked.

## Using The Helper Script

The optional helper is:

```text
scripts\ocr_pdf_intake.ps1
```

Run it from the workspace root or pass `-WorkspaceRoot`. It creates the OCR folder, page-stable text files, and OCR index.