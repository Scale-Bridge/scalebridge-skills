# Context

## Purpose

This repository is the canonical public source for shared ScaleBridge engineering skills. Claude Code consumes it as a versioned plugin. Hermes consumes the shared subset through an allowlisted file sync.

## Glossary

- **Skill:** A `SKILL.md` file with `name` and `description` frontmatter plus a procedure. A skill is model-agnostic.
- **Plugin:** A directory with `.claude-plugin/plugin.json` and optional component directories. Claude Code installs a plugin.
- **Marketplace:** A repository with `.claude-plugin/marketplace.json` that lists installable plugins.
- **Shared skill:** A model-agnostic skill used by both Claude Code and Hermes.
- **Claude-Code-only component:** A skill or agent used only through the plugin delivery path.
- **Hermes-only skill:** An orchestration skill that remains outside this repository.
- **Consumer:** A system that loads these skills. The consumers are Claude Code and Hermes.
- **Factory:** The delivery loop from a scoped GitHub issue through implementation, gates, human review, and merge.
- **Pinned consumer:** A consumer that intentionally uses a released plugin version for reproducibility.
- **Latest consumer:** A consumer that intentionally tracks the latest Jimmy-merged state.
- **Sync:** An idempotent copy of the shared-skill allowlist from `main` into the Hermes skill locations.
