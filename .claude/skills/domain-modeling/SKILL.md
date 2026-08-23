---
name: domain-modeling
description: Actively build and sharpen a project's domain model — challenge terms, sharpen fuzzy language, stress-test with scenarios, and write the glossary/decisions down as they crystallise. Use at greenfield/bootstrap before code is written, and when discussing codebase terminology or recording a decision.
---

# Domain Modeling

> Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).
> **ScaleBridge adaptation — outputs align to OUR conventions (do not import Matt's file formats):**
> - **Glossary** lives in a dedicated `## Glossary` section of the relevant `CONTEXT.md`, or a `docs/GLOSSARY.md` — it does NOT replace our per-directory `CONTEXT.md` (which is spec/status, not a pure glossary). Keep the glossary free of implementation detail.
> - **ADRs** go in `docs/ADR/` using OUR numbered, immutable format (next number per `.claude/rules/context-sync.md`). ADR decisions are immutable — a change of mind is a NEW ADR, never an edit.
> - **Highest-value moment: greenfield / bootstrap.** Run this before the first feature of a fresh repo to establish the vocabulary and interfaces up front (e.g. a RAG repo: chunk / contextualized chunk / embedding / dense vs sparse retrieval / RRF fusion / rerank / ingest vs query). This is an orchestrator/bootstrap activity (local Claude Code or Hermes), not the per-issue stateless implementer's job.
> - This is the ACTIVE discipline (changing the model). Merely *reading* CONTEXT.md for vocabulary is a one-line habit any skill does — not this skill.

Actively build and sharpen the project's domain model as you design: challenge terms, invent edge-case scenarios, and write the glossary and decisions down the moment they crystallise. Create files lazily — only when you have something to write.

## During the session

### Challenge against the glossary
When a term conflicts with the existing language, call it out immediately. "The glossary defines 'cancellation' as X, but you seem to mean Y. Which is it?"

### Sharpen fuzzy language
When a term is vague or overloaded, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios
Stress-test domain relationships with specific scenarios that probe edge cases and force precision about the boundaries between concepts.

### Cross-reference with code
When someone states how something works, check whether the code agrees; surface contradictions. "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Capture inline
When a term is resolved, write it to the glossary right then (don't batch). Keep the glossary a glossary — no implementation details, no spec, no scratchpad.

### Offer ADRs sparingly
Only offer an ADR when ALL three hold: (1) hard to reverse, (2) surprising without context, (3) the result of a real trade-off with genuine alternatives. If any is missing, skip it. Use our `docs/ADR/` numbered immutable format.
