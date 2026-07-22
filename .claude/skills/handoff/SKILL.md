---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save to the user's project level Claude instance at /handoffs/ directory. If they do not have a folder at the project's root level for handoffs, create one and dump this file there.

Handoff files should be named `handoff-{random 4 digit number}.md`

Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.

Include in the handoff document this information:

- **Goal**: What we're trying to accomplish
- **Current Progress**: What's been done so far
- **What Worked**: Approaches that succeeded, if relevant
- **What Didn't Work**: Approaches that failed, if reelvant (so they're not repeated)
- **Next Steps**: Clear action items for continuing

When you finish producing this doucment DO NOT explain what was handed off. Just say "handoff document completed", so as to preserve output tokens.
