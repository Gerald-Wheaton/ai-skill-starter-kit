---
name: gist
description: Highly concise orientation summary of the current repo/project, or of a specific feature/directory when a target is given — 1-3 sentence summary plus at most 5 sharp bullets. Use when the user asks "what is this repo", "give me the gist", "gist the auth module", "summarize this project/feature/directory", "what am I looking at", or similar orientation questions. Also triggers on /gist (optionally with a target, e.g. /gist src/auth).
---

# Gist

Produce a tight orientation summary. Target is EITHER the whole repo (no argument) or a
specific feature/directory the user names (argument). Nothing else.

## Resolve the target

- **No argument** → gist the entire current working repository.
- **Argument given** → gist ONLY that target. It may be:
  - a directory path (e.g. `src/auth`, `.claude/skills`)
  - a feature/concept name (e.g. "the ticket intake flow", "auth", "the MCP tooling")
- If the argument is a feature name, not a path, let the subagent locate the relevant
  files first, then scope the gist to them.
- If the named target can't be found, say so and offer a full-repo gist instead.

## Scope

- **Current repo only.** Do not resolve other repos or remote URLs. If the user names a
  different repo, say gist covers the current repo and ask whether to proceed here.
- **Chat output only.** Never write the summary to a file.

## How to gather facts

Do NOT explore inline — file dumps burn main-thread context. Spawn ONE `Explore`
subagent. The main thread writes the final gist from the subagent's findings; do not
re-explore.

**Full-repo prompt:**

> Orient me in this repo. Return compressed findings only: (1) what this project IS and
> its purpose, (2) external systems/integrations it touches, (3) current status, open
> blockers, unfinished work (check open-questions.md, TODO files, README/CLAUDE.md
> status sections, recent git log), (4) anything load-bearing or surprising a newcomer
> must know. No file dumps, no code excerpts — conclusions with file references.

**Targeted prompt (feature/directory `<TARGET>`):**

> Orient me in `<TARGET>` within this repo. If it's a feature name not a path, first
> locate the files that implement it. Return compressed findings only: (1) what
> `<TARGET>` does and its role in the wider project, (2) its key entry points, files, and
> how it connects to the rest of the repo, (3) external systems it touches, (4) current
> status, blockers, unfinished work, gotchas specific to this target. No file dumps, no
> code excerpts — conclusions with file references.

Docs (CLAUDE.md, README) are hints, not truth — the subagent verifies against actual
structure.

## Output format (hard cap)

1. **Summary: 1-3 sentences.** What the target is and why it exists / its role.
2. **At most 5 bullets.** Sharp, tightly worded, one line each where possible.

Bullet content is adaptive — pick the 5 most load-bearing facts for THIS target. Favor:

- Purpose and external integrations (what it talks to)
- Key files / entry points and how it connects to the rest of the repo (targeted gists)
- Status and blockers (current phase, open questions, unfinished work)
- Anything that overrides surface impressions (gotchas, "this is not what it looks like")

Skip what a newcomer can see at a glance (obvious directory listing, boilerplate stack
facts) unless genuinely load-bearing. Fewer, sharper bullets beat 5 padded ones.

No headers, no tables, no preamble. Summary then bullets, done.
