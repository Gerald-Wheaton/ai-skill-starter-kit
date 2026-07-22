Print a concise numbered list of all open (unresolved) questions from the
open-questions.md file.

Follow these steps:

1. Run the OQ file resolution sequence from the open-questions skill. If no file
   is found and the user declines to create one, stop cleanly.

2. Read the file and collect all items that do NOT have [resolved] in their header.

3. If there are no open items, respond: "No open questions. Run /oq-scan to search
   the repo or /oq-add to add one manually."

4. Respond with exactly this format, no preamble:

---

**Open Questions — [project root folder name]**
[N] open item(s)

1. OQ-001 [BLOCKER]: [one sentence — what the question or blocker is]
2. OQ-002 [OPEN QUESTION]: [one sentence]
3. OQ-004 [WAITING ON]: [one sentence]

---

Rules for the one-sentence summary:

- Distill the Question/Description field to a single tight sentence
- Start with the substance, not filler ("Waiting on..." not "This is about waiting on...")
- If the item has a resolution criteria that clarifies the question, fold it in
- Never exceed one line — truncate with "..." if needed
- Order by ID ascending
- Skip resolved items entirely — they do not appear in this list
