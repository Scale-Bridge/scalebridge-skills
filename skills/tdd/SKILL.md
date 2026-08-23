---
name: tdd
description: Test-driven development. Use when building features or fixing bugs test-first, when the user mentions "red-green-refactor", or wants integration tests. Interactive/local — confirm seams with the user.
---

# Test-Driven Development

> Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).
> Local/interactive copy. (The factory has a headless-adapted copy in each
> bootstrapped repo's `.claude/skills/tdd/`.) First action: `Read` the companion
> files `tests.md` and `mocking.md` in this directory before writing tests.

TDD is the red → green loop. This skill is the reference that makes the loop produce tests worth keeping: what a good test is, where tests go, the anti-patterns, and the rules of the loop. Consult these sections before and during the loop, not after.

When exploring the codebase, read `CONTEXT.md` (if it exists) so test names and vocabulary match the project's domain language, and respect ADRs in the area you're touching.

## What a good test is
Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't. A good test reads like a specification and survives refactors because it doesn't care about internal structure. See [tests.md](tests.md) and [mocking.md](mocking.md).

## Seams: where tests go
A **seam** is the public boundary you test at — the interface where you observe behavior without reaching inside. Tests live at seams, never against internals. **Confirm the seams with the user before writing tests** — you can't test everything, so agreeing the seams up front lands testing effort on the critical paths and complex logic. Ask: "What's the public interface, and which seams should we test?" (When the interface shape itself is in question — how deep the module is, where the seam belongs — reason about it with the vocabulary of module / interface / depth / seam / adapter / leverage / locality.)

## Anti-patterns
- **Implementation-coupled**: mocks internal collaborators, tests private methods, or verifies through a side channel. The tell: breaks on refactor when behavior hasn't changed.
- **Tautological**: the assertion recomputes the expected value the way the code does, so it passes by construction. Expected values must come from an independent source of truth: a known-good literal, a worked example, the spec.
- **Horizontal slicing**: all tests first, then all implementation. Work in **vertical slices** — one test → one implementation → repeat, each test a tracer bullet responding to what the last cycle taught you.

## Rules of the loop
- **Red before green.** Failing test first, then only enough code to pass it. No speculative features.
- **One slice at a time.** One seam, one test, one minimal implementation per cycle.
- **Refactoring is not part of the loop.** It belongs after the red → green cycle (see `/code-review`), not during it.
