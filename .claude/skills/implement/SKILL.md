---
name: implement
description: The implementer's execution loop for a scoped GitHub issue — TDD at seams, verify continuously, self-review, bulletproof, open a PR. Use when implementing a claude-labeled issue in the factory.
---

# Implement (factory execution loop)

> Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).
> This codifies the loop the `claude.yml` prompt already mandates, in one tunable
> place. It is for the **stateless factory implementer** executing ONE
> already-sized issue. It does NOT decompose or plan across issues — Hermes owns
> that; an oversized issue is escalated (ARCHITECT-QUESTION / relay), never
> self-split.

Implement exactly the work the linked issue describes — its Goal + Acceptance criteria, honoring Constraints, touching nothing under Out of scope.

1. **Understand the issue.** Read it with `gh issue view` + comments, this repo's `CLAUDE.md`, and `PROGRESS.md` if present. If a design decision is genuinely ambiguous, do NOT guess — post `ARCHITECT-QUESTION:` (question + options + constraints) and stop; the architect answers in-thread and resumes you.
2. **Red-green at seams.** Use the `tdd` skill: write the failing test first at a deliberately-chosen seam, then the minimal code to pass it. One vertical slice at a time. Tests must assert behavior (they face the mutation gate), never pad coverage.
3. **Verify continuously.** Run typecheck + single test files as you go; run the full suite + lint + build once in the FOREGROUND before finishing. The CI pipeline owns the authoritative coverage + mutation gates — do NOT run mutation testing yourself, and never background a long job and poll it.
4. **If something breaks**, use `diagnosing-bugs` (repro-first) rather than guessing.
5. **Self-review before the PR** against the issue: every acceptance criterion met, every Constraint honored, nothing out-of-scope added, nothing silently dropped. (The QA gate re-checks this adversarially, including a spec-axis drift check — don't rely on it to catch what you can catch here.)
6. **`bulletproof` before done** — run the interrogation, publish the "## Verified before building" + "## Bulletproof check" + "## Issue suggestions" sections in the PR body.
7. **Open the PR** whose body includes `Closes #<n>` (or push to the existing branch). Commit and push after every completed unit of work so a relay successor can resume. Never push to main; never modify `.github/workflows/**`.
