---
name: tdd
description: Test-driven development. Use when writing or fixing tests for a feature or bug on a factory PR, when the issue asks for test-first / red-green-refactor, or when adding integration tests. Guides the red → green loop so tests survive the CI mutation gate.
---

# Test-Driven Development

> Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).
> **ScaleBridge factory adaptation:** this runs on the headless implementer in
> GitHub Actions — there is no interactive user. Where the upstream skill says
> "confirm with the user", document the decision in the code instead (see the
> seams section). The CI pipeline runs the AUTHORITATIVE test-quality gates on
> your PR: **Stryker mutation testing** (break threshold 60) and **c8 coverage**.
> This skill is how you write tests that PASS those gates the first time —
> especially by avoiding tautological assertions, which pass coverage but die
> under mutation. **First action:** `Read` the two companion files in this
> directory — `tests.md` and `mocking.md` — before writing any test.

TDD is the red → green loop. This skill is the reference that makes that loop produce tests worth keeping: what a good test is, where tests go, the anti-patterns, and the rules of the loop. Every section applies on every cycle: consult them before and during the loop, not after.

When exploring the codebase, read `CONTEXT.md` (if it exists) so test names and interface vocabulary match the project's domain language, and respect ADRs in the area you're touching.

## What a good test is

Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't. A good test reads like a specification: "user can checkout with valid cart" tells you exactly what capability exists, and it survives refactors because it doesn't care about internal structure.

See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines. Read both before writing tests.

## Seams: where tests go

A **seam** is the public boundary you test at: the interface where you observe behavior without reaching inside. Tests live at seams, never against internals.

**Test only at deliberately-chosen seams.** Before writing any test, decide the seams under test. In this headless pipeline there is no user to confirm with, so **write the seams down as a comment block at the top of the test file** ("Seams under test: … / not tested here: …") before the first assertion. That comment is your contract and your reviewer's checkpoint. You can't test everything, so choosing the seams up front is how testing effort lands on the critical paths and complex logic instead of every edge case.

Ask yourself: "What's the public interface, and which seams should we test?" When the shape of that interface is itself in question (how deep the module is, where the seam belongs, what the interface should expose), reason about it inline using this vocabulary — **module, interface, depth, seam, adapter, leverage, locality** — and record the choice in the test-file comment or the PR body. If the interface design is genuinely blocked, escalate via the `ARCHITECT-QUESTION:` protocol in CLAUDE.md rather than guessing.

## Anti-patterns

- **Implementation-coupled**: mocks internal collaborators, tests private methods, or verifies through a side channel (querying the database instead of using the interface). The tell: the test breaks when you refactor but behavior hasn't changed.
- **Tautological**: the assertion recomputes the expected value the way the code does (`expect(add(a, b)).toBe(a + b)`, a snapshot derived by hand the same way, a constant asserted equal to itself), so it passes by construction and can never disagree with the code. **This is the anti-pattern the mutation gate exists to catch** — a tautological test survives no mutants and will fail CI. Expected values must come from an independent source of truth: a known-good literal, a worked example, the spec.
- **Horizontal slicing**: writing all tests first, then all implementation. Bulk tests verify _imagined_ behavior: you test the _shape_ of things rather than user-facing behavior, the tests go insensitive to real changes, and you commit to test structure before understanding the implementation. Work in **vertical slices** instead: one test → one implementation → repeat, each test a **tracer bullet** that responds to what the last cycle taught you.

## Rules of the loop

- **Red before green.** Write the failing test first, then only enough code to pass it. Don't anticipate future tests or add speculative features.
- **One slice at a time.** One seam, one test, one minimal implementation per cycle.
- **Refactoring is not part of the loop.** It belongs after the red → green implementation cycle — the CI code-review/QA gates and the built-in `/code-review` skill cover it. Don't refactor and add behavior in the same slice.
