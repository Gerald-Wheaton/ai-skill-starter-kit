---
name: open-questions
description: >
  Reusable open questions tracking for any project. Use this skill whenever creating,
  scanning, listing, adding to, or resolving items in an open-questions.md file.
  Triggers on: "open questions", "track a question", "what's unresolved", "scan for
  blockers", "add an open question", "list open questions", "resolve a question",
  "close out open items", or any request to manage a file called open-questions.md.
  Powers the oq-* commands: /oq-init, /oq-add, /oq-scan, /oq-list, /oq-resolve.
---

# Open Questions Skill

Reusable skill for tracking open questions, blockers, and pending decisions in any
project. The file lives at the project root (./open-questions.md) unless the user
specifies a different path.

Dates: whenever a step stamps YYYY-MM-DD, get the real date with `date +%F` first.
Never guess the date.

---

## File Resolution

Every command using this skill must resolve the file location using this logic before
doing anything else. Call it the OQ file resolution sequence:

1. Check if ./open-questions.md exists at the project root:
   [ -f ./open-questions.md ] && echo "found" || echo "missing"
   If found: use it. No need to ask.

2. If it does not exist, use AskUserQuestion:
   "No open-questions.md found. Where should it be created?
   It will default to the project root (./open-questions.md) if you don't specify
   a different location."
   Options:
   - "Project root (default)"
   - "Specify a different path"

   If "Specify a different path": use AskUserQuestion to ask for the path.

Resolved path = the location determined above. All reads and writes use this path.

---

## CLAUDE.md Registration

After creating a new open-questions.md file (not when it already exists), check
if a CLAUDE.md file is present in the project root:
[ -f ./CLAUDE.md ] && echo "found" || echo "missing"

If found, check if open-questions is already referenced:
grep -q "open-questions" ./CLAUDE.md && echo "already listed" || echo "not listed"

If not already listed, append this block:

## Open Questions

There is an open questions file tracking unresolved questions, blockers, and pending
decisions for this project. Review it when making decisions or before starting new work.

File: [resolved path to open-questions.md]

If CLAUDE.md does not exist: do not create it. Tell the user no CLAUDE.md was found
and they may want to add the reference manually.

---

## File Format

Follow the canonical structure in references/open-questions-template.md exactly.

Key rules:

- Index table lives at the top, always kept in sync
- Items use OQ-NNN IDs, zero-padded to 3 digits, never reused
- Resolved items keep their entry with [resolved] in the header and a resolution block
- Index rows are never removed — resolved items stay with Status "Resolved"
- Both the index table and the body sections are ordered strictly by OQ-NNN ascending,
  top to bottom. Resolved status does NOT affect position — a resolved OQ-003 still
  sits between OQ-002 and OQ-004. Since IDs only ever increase and a new item always
  gets the next number, appending a new entry at the end of the index and the end of
  the body is always correct — no reshuffling needed.
- If a command finds the file already out of ID order (e.g. from manual edits before
  this rule existed), re-sort both the index and the body sections by ID ascending
  before making the requested change.
- Anchor links in the index: [OQ-NNN](#oq-nnn)

---

## ID Assignment

To get the next OQ ID:

1. Read the existing file
2. Find all existing OQ-NNN IDs (resolved or not)
3. Take the highest number and increment by 1
4. If the file is new, start at OQ-001

---

## Scan Logic

When scanning a repo for open items, always skip:

- The open-questions.md file itself
- node_modules/, .git/, dist/, build/, coverage/
- Binary files, images, lock files (\*.lock, package-lock.json, yarn.lock)
- Respect .gitignore if present

Signals to look for:

Explicit markers in code or docs:
TODO, FIXME, HACK, XXX, BLOCKED, BLOCKING, BLOCKED ON, BLOCKED BY,
WAITING ON, WAITING FOR, PENDING, AWAITING, TBD, TBC, TO BE DETERMINED,
TO BE CONFIRMED, OPEN QUESTION, OPEN ISSUE, UNRESOLVED, NEEDS DECISION,
NEEDS INPUT, NEEDS REVIEW, NEEDS APPROVAL, FOLLOW UP, FOLLOW-UP, ACTION ITEM

Natural language in markdown/docs:
"need to decide", "still unclear", "not yet determined", "waiting on [person/team]",
"requires approval", "pending stakeholder", "unclear:", "open question:", "question:",
sentences ending in ? in spec or plan documents, TBD or ??? as placeholder values

Triage: not every hit is a genuine open item. Use judgment. Exclude completed notes,
rhetorical questions, test fixtures, documentation examples. Err toward including
ambiguous items.

Deduplication: skip any finding whose substance already exists in the file,
resolved or not.

---

## Item Types

| Type             | Use when                                                       |
| ---------------- | -------------------------------------------------------------- |
| BLOCKER          | Work cannot proceed until this is resolved                     |
| OPEN QUESTION    | A decision or answer is needed but nothing is actively blocked |
| PENDING DECISION | A specific decision needs to be made by someone                |
| WAITING ON       | Explicitly waiting for a person, team, or external dependency  |
| ACTION ITEM      | Something that needs to happen that has not been ticketed yet  |

---

## Resolving Items

Canonical resolution procedure — any command that closes an item follows this exactly.

For each item being resolved, update the file immediately (never batch to the end):

1. Add [resolved] to the item header, after the ID:
   ## OQ-NNN — [resolved] [Title]
2. Append a resolution block below the existing content. Never remove or rewrite
   the original entry — keep full history:
   **Resolved:** YYYY-MM-DD (from `date +%F`)
   **Resolution:** [user's note, verbatim or lightly cleaned up]
3. Update the item's index row: Status "Open" → "Resolved". Never remove the row.
4. Leave the row's position unchanged — index and body stay in ID ascending order
   regardless of status, so resolving an item never moves it.

Resolved items are skipped by /oq-list, ignored by /oq-scan deduplication scans
(their substance still counts for dedup — do not re-add a resolved item), and
never offered again by /oq-resolve.

---

## Commands Using This Skill

- /oq-init — create the file, register in CLAUDE.md
- /oq-scan — scan repo, add net-new findings
- /oq-add — manually add a question via AskUserQuestion
- /oq-list — concise numbered bullet list of all open items
- /oq-resolve — walk unresolved items, mark resolved interactively
