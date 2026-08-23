---
name: to-questionnaire
description: Turn a decision you can't fully answer into a questionnaire for someone else to fill in async. Use when the knowledge lives with another person (a client, a domain expert, Jimmy) and you need structured answers back.
disable-model-invocation: true
---

> Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).
> Async structured elicitation — for local Claude Code and (once ported to the
> Hermes skill format) for Hermes to pull decisions out of Jimmy without a live
> back-and-forth.

Turn something the user can't answer alone into a **questionnaire**: a Markdown document handed to one person to fill in async (or filled together in a meeting). The recipient holds knowledge the user lacks; the questionnaire pulls it out.

**Grill the send, not the subject.** Interview the user only about the _send_, which they can always answer: who it goes to, and what they need back. The questions in the document then target the **gap** between what the recipient knows and what the user needs.

1. **Who is it going to?** In one exchange: the recipient's role, expertise, and relationship to the user. This fixes tone and how much context the doc must carry. Done when you know who they are and what they know that the user doesn't.
2. **What do you need back?** In one exchange: the specific decisions or facts the user can't resolve alone. Done when you have a concrete list of what the user must walk away able to do or decide.
3. **Write the questionnaire.** Draft questions aimed at that gap. Write it to `to-questionnaire-<slug>.md` in the current directory (or `.planning/` if the project keeps working docs there) and report the path. Done when the file exists and every item from step 2 is covered.

## Document structure

Frame it as a **discovery questionnaire**: the user lacks context, the recipient holds it. Order questions most-important-first (async means you may get one pass), and group under `##` themes once there are more than a handful.

```
# <Questionnaire title>

**Purpose:** why this exists and the decision riding on it.
**From:** <user>  **To:** <recipient>  **How your answers will be used:** <where they go>

## Context
One paragraph orienting a recipient who wasn't in the user's head. Enough to answer well, not a page.

## How to answer
Deadline and rough effort. Partial answers and "I don't know" are useful — flag uncertainty rather than skipping.

## <Theme heading>
One `##` section per theme, questions most-important-first. Every question is one idea (never compound), an answer stub beneath it, and a one-line _why this matters_ only where it could be misread.

### <A single, non-compound question>
_Why this matters: <only if needed>._
>

## Anything else?
Closing catch-all: anything we didn't ask that we should know?
```
