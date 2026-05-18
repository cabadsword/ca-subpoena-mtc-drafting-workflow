# Word Editing Protocol

Use this whenever the user wants Codex to maintain active Word drafts.

## Confirm Before Editing

Draft proposed text in chat first. Update the Word document only after the user confirms the section or wording.

Examples of confirmation:

- "ok"
- "confirmed"
- "please update"
- "use this"
- "insert this"
- "looks good"

If the user asks a question or requests revisions, do not edit yet.

## Preserve Formatting

When editing `.docx`:

- preserve paragraph style
- preserve numbering
- preserve indentation
- preserve caption format
- preserve heading capitalization style
- preserve line spacing and margins
- avoid rebuilding the document from scratch

Prefer replacing existing sample text in place when a clear corresponding section exists.

## Active Drafts

The active working draft is usually the root-level file matching the current work product:

- MTC / Motion / MPA
- Separate Statement
- RJN
- Declaration
- Proposed Order

If multiple candidate drafts exist, inspect names and modified times. Ask only if the active document cannot be determined.

## Cross-Document Updates

Do not update multiple documents automatically unless the user confirms that cross-document changes should be made. If a confirmed MPA section affects the Separate Statement, note it as a follow-up unless the user directs simultaneous updates.

## Verification

After editing:

- reopen or inspect the edited document structure if practical
- confirm placeholders remain intentional
- confirm exhibit/RJN references did not drift
- record the edit in the live change log
