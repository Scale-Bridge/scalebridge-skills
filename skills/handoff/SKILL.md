---
name: handoff
description: Compact the current conversation into a handoff document for a fresh session to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

> Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).
> **Note:** interactive, developer-machine use. A handoff doc **supplements**
> the project's own continuity system, it does not replace it, and it must not
> drift from it.

Write a handoff document summarising the current conversation so a fresh agent can continue the work.

- **Save location:** write it into the project's tracked planning area (e.g. `.planning/handoff-<topic>.md` or `PROGRESS.md` alongside it) — **not** the OS temp dir — so it's versioned and discoverable. State at the top that the project's canonical sources outrank this doc, and name them (its progress/planning file, `CONTEXT.md`, ADRs, any persistent memory). The next session must read those, not just this handoff.
- **Don't duplicate** content already captured in specs, plans, ADRs, issues, commits, diffs, or those canonical sources — reference them by path or URL instead.
- **Suggested skills** section: name only skills that actually exist in this project (check `.claude/skills/` and `~/.claude/skills/`). Do not invent skill names.
- **Redact aggressively.** Beyond generic API keys / passwords / PII, redact anything credential-shaped for this project: tokens, webhook secrets, credential IDs, per-service keys. When in doubt, `<REDACTED>`.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.
