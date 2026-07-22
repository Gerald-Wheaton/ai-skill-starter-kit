---
name: fetch-ticket
description: Pull a ticket from our ticketing system by ID, key, or a plain-language description, and load it into context to work on. Use when the user says "pull ticket ABC-123", "grab that bug about the login timeout", "what's in TICKET-42", "start on the X ticket", or similar. Also triggers on /fetch-ticket.
argument-hint: "A ticket ID/key (e.g. ABC-123) or a description of the ticket"
---

# Fetch Ticket

Pull one ticket from our ticketing system into context so we can work on it.

> **This is a teaching skeleton.** It works once you fill in the three numbered
> `TODO(you)` spots below — that's the whole point. Read top to bottom; the comments explain
> *why* each part exists, not just what to type. A skill is just Markdown
> instructions Claude follows — nothing more magic than that.

## Anatomy of what you're reading (start here)

Every skill is two parts:

1. **Frontmatter** — the block between the `---` fences at the very top. Only
   `name` + `description` are required. **The `description` is the trigger:** Claude
   reads it and decides on its own when to fire the skill, so it's stuffed with the
   exact phrases a teammate would type. Keep frontmatter clean — no comments inside
   the fences; some loaders choke on them, and this block is your worked example of
   getting it right. `argument-hint` is optional, shown when someone types the `/`
   command.
2. **The body** — everything below, loaded only *after* the skill fires. This is the
   runbook Claude follows: numbered steps, decision points, guardrails.

> **TODO(you) — tune the trigger.** Once this works, edit the `description` above to
> YOUR system's vocabulary: real ID formats, the word your team uses ("issue",
> "card", "story"), so Claude fires on the phrasing people actually use.

---

## The one thing to understand first

This skill does **not** talk to the ticketing API by hand (no curl, no auth code,
no JSON parsing). Instead it **delegates to the ticketing system's MCP server /
plugin** — a set of ready-made tools Claude can call directly. Your job in a skill
like this is orchestration: pick the right tool, pass the right input, shape the
result. The integration is already solved by the MCP.

```
  user request  ──▶  this skill (instructions)  ──▶  ticketing MCP tool  ──▶  ticket
                     "which tool? what input?"       "does the API call"
```

<!-- ─────────────────────────────────────────────────────────────────────────
TODO(you) #1 — NAME THE TOOLS.
Replace the placeholders below with the real tool names from your ticketing
MCP / plugin. To discover them: install the MCP, then ask Claude "what
<SYSTEM> tools do you have?" or check the server's tool list. Typical shapes:
  Jira      → mcp__atlassian__getJiraIssue, mcp__atlassian__searchJiraIssues
  Linear    → mcp__linear__get_issue, mcp__linear__list_issues
  GitHub    → (via `gh issue view` / `gh issue list` in Bash, no MCP needed)
Fill these two in and the skill comes alive:
  <GET_TICKET_TOOL>     — fetch a single ticket by exact ID/key
  <SEARCH_TICKET_TOOL>  — search tickets by text query
──────────────────────────────────────────────────────────────────────────── -->

## 1. Figure out what the user gave you

Look at the request and decide which case you're in:

- **An exact ID/key** (e.g. `ABC-123`, `#4217`) — go straight to step 2a.
- **A description** ("the login timeout bug", "that ticket Sarah filed Friday") —
  go to step 2b to search first.
- **Nothing usable** — ask which ticket, then stop and wait. Don't guess an ID.

## 2a. Fetch by ID

Call `<GET_TICKET_TOOL>` with the ID exactly as given.

<!-- TODO(you) #2 — once you know the tool's real parameter name, note it here,
     e.g. "pass the ID as `issueKey`". Small, but it saves Claude a guess. -->

If the tool returns "not found", tell the user the ID didn't resolve and ask them
to double-check it — don't silently fall back to a search.

## 2b. Find by description, then fetch

1. Call `<SEARCH_TICKET_TOOL>` with the user's description as the query.
2. Look at the results:
   - **Exactly one strong match** → fetch it (step 2a) and continue.
   - **Several plausible matches** → show the top few (ID + title + status) and
     use `AskUserQuestion` to let the user pick. Do not assume the first hit.
   - **No matches** → say so and ask for an ID or a better description. Stop.

## 3. Load it and confirm

Once you have the ticket, give a short recap so the user knows you grabbed the
right one — don't dump the raw payload:

- **Ticket:** ID + title
- **Status / assignee** (if the tool returns them)
- **The ask:** 1–2 sentences on what the ticket actually wants
- **Acceptance criteria** if present

Then ask what they want to do with it before starting any work. The ticket is now
your working context.

<!-- ─────────────────────────────────────────────────────────────────────────
TODO(you) #3 — DECIDE THE BOUNDARY (delete this block once decided).
Where does this skill stop? Options a team usually picks from:
  - Read-only: fetch + summarize, human does the work.  ← safe default, start here
  - Fetch + create a branch named after the ticket.
  - Fetch + post a comment back to the ticket when work is done (a WRITE — make
    that a deliberate, confirmed step, never automatic).
Whatever you choose, say it in one line at the top so the next person knows the
skill's job without reading all of it.
──────────────────────────────────────────────────────────────────────────── -->

---

## How to extend this (the lesson)

You just saw the anatomy of every skill:

1. **Frontmatter** — `name` + a trigger-rich `description`. This is what makes the
   skill discoverable.
2. **A body of plain instructions** — numbered steps, decision points, and rules.
   No special syntax; Claude reads it like a runbook.
3. **Delegation** — hard work (API calls, auth, pagination) belongs in an MCP or a
   CLI tool. The skill decides *when* and *with what*, not *how*.
4. **Guardrails** — "ask, don't guess", "confirm before writes", "stop on
   ambiguity". These are what make a skill trustworthy enough to reuse.

Next skills to try building the same way: fetch-PR, create-ticket (a write — add
a confirm step), stand-up-summary (read your last N tickets). Copy this file,
change the frontmatter, swap the tools.
