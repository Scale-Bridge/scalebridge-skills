---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea before work begins. Use when the user wants to stress-test their thinking, is scoping a new feature/decision, or uses any 'grill' trigger phrase. Pre-implementation, human-in-the-loop.
---

> Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).
> **Note:** pre-implementation design elicitation — needs a human to interview,
> so it's interactive only. If the project also has a self-applied, post-hoc
> adversarial check (e.g. a "bulletproof" protocol), they're complementary:
> grilling is up-front and user-facing; that one is before-you-declare-done.

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.

## Handoff (before ending)

A grilling session that ends only in chat is half-wasted. Once the frontier is empty and the user confirms shared understanding, **offer to capture the agreed decisions as a durable artifact** using the project's own conventions — an ADR when it's an architectural/tooling decision, an issue/ticket body when it's work to be filed, or a note in the project's progress/planning file otherwise. Draft it, show the user, and only persist on their confirmation.
