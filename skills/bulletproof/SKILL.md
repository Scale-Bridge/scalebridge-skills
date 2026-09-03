---
name: bulletproof
description: >
  MANDATORY before declaring any work done, opening a PR, or issuing a gate
  verdict: run the bulletproof interrogation against your own output, publish
  the answers, and convert out-of-scope findings into issue suggestions.
---

# STEP 0 — VERIFY BEFORE YOU BUILD (mandatory, ordered, produces an artifact)

Two failure classes cause almost every late defect, and each has its own fix.
Run BOTH before writing code that depends on anything you didn't author:

1. **SEARCH the web / primary source** for every EXTERNAL-system fact you're
   about to rely on — a tool's flag, a package name/version, an API shape, a
   unit, an event's semantics, a default, a platform behavior. Memory and doc
   *summaries* are hypotheses, not facts. Get the primary source (official
   docs, the package registry, the actual API response).
2. **TEST from first principles** — don't trust even the primary source's
   prose; run the smallest experiment that proves the behavior, and prove it in
   BOTH directions (the thing works AND the failure/guard actually fires). A
   check that cannot fail proves nothing (a validator that always passes, an
   exit code captured from the wrong command).
3. Only THEN build on it.

**Publish the results** in a `## Verified before building` section of the PR
(or, for a gate, in your evidence): one line per external fact — `<claim> |
<how verified: search URL or probe command> | <result>`. A PR that adds a
dependency or touches an external system WITHOUT this section is incomplete,
and the QA/security gate flags its absence as a finding. This is the mechanical
teeth: the reflex is enforced by a required, checkable artifact, not by memory.

(Every late defect in this factory traced to skipping step 1 or 2 — pnpm's unit
was minutes-not-days, `npx stryker` was the wrong package, a security field was
delivered empty. Nothing probed-first ever produced a late surprise.)

# The bulletproof interrogation (mandatory, self-applied)

**"Bulletproof" is a GATE, not a summary.** The word may be used only when the
gap list contains ZERO items testable by you. A testable gap is not a
disclosure — it is a work queue: test it NOW, without offering, without asking,
without weighing token cost (cost is the owner's variable — surface it, never
use it to defer mandated verification). Publishing a gap list and concluding
anyway is confession as a substitute for correction, and it is forbidden. Only
gaps untestable by you may remain, and then the only permitted claim is:
"proven except: <named gaps + who can test them>".

Answer ALL of these about your own work product, in writing, before you call
it done. Publishing the answers (including the uncomfortable ones) is part of
the deliverable — a PR or verdict without them is incomplete.

1. **How does this fail?** Concrete failure modes: under load, under malicious
   input, over time (drift, expiry, dependency rot), at scale, when an
   upstream API/tool changes.
2. **What are the gaps?** What did you NOT test or verify? Anything verified
   only by inspection is NOT proof — execute it or list it as a gap.
3. **Rival-critique test:** if a competing AI (ChatGPT) were reviewing this
   work to convince the user to switch away, what would it seize on? Fix that
   before shipping. For stamp-grade claims this question is EXECUTED, not
   answered from imagination — spawn the rival (see the outside-frame gate).
4. **Symptom or root cause?** If any part of this patches a symptom, say so
   explicitly and name the root cause.
5. **Blast radius:** if this is wrong, what downstream code, data, or process
   breaks?
6. **Six-month test:** which assumptions rot — versions, names, rate limits,
   API shapes, magic values?
7. **Auditor passes:** what would a security auditor flag? What would a cost
   auditor flag?
8. **Debt check:** does this add ANY technical debt? Then it is not done — it
   is deferred work wearing a label. Either fix it or declare it as a finding.

## Non-negotiables for guards and external systems

- **Guard proof:** any guard, limit, or threshold ships only with its FAILURE
  side demonstrated against a HAND-BUILT violation. Agent-built violations are
  circular (a working guard prevents the agent from constructing one), and
  "fails safe by construction" does not cover the silent-no-op case — a guard
  that never engages looks exactly like success. **Per-axis, never an OR:** a
  claim covering multiple detection axes (raw AND formatted, element AND MIME
  reference, transcript AND summary) needs one independent failure proof per
  axis — one violation carrying every payload yields a single binary verdict
  that any one axis can satisfy while the others stay unproven.
- **Alien-system rule:** any external-system behavior this work depends on —
  units, event semantics, defaults, identity/permission behavior — is probed
  empirically before building on it. Doc summaries and memory state hypotheses,
  not facts. (Empirically: every late-found defect in this factory came from an
  unprobed assumption; nothing probed first ever produced a late surprise.)

## Fix-pass and iteration discipline (adversarial loops)

Measured across a 30+-round adversarial review program: roughly HALF of all
late findings lived inside the previous iteration's own fix text. Three rules
collapse that tail:

