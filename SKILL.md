---
name: ca-subpoena-mtc-drafting-workflow
description: Use when the user asks Codex to draft, revise, organize, or manage a California subpoena motion-to-compel package, including motion/Memorandum, separate statement, RJN, declarations, exhibits, TOC/TOA, objection tables, replacement tables, OCR intake, and live updates to confirmed Word drafts. Draft sections in chat first, then update the active Word draft only after user confirmation. Use only user-supplied legal authorities unless external research is expressly authorized.
---

# California Subpoena MTC Drafting Workflow

Use this skill for California motion-to-compel packages involving subpoenas, including motions to compel compliance with third-party subpoenas, separate statements, RJNs, declarations, exhibit planning, and intermediary work product.

## Core Rules

- Start with document intake. When PDFs are new or changed, assess whether OCR is needed before relying on them.
- Preserve original PDF page order. OCR output must be a sidecar work product and must not modify, split, merge, or renumber original PDFs.
- Build intermediary work before drafting major sections: document index, exhibit list, objection table, replacement table, needed-input list, TOC, TOA, and factual narrative.
- Draft one section at a time in chat. Do not update a Word draft until the user confirms the section.
- Once the user confirms a section, promptly update the active working Word draft while preserving existing paragraph formatting, captions, numbering, indentation, and heading style.
- Maintain a live change log in `Intermediary work` for confirmed updates.
- Keep main work product in the workspace root unless the user directs otherwise.
- Use only authorities supplied in the workspace, already captured in the authority table, carried from the user's example shell, supplied by the user, or deliberately added through authorized Lexis research. Do not introduce legal authorities from memory.
- Save section drafts as numbered artifacts in `Intermediary work`; do not create root preview copies or duplicate artifacts unless the user asks.
- Do not rename source files in `Exhibits`, `Context (not exhibit)`, or `Authorities` unless expressly instructed. Number intermediary artifacts, not source evidence.
- Do not erase or overwrite user edits. If the draft contains changes made by others, work with them.

## Workflow

1. **Intake and OCR**: See `references/pdf-ocr-intake.md`.
2. **Workspace organization**: See `references/workspace-setup.md`.
3. **Intermediary work product**: See `references/intermediary-work-product.md`.
4. **Drafting sequence**: See `references/drafting-sequence.md`.
5. **Word editing after confirmation**: See `references/word-editing-protocol.md`.
6. **Live draft change log**: See `references/live-draft-change-log.md`.
7. **Subpoena MTC issue checklists**: See `references/subpoena-mtc-checklists.md`.
8. **Tables and proposal formats**: See `references/deliverable-templates.md`.

## Intake Defaults

- Scan root, `Exhibits`, `Context (not exhibit)`, and `Authorities`.
- Store OCR sidecars in `Intermediary work\OCR`.
- Use page-stable text files with markers like `--- Page 1 ---`.
- Cache processed PDFs by path, size, modified time, and hash when available.

## Drafting Defaults

- Start from the prior sample document when one exists.
- Closely repurpose the sample document's structure and phrasing first, then tailor parties, facts, dates, citations, headings, and requested relief.
- Use search-and-replace tables when converting sample facts, names, dates, subpoenas, objections, exhibit numbers, or hearing details.
- Prefer concise, court-facing argument sections with citations tied to declarations, exhibits, RJN, objections, SAC allegations, and supplied legal authorities.
- Decide whether each issue belongs as a standalone section or a subsection before drafting, and maintain a live outline so section numbering remains coherent.
- Track placeholders and unresolved citations in the change log and needed-inputs table.

## Quality Checklist

- OCR/text basis checked before extracting facts from PDFs.
- Exhibit and RJN numbering are current.
- Objection references match source page/line where available.
- TOA uses only supplied or approved authorities; no memory-derived authorities appear in the draft.
- Draft text was confirmed before Word insertion.
- Word formatting was preserved after each live update.
- Change log records confirmed sections and unresolved placeholders.