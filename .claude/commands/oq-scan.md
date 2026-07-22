Scan the repository for open questions, blockers, and pending items. Add net-new
findings to the open-questions.md file. Safe to run repeatedly — already-captured
items are always skipped.

Follow these steps:

1. Run the OQ file resolution sequence from the open-questions skill. If the file
   does not exist, create it first using the format in the skill's
   references/open-questions-template.md, then run the CLAUDE.md registration
   sequence. Tell the user the file was created before proceeding.

2. Read the existing file and extract all item IDs and their substance so you
   know what to skip during deduplication.

3. Scan the repo using the scan logic defined in the open-questions skill.

   Use a broad search:

   ```bash
   grep -rn --include="*.md" --include="*.ts" --include="*.tsx" --include="*.js" \
     --include="*.jsx" --include="*.cs" --include="*.py" --include="*.go" \
     --include="*.yaml" --include="*.yml" --include="*.json" --include="*.txt" \
     -iE "TODO|FIXME|BLOCKED|WAITING ON|PENDING|AWAITING|TBD|TBC|OPEN QUESTION|\
   NEEDS DECISION|NEEDS INPUT|NEEDS REVIEW|FOLLOW.?UP|unclear|not yet determined|\
   waiting for|requires approval|pending (stakeholder|client|review|approval)" \
     --exclude-dir={.git,node_modules,dist,build,coverage} \
     . 2>/dev/null
   ```

   Additionally, look for open questions phrased as literal questions — but only
   in planning-type markdown (files whose name or path suggests spec, plan,
   design, decision, or notes content). Do not grep every "?" across all
   markdown; that is nearly all noise. Read the candidate planning docs and
   judge each question in context.

4. Triage findings per the scan logic in the open-questions skill. Use judgment —
   exclude completed notes, rhetorical questions, test fixtures. Err toward including
   ambiguous items.

5. Deduplicate against existing file contents. Skip anything already captured,
   resolved or not.

6. Assign OQ IDs to net-new items per the ID assignment rules in the skill, in the
   order you'll append them (lowest new ID first) so IDs and file position stay in
   sync.

7. Append net-new items to the end of the body, one entry each in ascending ID
   order, using the exact structure in the skill's
   references/open-questions-template.md. Heading level is ## — the same as
   manually added items; no dated wrapper section (the Added field carries the
   date). Get the date with `date +%F` — never guess it.

   ## OQ-NNN — [Short descriptive title]

   **Type:** [type]
   **Added:** YYYY-MM-DD
   **Source:** path/to/file:line_number

   **Question / Description:**
   [1-2 sentence summary with enough context to understand it without reading
   the source file]

   **Resolution criteria:**
   [what needs to happen for this to be closed]

   ***

8. Update the index table at the top of the file. Append a row for each net-new
   item, in ascending ID order:
   | [OQ-NNN](#oq-nnn) | [title] | [type] | Open | YYYY-MM-DD |
   Index stays in strict ID ascending order regardless of status.
   If the index table does not exist in the file, insert it now between the intro
   paragraph and the first item entry.

9. Report:
   - Total candidates found in scan
   - How many were already captured (skipped)
   - How many are net-new and were added, with a brief list of their titles
   - If nothing new: "No new open items found."
