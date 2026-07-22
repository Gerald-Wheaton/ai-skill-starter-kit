---
name: collaborate
description: Interactive back-and-forth interview to surface and resolve open questions before doing work. Use when the user asks "does this make sense?", "what do you think?", or similar sanity-check phrasing; when the user initiates a project or starts work on something new; when the user describes a task with nonobvious gaps; or whenever YOU (Claude) are unsure about scope, intent, requirements, or approach. Also triggers on /collaborate.
---

# Collaborate

Work back and forth with the user, starting with your open questions. Do not assume
anything. Rigorously interview the user concerning anything that is nonobvious about the
task at hand.

## Core rules

1. **Open questions first.** Before proposing, planning, or building anything, enumerate
   what you do not know or cannot verify from the repo, docs, or conversation. Those
   questions come first.

2. **Never assume.** If a detail is ambiguous, underspecified, or could reasonably go
   more than one way, it is a question, not a default. Do not fill gaps with plausible
   guesses.

3. **AskUserQuestion over prose.** Prioritize the AskUserQuestion tool in place of
   responding with paragraphs of questions and waiting for the user to prompt you back.
   Break nuanced questions into smaller concrete parts, each with 2-4 real options. Only
   fall back to free text when a question genuinely cannot be decomposed into options.

4. **Iterate until resolved.** One round is rarely enough. Answers spawn follow-up
   questions; keep interviewing until the nonobvious parts are actually resolved, not
   just acknowledged. Stop when remaining unknowns are trivial or explicitly deferred by
   the user.

5. **Plans come after.** If a plan is requested, run this interview BEFORE writing the
   plan. A plan built on unasked questions is a guess with formatting.

## When invoked because Claude is unsure

If you triggered this skill yourself (rather than the user invoking it), state in one
sentence what made you unsure, then go straight into AskUserQuestion. Do not pad with
analysis of options you will not pursue.

## When invoked at project start

When the user is kicking off a project or new piece of work, cover at minimum, via
AskUserQuestion rounds, whatever is not already established:

- Goal and definition of done
- Scope boundaries (what is explicitly OUT)
- Constraints (posture, tooling, access, deadlines)
- Existing artifacts or prior art to build on
- Who decides / who consumes the output

If the project has an open-questions.md, record unresolved items there per the
open-questions skill conventions.
