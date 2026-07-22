# Open Questions Template

Canonical format for open-questions.md. The single source of truth for file
structure — every oq-* command writes this shape.

---

## Template

# Open Questions

Items pending resolution, awaiting input, or explicitly blocked.

- Add manually: /oq-add
- Scan repo for new items: /oq-scan
- Resolve items: /oq-resolve

Items marked [resolved] are kept for history and ignored on future scans.

---

## Index

| ID                | Title       | Type          | Status   | Added      |
| ----------------- | ----------- | ------------- | -------- | ---------- |
| [OQ-001](#oq-001) | Short title | BLOCKER       | Open     | YYYY-MM-DD |
| [OQ-002](#oq-002) | Short title | OPEN QUESTION | Resolved | YYYY-MM-DD |

---

## OQ-001 — [Title]

**Type:** BLOCKER
**Added:** YYYY-MM-DD
**Source:** path/to/file:line <- scan-discovered items only; omit for manual entries

**Question / Description:**
[Full description. Specific enough that someone picking this up cold understands
what needs to be resolved and why it matters.]

**Resolution criteria:**
[What does resolved look like? What needs to happen for this to be closed?]

---

## OQ-002 — [resolved] [Title]

**Type:** OPEN QUESTION
**Added:** YYYY-MM-DD

**Question / Description:**
[original description preserved]

**Resolution criteria:**
[original criteria preserved]

**Resolved:** YYYY-MM-DD
**Resolution:** [how it was resolved]

---

## Index Maintenance Rules

The index table lives below the intro paragraph and above the first item entry.

When adding:

- Append a row at the end: ID, title, type, "Open", date added — correct because
  the new ID is always the highest
- Use anchor link: [OQ-NNN](#oq-nnn)

When resolving:

- Update the Status column from "Open" to "Resolved"
- Never remove the row, never move it — it stays in ID order

Ordering: Strict ID ascending, top to bottom, regardless of Open/Resolved status.
A resolved item never moves — it stays in its numeric slot. Since a new item's ID
is always the highest so far, appending at the end of the index (and the end of the
body) is always correct.

## Field Reference

Source field: include for scan-discovered items (path:line). Omit for manually
added items — there is no source file, the question came from the user directly.

Type values: BLOCKER, OPEN QUESTION, PENDING DECISION, WAITING ON, ACTION ITEM
