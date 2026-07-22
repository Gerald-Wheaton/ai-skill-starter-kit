Walk through unresolved open questions and blockers in the open-questions.md file
and mark items resolved interactively using AskUserQuestion. Uses the open-questions
skill for file resolution and the canonical resolution procedure.

Follow these steps:

1. Run the OQ file resolution sequence from the open-questions skill. If no file
   exists, tell the user: "Nothing to resolve — no open-questions.md found. Run
   /oq-init to create one or /oq-scan to scan the repo." Stop here.

2. Read the full file and collect all items that do NOT have [resolved] in their
   header. These are the active items.

3. If there are no unresolved items, respond: "No open items to resolve. Run
   /oq-scan if you think something new should have been picked up." Stop here.

4. Print a numbered summary of the active items as plain text (same format as
   /oq-list — one line per item: `N. OQ-NNN [TYPE]: one-sentence summary`).
   Do NOT put the items themselves in AskUserQuestion options — the tool caps at
   4 options and item lists routinely exceed that.

   Then use AskUserQuestion: "Which items would you like to resolve?"
   Options:
   - "All open items" — work through every active item in ID order
   - "Blockers first" — work through items typed BLOCKER, then ask whether to
     continue with the rest
   - "Pick by ID" — follow up with a free-text AskUserQuestion asking for IDs
     (accept forms like "3, 7" or "OQ-003 OQ-007"); the user may also type IDs
     directly via the Other field on this question
   - "Exit — done for now"

   If "Exit": stop cleanly.

5. For each selected item, one at a time, use AskUserQuestion. Show the full item
   context first — title, type, Source (if present), description, and resolution
   criteria — so the user can answer without looking anything up.

   Ask: "OQ-NNN: [title] — how was this resolved? Provide a brief note."
   Offer options:
   - "Answer now" — user types the resolution note (free text via Other is fine)
   - "Skip this one" — leave it open, move to the next
   - "Exit — done for now" — stop processing remaining items

   Wait for the answer before moving to the next item.

6. Update the file immediately after each answer using the Resolving Items
   procedure in the open-questions skill: [resolved] in the header, resolution
   block appended (date from `date +%F`), index row flipped to Resolved. Position
   in the index and body stays unchanged — both remain in ID ascending order.
   Never batch updates to the end. Never rewrite the original entry.

7. After all selected items are processed, report:
   "Resolved N item(s). X remain open. Run /oq-scan anytime to look for new items."
