Create an open-questions.md file for this project if one does not already exist.
Uses the open-questions skill for file resolution, format, and CLAUDE.md registration.

Follow these steps:

1. Run the OQ file resolution sequence from the open-questions skill to determine
   where the file should live. If the file already exists, tell the user:
   "open-questions.md already exists at [path]. Use /oq-add to add questions or
   /oq-scan to scan the repo." Stop here.

2. Create the file at the resolved path using the structure in the open-questions
   skill's references/open-questions-template.md. Write the header, intro paragraph,
   empty index table (headers only, no rows), and the closing divider.
   No placeholder entries.

3. Run the CLAUDE.md registration sequence from the open-questions skill.
   Append the reference block if CLAUDE.md exists and does not already mention
   open-questions. Report whether it was updated, already present, or not found.

4. Use AskUserQuestion:
   "open-questions.md created. Do you have any open questions to add right now?"
   Options:
   - "Yes — add questions now"
   - "No — done"

   If yes: run the /oq-add flow inline. Do not tell the user to run it separately.
   If no: stop.
