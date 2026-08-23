# CLAUDE.md — scalebridge-skills

This is a **content repo**: a Claude Code plugin (markdown skills + JSON
manifests + one shell script). It is NOT a Node/pnpm project — no build, no
test framework.

## Layout
- `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` — manifests
- `skills/<name>/SKILL.md` — packaged skills (invoke as `/scalebridge:<name>`)
- `agents/*.md` — generic sub-agents
- `scripts/sync-hermes.sh` — syncs the shared skills into the Hermes volume

## Verify
- `claude plugin validate .`
- `jq . .claude-plugin/plugin.json .claude-plugin/marketplace.json`
- `shellcheck scripts/sync-hermes.sh && bash -n scripts/sync-hermes.sh`
- `gitleaks detect --source . --no-banner`

## Rule
Commit messages and PR bodies must not name the authoring tool (CI enforces a
git-log check). README/docs prose may name Claude Code where needed.
