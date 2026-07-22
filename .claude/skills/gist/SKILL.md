---
name: gist
description: Highly concise orientation summary of the current repo/project — 1-3 sentence summary plus at most 5 sharp bullets. Use when the user asks "what is this repo", "give me the gist", "summarize this project", "what am I looking at", or similar orientation questions about the project they are in. Also triggers on /gist.
---

# Gist

Produce a tight orientation summary of the current working repository. Nothing else.

## Scope

- **Current repo only.** Do not resolve other paths or remote URLs; if the user names a
  different target, say gist covers the current repo and ask whether to proceed here.
- **Chat output only.** Never write the summary to a file.

## How to gather facts

Do NOT explore inline — file dumps burn main-thread context. Spawn ONE `Explore`
subagent with a prompt like:

> Orient me in this repo. Return compressed findings only: (1) what this project IS and
> its purpose, (2) external systems/integrations it touches, (3) current status, open
> blockers, unfinished work (check open-questions.md, TODO files, README/CLAUDE.md
> status sections, recent git log), (4) anything load-bearing or surprising a newcomer
> must know. No file dumps, no code excerpts — conclusions with file references.

Docs (CLAUDE.md, README) are hints, not truth — the subagent verifies against actual
structure. The main thread writes the final gist from the subagent's findings; do not
re-explore.

## Output format (hard cap)

1. **Summary: 1-3 sentences.** What the project is and why it exists.
2. **At most 5 bullets.** Sharp, tightly worded, one line each where possible.

Bullet content is adaptive — pick the 5 most load-bearing facts for THIS repo. Favor:

- Purpose and external integrations (what it talks to)
- Status and blockers (current phase, open questions, unfinished work)
- Anything that overrides surface impressions (gotchas, "this is not what it looks like")

Skip what a newcomer can see at a glance (obvious directory listing, boilerplate stack
facts) unless it is genuinely load-bearing. Fewer, sharper bullets beat 5 padded ones.

No headers, no tables, no preamble. Summary then bullets, done.
