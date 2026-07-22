Manually add one or more open questions to the open-questions.md file using
AskUserQuestion. Use this for questions in your head, verbal conversations, or
decisions not yet written anywhere in the codebase. For discovering items that
already exist in code or docs, use /oq-scan instead.

Follow these steps:

1. Run the OQ file resolution sequence from the open-questions skill. If the file
   does not exist, create it first using the format in the skill's
   references/open-questions-template.md, then run the CLAUDE.md registration
   sequence. Tell the user the file was created before proceeding.

2. Collect the question using AskUserQuestion:

   Ask: "What's the open question or blocker? Give it a short title."
   Free text response.

   Ask: "What type is this?"
   Options: "BLOCKER" | "OPEN QUESTION" | "PENDING DECISION" | "WAITING ON" | "ACTION ITEM"

   Ask: "Describe it — what needs to be resolved and why does it matter?"
   Free text response.

   Ask: "What does resolved look like? What needs to happen for this to be closed?"
   Free text response.

3. Assign the next OQ ID per the ID assignment rules in the open-questions skill.

4. Write the entry to the file, appending it at the very end of the body (after the
   last existing entry, resolved or not — its ID is always the highest, so this
   keeps the file in ID ascending order). Get the date with `date +%F` — never
   guess it.

   ## OQ-NNN — [Title]

   **Type:** [type]
   **Added:** YYYY-MM-DD

   **Question / Description:**
   [description]

   **Resolution criteria:**
   [resolution criteria]

   ***

   Note: no Source field — this was manually entered, not scan-discovered.

5. Update the index table. Append a row at the end:
   | [OQ-NNN](#oq-nnn) | [title] | [type] | Open | YYYY-MM-DD |
   Index stays in strict ID ascending order regardless of status.

6. Use AskUserQuestion:
   "Question added. Do you have another open question to add?"
   Options: "Yes — add another" | "No — done"
   If yes, return to step 2.

7. Report: how many questions were added, their IDs and titles.
