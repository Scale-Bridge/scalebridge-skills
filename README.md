# scalebridge — shared engineering skills

A Claude Code plugin that packages ScaleBridge's shared engineering skills and
agents as one installable source, so they no longer need to be hand-copied into
every repository.

## Install (Claude Code)

```
/plugin marketplace add https://github.com/Scale-Bridge/scalebridge-skills.git
/plugin install scalebridge@scalebridge
```

Skills then invoke as `/scalebridge:<name>` — e.g. `/scalebridge:bulletproof`.

## Skills

`bulletproof`, `domain-modeling`, `tdd`, `diagnosing-bugs`, `grilling`,
`handoff`, `wait-what`, `resolving-merge-conflicts`, `wizard`, `prototype`,
`to-questionnaire`. Generic sub-agents live in `agents/`.

## Hermes sync (non-Claude-Code consumers)

The Hermes agent consumes the **shared** subset by file sync rather than
`/plugin install`: `scripts/sync-hermes.sh` clones this repo at `main` and
copies the shared skills into the Hermes data volume and selected profiles.
Run `scripts/sync-hermes.sh --dry-run` to preview.

## Credit

Several skills are inspired by and adapted from
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT).

## License

MIT — see [LICENSE](LICENSE).
