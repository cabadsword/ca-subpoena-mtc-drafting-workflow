# California Subpoena MTC Drafting Workflow

A Codex skill for drafting and managing California subpoena motion-to-compel packages. It is designed for matters involving third-party subpoenas, account-holder objections, business-record productions, separate statements, declarations, RJNs, exhibit planning, OCR intake, and section-by-section motion drafting.

The skill favors source-grounded drafting: intake first, authority table second, draft sections third, and update final Word drafts only after user confirmation.

## What It Helps With

- Motion/Memorandum of Points and Authorities drafting
- Separate statements for subpoena requests and objections
- Requests for judicial notice
- Declaration and exhibit planning
- Exhibit citation tables
- OCR intake and source indexing
- Objection and response matrices
- Authority tables and legal issue tracking
- Numbered intermediary drafting artifacts
- Controlled updates to confirmed Word drafts

## Core Workflow

1. Intake the matter documents and identify which PDFs or images need OCR.
2. Build source, exhibit, and citation indexes before drafting.
3. Create an authority table from user-supplied sources, example shells, and expressly authorized research.
4. Draft motion sections one at a time in chat or intermediary artifacts.
5. Draft the separate statement using the original request text and original objection text.
6. Draft the RJN only for proper court records or public records.
7. Update Word drafts only after the user confirms the section text.
8. Track unresolved facts, citation gaps, and verification flags until finalization.

## Guardrails

- Do not introduce legal authorities from memory.
- Use only user-supplied authorities, example-shell authorities, the working authority table, or authorities deliberately added through authorized research.
- Do not rename original source files in `Exhibits`, `Context (not exhibit)`, or `Authorities` unless the user expressly instructs it.
- Number intermediary work product instead of source files by default.
- Closely repurpose example shells first, then tailor parties, facts, dates, headings, and citations.
- Decide whether an issue belongs in a standalone section or subsection before drafting.
- Keep separate statement good-cause responses shorter and more consolidated than the MTC.

## Repository Contents

```text
SKILL.md
references/
  deliverable-templates.md
  drafting-sequence.md
  intermediary-work-product.md
  live-draft-change-log.md
  pdf-ocr-intake.md
  subpoena-mtc-checklists.md
  word-editing-protocol.md
  workspace-setup.md
scripts/
  ocr_pdf_intake.ps1
```

## Installation

Install this repository as a Codex skill under your local Codex skills directory:

```text
%USERPROFILE%\.codex\skills\ca-subpoena-mtc-drafting-workflow
```

For private repositories, use the GitHub connector/app or another authenticated GitHub workflow that has access to this repository.

## Typical Prompt

```text
Use ca-subpoena-mtc-drafting-workflow to intake these exhibits, build the authority table, and draft the California subpoena MTC package section by section. Draft in artifacts/chat first and do not update Word drafts until I confirm.
```

## OCR Script

`scripts/ocr_pdf_intake.ps1` supports local PDF/OCR intake for matter workspaces. Use it when exhibits or context PDFs have weak embedded text, image-only pages, or attachment pages that must be visually verified before drafting.

## Legal Review

This skill supports drafting workflow and source organization. It does not replace attorney review, final citation verification, Shepard's/treatment checks, court-rule review, or case-specific judgment.