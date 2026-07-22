---
name: hand-in
description: Resume work from a saved handoff document. Lists handoff docs in /handoffs/ and loads the one the user selects into context.
argument-hint: "Optional: a term to filter the handoff list (e.g. a project or topic)"
disable-model-invocation: true
---

Help the user resume work from a previously written handoff document. This is the companion to the `handoff` skill, which writes these documents.

## 1. Find the handoff documents

Read the current project's root level directory at `/handoffs/`. Look specifically and ONLY for the files with name prefix `handoff-`

- If the directory does not exist or contains no documents, tell the user there are no handoffs yet and suggest running the `handoff` skill first. Then stop.
- Otherwise, collect every Markdown document (`.md`) in the directory.

If the user passed an argument, treat it as a filter term and keep only documents whose filename or contents match it (case-insensitive). If the filter matches nothing, say so and fall back to listing all documents.

For each document, gather:

- the filename
- the last-modified date
- a one-line focus/summary — pull this from the document's stated "next session focus" (the argument captured by the `handoff` skill), or failing that the first heading or first non-empty line.

Sort newest-first.

## 2. Present the list for selection

Pick the presentation based on how many documents there are:

- **4 or fewer:** use the `AskUserQuestion` tool. One question ("Which handoff should I pick up?"), one option per document. Put the filename in the option label and the date + focus line in the option description.
- **More than 4:** print a numbered list to the chat instead, one document per line in the form `N. <filename> — <date> — <focus line>`. Then ask the user to reply with the number of the document they want, and end your turn so they can answer.

Do not load any document until the user has chosen one.

Include a final question asking the user if they want to delete the handoff document they're about to load into context (i.e. can specify that this is default behavior). If a user does not choose to keep the document, then automatically delete the file from the handoffs/ after you have loaded it into context.

## 3. Load the selected document and recap

Once the user has selected a document:

1. Read the full contents of the selected file into context.
2. Give a short recap (no more than a few lines): what the work is, where the previous session left off, and the immediate next steps.
3. Ask the user to confirm before you begin, rather than continuing the work automatically.

Treat the loaded document as the starting context for the new session, but defer to anything the user says next if it conflicts.

## 4. Execute decision to persist the used handoff document

Once the document has been loaded into context, delete it form the handoffs/ directory if the user did not explicitly choose to preserve it. You MUST HAVE ASKED the user their preference for this under step 2.