1. **Gate-site self-check before handing off:** every fixture, test, or gate
   your fix PROMISES must verifiably exist at its gate site (the milestone
   accept, the test file, the CI config) — not just at the claim site where
   the promise is written. Then residue-grep every term your fix touched;
   stale echoes of the pre-fix wording survive in cross-references almost
   every time.
2. **State-machine fixes get the full cross-product immediately:** if the fix
   touches writers × states × timings (retries, upgrades, redeliveries),
   enumerate the whole cross-product NOW — a reviewer's single finding must
   never set the fix's scope, or the mechanism leaks one path per iteration.
3. **New design content gets the definitional walk:** a new fixture, route,
   field, or enum value authored mid-loop must be walked through EVERY
   definition it touches (vocabularies, tables, schemas, seam contracts)
   before it lands — patch discipline is not enough for design content.

## The outside-frame gate (stamp-grade claims)

Self-interrogation has a measured ceiling: the eight answers above come from
inside the author's frame, so they catch what the frame can see and pass what
it cannot. (Measured 2026-09-03, five-PRD program: 49 fresh-context reviewer
rounds — every reviewer briefed with the author's scope map — stamped the set
BUILD-READY; one from-zero audit briefed with nothing found 4 CRITICAL /
10 HIGH; independent adjudication confirmed 12 of 14, refuted 0. Every
confirmed CRITICAL was system-altitude — failure domains, end-to-end SLOs vs
the sold promise, vendor delivery contracts, capacity — while all 49 rounds
worked at document altitude. Fresh CONTEXT is not fresh FRAME.)

For a STAMP-GRADE claim — done / accepted / build-ready / "bulletproof" on an
artifact others will build on — the self-applied interrogation is necessary
and NEVER sufficient. The stamp additionally requires an outside-FRAME pass:

1. **Map-free brief.** The outside reviewer receives the artifact and the
   DOMAIN's requirements only — never the author's scope map, status ledger,
   fix history, or review narrative. An author-briefed reviewer is the
   author's frame wearing a fresh context; the map standardizes the blindness.
   Cross-model when available.
2. **Absence review.** Enumerate what the domain demands (monitoring
   independence, capacity/arrival model, an end-to-end SLO for every sold
   promise, failure-domain separation, PII lifecycle incl. the vendor side,
   DR incl. adversarial deletion, rollout/rollback) and check for MISSING
   sections. Gate-site tooling — greps, fixture checks, cross-products —
   interrogates only text that exists; defects hide in text, blockers hide
   in absences.
3. **Register re-grade at stamp time.** Walk every open debt / deferred /
   UNVERIFIED / register line the moment the stamp is proposed. An open item
   that contradicts a sold promise blocks the stamp. Acknowledged ≠ resolved —
   a register that turns blockers into ledger lines is laundering severity.
   (Measured: a ≈2× promise-clock contradiction was disclosed in two debt
   registers and still rode under BUILD-READY.)
4. **No exemptions.** Every artifact the stamped thing builds on (schema
   annexes, research docs, configs) passes the same gate. Self-review
   ("orchestrator-interrogated") satisfies nothing. (Measured: the one
   artifact exempted from the loop carried the program's only
   unsatisfiable-gate CRITICAL, in exactly its never-reviewed sections.)
5. **Vendor discovery, not just verification.** For each critical path, read
   the vendor's contract pages FOR THAT PATH — defaults, limits, queues,
   retention, failure behavior — not only the pages already cited.
   Re-verifying citations proves what you claimed; it cannot discover the
   uncited load-bearing fact. (Measured: retries-off-by-default, a 1-CPS
   outbound queue, and versioning-off storage all lived on never-cited pages;
   40/40 citation re-checks passed while all three stayed invisible.)
6. **Adjudicate both directions.** Outside findings are verified against
   current text (CONFIRMED / PARTIAL / REFUTED, with quotes) before
   acceptance — auditors err too (measured: 2 of 14 findings partially
   refuted, incl. a missed existing load-test gate).

## Where the answers go

- **Implementer:** a `## Bulletproof check` section in the PR body — honest
  answers, including named gaps.
- **Gate agents:** fold the relevant answers into your verdict evidence.

## Issue suggestions (out-of-scope findings)

Anything real you noticed that is OUTSIDE your task's scope — a gap, debt,
missing test, design smell — must NOT be fixed silently (scope discipline)
and must NOT be dropped. Emit it in the PR body under `## Issue suggestions`,
one per line:

```
ISSUE-SUGGESTION: <imperative title> — <root cause / evidence / why it matters>
```

The human/orchestrator triages every suggestion (right-way / zero-debt / root-cause /
fits-the-vision) and stages accepted ones as real tasks. Suggest freely; they filter. Never create issues yourself.
