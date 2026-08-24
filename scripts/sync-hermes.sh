#!/usr/bin/env bash
# sync-hermes.sh — copy the SHARED scalebridge skills into the Hermes volume + profiles.
# Idempotent (unchanged = no-op). Reads main only. Args are allowlist-validated policy
# assertions, not free overrides — invalid input exits 2 before any network/lock/fs access.
# See PRD §8.
set -uo pipefail

APPROVED_REPO_URL="https://github.com/Scale-Bridge/scalebridge-skills.git"
APPROVED_VOLUME="/var/lib/docker/volumes/hermes_hermes-data/_data"
APPROVED_PROFILES=" coder researcher reviewer sandbox scalebridge "   # padded for word-match
SHARED=(bulletproof domain-modeling tdd diagnosing-bugs grilling handoff wait-what resolving-merge-conflicts wizard prototype to-questionnaire)

REPO_URL="$APPROVED_REPO_URL"
REF="main"
VOLUME="$APPROVED_VOLUME"
PROFILES="coder,reviewer"
DRYRUN=0

usage() { echo "usage: sync-hermes.sh [--repo-url URL] [--ref main] [--volume PATH] [--profiles LIST] [--dry-run]"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --repo-url) REPO_URL="$2"; shift 2 ;;
    --ref)      REF="$2"; shift 2 ;;
    --volume)   VOLUME="$2"; shift 2 ;;
    --profiles) PROFILES="$2"; shift 2 ;;
    --dry-run)  DRYRUN=1; shift ;;
    -h|--help)  usage; exit 0 ;;
    *) echo "ERROR: unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

# ---- Step 1: allowlist validation (pure string checks, before ANY network/lock/fs) ----
[ "$REPO_URL" = "$APPROVED_REPO_URL" ] || { echo "ERROR: --repo-url not on allowlist" >&2; exit 2; }
[ "$REF" = "main" ]                    || { echo "ERROR: --ref must be main" >&2; exit 2; }
[ "$VOLUME" = "$APPROVED_VOLUME" ]     || { echo "ERROR: --volume not on allowlist" >&2; exit 2; }
IFS=',' read -r -a PROFILE_ARR <<< "$PROFILES"
seen=""
for p in "${PROFILE_ARR[@]}"; do
  case "$p" in *[!a-z]*) echo "ERROR: illegal profile token '$p'" >&2; exit 2 ;; esac   # a-z only: no traversal/dots/slashes
  [ "$p" = "default" ] && { echo "ERROR: do not pass 'default' (served by the volume-root write)" >&2; exit 2; }
  case "$APPROVED_PROFILES" in *" $p "*) : ;; *) echo "ERROR: profile '$p' not on allowlist" >&2; exit 2 ;; esac
  case "$seen" in *" $p "*) echo "ERROR: duplicate profile '$p'" >&2; exit 2 ;; esac
  seen="$seen $p "
done

# ---- Step 2: lock (everything below runs under it); /run/lock, not /tmp ----
LOCK="/run/lock/sync-hermes.lock"
exec 9>"$LOCK" || { echo "ERROR: cannot open lock $LOCK" >&2; exit 1; }
if ! flock -n 9; then echo "ERROR: another sync is already running" >&2; exit 3; fi

# ---- Step 3: clone at main into temp, re-verify ref ----
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
if ! git clone --quiet --depth 1 --branch "$REF" "$REPO_URL" "$TMP/repo"; then
  echo "ERROR: clone of $REPO_URL@$REF failed" >&2; exit 1
fi
[ "$(cd "$TMP/repo" && git rev-parse --abbrev-ref HEAD)" = "main" ] || { echo "ERROR: cloned ref is not main" >&2; exit 2; }
SRC="$TMP/repo/skills"
TS="$(date +%Y%m%d-%H%M%S)"

# ---- Step 4: resolve targets (default = volume root; named profiles under it) ----
TARGETS=("$VOLUME/skills")
for p in "${PROFILE_ARR[@]}"; do TARGETS+=("$VOLUME/profiles/$p/skills"); done

# ---- Step 5: per-target destination-safety + idempotent write, adjacent, under the lock ----
changed=0; unchanged=0
for skill in "${SHARED[@]}"; do
  [ -d "$SRC/$skill" ] || { echo "ERROR: source skill missing: $skill" >&2; exit 1; }
  for base in "${TARGETS[@]}"; do
    case "$base/" in "$APPROVED_VOLUME"/*) : ;; *) echo "ERROR: unsafe destination ancestry: $base" >&2; exit 2 ;; esac
    dest="$base/$skill"
    # reject a symlink at ANY path component below the approved volume (not just base/dest)
    rel="${base#"$APPROVED_VOLUME"/}"; cur="$APPROVED_VOLUME"
    IFS='/' read -r -a _parts <<< "$rel/$skill"
    for _p in "${_parts[@]}"; do
      cur="$cur/$_p"
      if [ -L "$cur" ]; then echo "ERROR: symlink in destination path component: $cur" >&2; exit 2; fi
    done
    if [ -e "$dest" ] && [ ! -d "$dest" ]; then echo "ERROR: destination exists and is not a directory: $dest" >&2; exit 2; fi
    if [ -d "$dest" ] && diff -rq "$SRC/$skill" "$dest" >/dev/null 2>&1; then
      unchanged=$((unchanged + 1)); continue                      # true no-op
    fi
    if [ "$DRYRUN" = "1" ]; then echo "[dry-run] would update $skill -> $dest"; changed=$((changed + 1)); continue; fi
    mkdir -p "$base"
    [ -d "$dest" ] && mv "$dest" "$dest.bak-$TS"                  # one atomic backup
    cp -a --no-dereference "$SRC/$skill" "$dest" || { echo "ERROR: copy failed: $skill -> $dest" >&2; exit 1; }
    chown -R 0:0 "$dest" 2>/dev/null || true
    changed=$((changed + 1))
  done
done

# ---- Step 6/7: summary ----
if [ "$DRYRUN" = "1" ]; then
  echo "[dry-run] $changed would change, $unchanged unchanged, across: ${TARGETS[*]}"
else
  echo "synced: $changed changed, $unchanged unchanged, across: ${TARGETS[*]}"
fi
exit 0
