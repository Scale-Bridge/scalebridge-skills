---
name: bulletproof
description: >
  MANDATORY before declaring any work done, opening a PR, or issuing a gate
  verdict: verify externals first, search for the shipped solution before
  designing one, run the interrogation, and gate stamp-grade claims through
  the Baseline-anchored two-round outside pass. Industry standard is the
  floor, plus one named differentiator that beats it.
---

# What "bulletproof" means here

Industry standard is the FLOOR, never the target: match how the category's
best actually ship, then beat them in one NAMED place — the differentiator.
Excellence is concentrated, not smeared: above-floor effort that serves no
differentiator is over-engineering (a reportable finding), and a
"differentiator" at mere parity with the standard is a broken promise (also
a finding). The word "bulletproof" keeps its hard price — zero gaps testable
by you — and green keeps its: a CLEAN outside pass, zero unresolved
findings. The Baseline aims the loop and research shrinks it; neither ever
lowers it.

# STEP 0 — verify before you build

For every external fact you rely on (flag, version, API shape, unit,
default, event semantics): (1) fetch the primary source — memory and doc
summaries are hypotheses; (2) probe the behavior in BOTH directions — it
works AND the guard/failure actually fires; a check that cannot fail proves
nothing, so hand-build the violation, one proof per detection axis; (3) only
then build. Publish one line per fact in `## Verified before building`:
`<claim> | <how verified> | <result>`. A PR touching an external system
without this section is incomplete.

# STEP 1 — search for the shipped solution before designing one

Before designing any mechanism, spend one research pass (web search or a
deep-research spawn): does the chosen vendor, an adjacent tier, or the
category's standard practice already ship this? Research is orders of
magnitude cheaper than a design round — going in a circle is the expensive
failure, not the search. A found solution converts the task from "build" to
"adopt + verify". (Measured: one vendor-tier answer deleted a four-round
scaffolding cluster — `docs/audits/gate-evidence.md`.)

# The interrogation (self-applied, answers published)

Answer in writing before any done-claim; a PR or verdict without the answers
is incomplete. A gap you can test is a work queue, not a disclosure — test
it now. Cost never waives a mandated check and never curtails the loop —
compute is not a reason to stop; cost discipline is research-before-rounds
and model routing, never fewer rounds or skipped verification.

1. How does this fail? Load, malicious input, drift, scale, upstream change.
2. What did you NOT verify? Inspection is not proof — execute it or list it.
3. Rival-critique: what would a competing AI seize on to take this account?
   For stamp-grade claims this is EXECUTED via the outside pass, not
   imagined.
4. Symptom or root cause?
5. Blast radius: what breaks downstream if this is wrong?
6. Six-month rot: which assumptions expire?
7. What would a security auditor flag? A cost auditor?
8. Any debt added? Fix it or declare it as a finding.
9. Bar check, BOTH directions: what here sits above the industry floor
   without serving the differentiator — delete it; and is the differentiator
   still demonstrably AHEAD of the industry standard — prove it, never
   assert it.

## Fix authoring (measured: ~half of late findings live in fix text)

Walk every promise a fix makes to its named gate site (the test file, the
CI config, the milestone accept) — not just the claim site; residue-grep
every term you touched; give state-machine fixes the full writers × states ×
timings cross-product immediately, never one leaked path per round.

## Stamp-grade claims: the Baseline-anchored gate

Stamp-grade = anything another agent, workflow, or milestone builds on,
regardless of label — any doubt resolves to stamp-grade. Policy and record
format: the consuming repo's `.claude/rules/definition-of-done.md`. Reviewer
procedure: this plugin's `agents/reviewer.md` (`scalebridge:reviewer`).

1. **Baseline first — researched, then owner-ratified.** Never ask the
   owner cold: one research pass establishes the sold promises verbatim;
   the industry-standard floor (how do the category's best ship this?);
   THE differentiator — the named place this artifact beats the standard;
   the chosen vendor path/tier (best-in-class named first); explicit v1
   exclusions. No Baseline, no gate.
2. **Judgment rounds.** Map-free outside-frame audits against the Baseline:
   committed reviewer definition, cross-model preferred — vary the FRAME
   between rounds; same-frame repetition adds nothing (measured worthless
   at n=49). More rounds are always allowed; more of the same frame is not.
3. **Decisions — proxy, never park.** DECISION-REQUIRED findings (cheapest
   resolution is a decision above the artifact: vendor tier, scope, promise
   change) are DECIDED in-loop by the agent as owner-proxy from the owner's
   standing philosophy — never half-ass, attack the root cause, operate in
   good faith, do good business, win first — with the researched options
   and the ruling logged in the stamp record's Decisions section for owner
   audit at merge. Interrupt the owner ONLY when truly blocked or dire:
   irreversible external/legal/financial commitments, real spend, conflict
   with an explicit owner ruling, or a block only the owner can clear.
4. **Fix pass.** Every finding, root cause first. ≥3 findings clustering in
   one subsystem → research that domain's standard BEFORE spec-editing (a
   cluster is often one vendor decision in disguise).
5. **Verification pass.** Every fix present at its named gate site, residue
   clean. A new finding inside a fix loops again — fix it and re-verify.
6. **LOOP UNTIL GREEN.** Green = a CLEAN pass: zero unresolved findings.
   Every finding resolves exactly one way — fixed at its gate site ·
   collapsed by research/vendor adoption (STEP 1) · refuted with
   independent adjudication · or, if genuinely outside this artifact's
   scope, converted to an ISSUE-SUGGESTION with the proxy ruling logged.
   Nothing ships parked, downgraded, or ledger-laundered — green is never
   redefined downward. No round cap and compute is never a reason to stop:
   new legit findings in later rounds are the loop WORKING; research exists
   to prevent the avoidable ones, not to excuse them. Findings that sit
   above the floor serving no differentiator resolve by DELETION — that too
   is a fix. Record burn per round and validate the record with the
   consuming repo's `scripts/validate-stamp.sh`.

## Issue suggestions

Out-of-scope findings are never fixed silently and never dropped:
`ISSUE-SUGGESTION: <imperative title> — <evidence / why it matters>` in the
PR body; the orchestrator triages every suggestion. Never create issues
yourself.
