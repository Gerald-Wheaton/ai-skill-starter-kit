# AI Starter Kit

A small, curated set of **skills** and **commands** for Claude Code — enough to
give a team its first repeatable AI workflow without drowning in options. Copy
them in, use them for a week, then start writing your own (the last skill in here
shows you how).

## What's a skill? What's a command?

- A **skill** is a Markdown file (`SKILL.md`) with a `name` and `description`.
  Claude reads the description and _decides on its own_ when to use it. Skills are
  how you teach Claude a repeatable procedure.
- A **command** is a Markdown file you trigger explicitly by typing `/name`. Same
  idea, but _you_ pull the trigger instead of Claude.

Both are just plain instructions. No code, no build step. If you can write a good
runbook, you can write a skill.

---

## Install

Two choices — same files, different reach.

**A) Global (all your projects)** — copy into your home `~/.claude/`:

```bash
cp -R .claude/skills/*   ~/.claude/skills/
cp -R .claude/commands/* ~/.claude/commands/
```

**B) Per-project (just one repo, and shareable via git)** — copy into that repo's
`.claude/` so it commits alongside the code and every teammate gets it:

```bash
cp -R .claude/skills   /path/to/your/repo/.claude/skills
cp -R .claude/commands /path/to/your/repo/.claude/commands
```

Start a new Claude Code session after copying. Confirm it took:

- Type `/` — the `oq-*` commands should appear in the list.
- Ask Claude "what skills do you have?" — you should see the ones below.

> Tip for learning: option B (per-project) is the one to start with. The files sit
> right there in `.claude/` where you can open, read, and edit them.

---

## What's inside

### Skills

| Skill              | What it does                                                                                                                                                           | Try it by saying                         |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| **collaborate**    | Interviews you _before_ building — surfaces unknowns, asks real multiple-choice questions instead of assuming.                                                         | "does this make sense?" / `/collaborate` |
| **gist**           | Fast orientation on a repo: 1–3 sentence summary + up to 5 sharp bullets.                                                                                              | "give me the gist" / `/gist`             |
| **open-questions** | Tracks blockers, decisions, and unknowns in an `open-questions.md` file. Powers the `/oq-*` commands.                                                                  | "track an open question"                 |
| **handoff**        | Compacts the current session into a handoff doc so a fresh session (or teammate) can pick up.                                                                          | "write a handoff"                        |
| **hand-in**        | The other half of handoff — lists saved handoff docs and loads the one you pick back into context.                                                                     | "resume from a handoff"                  |
| **fetch-ticket**   | **Teaching skeleton.** Pulls a ticket from your ticketing system via its MCP/plugin. Ships with `TODO(you)` blanks to fill in — read it to learn how skills are built. | "pull ticket ABC-123"                    |

### Commands (`open-questions` workflow)

| Command       | What it does                                                        |
| ------------- | ------------------------------------------------------------------- |
| `/oq-init`    | Create the `open-questions.md` file and register it in `CLAUDE.md`. |
| `/oq-scan`    | Scan the repo for TODO/FIXME/BLOCKED/etc. and add net-new items.    |
| `/oq-add`     | Add a question by hand, interactively.                              |
| `/oq-list`    | Print a tight numbered list of everything still open.               |
| `/oq-resolve` | Walk unresolved items and mark them resolved, one at a time.        |

---

## Suggested first week

1. **`/gist`** in a repo you know — see if Claude's summary matches reality. Builds
   trust and shows you how a skill reads a codebase.
2. **`/oq-init` then `/oq-scan`** — turn scattered TODOs into one tracked list.
3. **collaborate** — kick off a real task by saying "does this make sense?" and
   let it interview you before any code gets written.
4. **handoff → hand-in** — end a session with a handoff, resume it next day.
5. **fetch-ticket** — open the file, fill the three `TODO(you)` blanks against your
   ticketing system's MCP, and watch a skill go from skeleton to working tool.

---

## Writing your own

Open `.claude/skills/fetch-ticket/SKILL.md`. It's commented as a lesson — it walks
through the anatomy every skill shares:

1. **Frontmatter** (`name` + a trigger-rich `description`) — how Claude finds it.
2. **A body of plain instructions** — a numbered runbook with decision points.
3. **Delegation** — hard work (API calls, auth) lives in an MCP or CLI tool; the
   skill decides _when_ and _with what_, not _how_.
4. **Guardrails** — "ask, don't guess", "confirm before writes", "stop on
   ambiguity". This is what makes a skill safe to reuse.

To make a new one: copy any skill's folder, rename it, rewrite the frontmatter and
body. That's the whole loop.

---

Helpful learning resources:

- https://www.youtube.com/@tessl-ai
- https://www.youtube.com/@nateherk
- sign up for the anthorpic webinars

\_Gifted by Gerald Wheaton
