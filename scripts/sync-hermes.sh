#!/usr/bin/env bash
# sync-hermes.sh — copy the SHARED scalebridge skills into the Hermes volume + profiles.
# Idempotent, safe to re-run. Reads the `main` ref only. See PRD §8.
set -uo pipefail

REPO_URL="https://github.com/Scale-Bridge/scalebridge-skills.git"
REF="main"
VOLUME="/var/lib/docker/volumes/hermes_hermes-data/_data"
PROFILES="coder,reviewer"
DRYRUN=0

# Hard-coded SHARED allowlist — never the Claude-Code-only components (implement, agents).
SHARED=(bulletproof domain-modeling tdd diagnosing-bugs grilling handoff wait-what resolving-merge-conflicts wizard prototype to-questionnaire)

usage() { echo "usage: sync-hermes.sh [--repo-url URL] [--ref REF] [--volume PATH] [--profiles LIST] [--dry-run]"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --repo-url) REPO_URL="$2"; shift 2 ;;
    --ref)      REF="$2"; shift 2 ;;
    --volume)   VOLUME="$2"; shift 2 ;;
    --profiles) PROFILES="$2"; shift 2 ;;
    --dry-run)  DRYRUN=1; shift ;;
    -h|--help)  usage; exit 0 ;;
    *) echo "unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

# Security rule: main only. No override flag by design.
if [ "$REF" != "main" ]; then
  echo "ERROR: refusing to sync from non-main ref '$REF' (main only)." >&2
  exit 2
fi

LOCK="/tmp/sync-hermes.lock"
exec 9>"$LOCK" || { echo "ERROR: cannot open lock $LOCK" >&2; exit 1; }
if ! flock -n 9; then echo "ERROR: another sync is already running" >&2; exit 3; fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if ! git clone --depth 1 --branch "$REF" "$REPO_URL" "$TMP/repo" >/dev/null 2>&1; then
  echo "ERROR: clone of $REPO_URL@$REF failed" >&2; exit 1
fi
SRC="$TMP/repo/skills"
TS="$(date +%Y%m%d-%H%M%S)"

IFS=',' read -r -a PROFILE_ARR <<< "$PROFILES"
TARGETS=("$VOLUME/skills")                       # default profile = volume root
for p in "${PROFILE_ARR[@]}"; do
  [ "$p" = "default" ] && continue               # covered by the volume-root write
  TARGETS+=("$VOLUME/profiles/$p/skills")
done

synced=0
for skill in "${SHARED[@]}"; do
  if [ ! -d "$SRC/$skill" ]; then
    echo "WARN: shared skill '$skill' not present in repo — skipping" >&2
    continue
  fi
  for dest in "${TARGETS[@]}"; do
    if [ "$DRYRUN" = "1" ]; then
      echo "[dry-run] $skill -> $dest/$skill"
      continue
    fi
    mkdir -p "$dest"
    [ -d "$dest/$skill" ] && mv "$dest/$skill" "$dest/$skill.bak-$TS"
    cp -a "$SRC/$skill" "$dest/$skill" || { echo "ERROR: copy failed: $skill -> $dest" >&2; exit 1; }
    chown -R 0:0 "$dest/$skill" 2>/dev/null || true
  done
  synced=$((synced + 1))
done

if [ "$DRYRUN" = "1" ]; then
  echo "[dry-run] $synced shared skills would sync to: ${TARGETS[*]}"
else
  echo "synced $synced shared skills to: ${TARGETS[*]}"
fi
exit 0
