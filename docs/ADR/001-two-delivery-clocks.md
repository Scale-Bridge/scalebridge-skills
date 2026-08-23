# ADR-001: Use two consumer clocks

- **Status:** Accepted
- **Date:** 2026-08-23

## Context

The plugin consumers need reproducible CI runs. Local development and Hermes need timely access to Jimmy-merged skill updates. One update clock cannot provide both properties without adding another release mechanism.

## Decision

CI consumers pin a released plugin version. Local development and Hermes track the latest approved state. Plugin manifest versions, marketplace versions, and release tags move in lockstep. Hermes sync reads only `main`.

## Consequences

The two consumers can temporarily run different skill versions. This is intentional. Release pins change deliberately after validation. The repository must document which paths pin and which paths track latest.
