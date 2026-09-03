#!/usr/bin/env bash
# Collect the raw material for a progress deck.
# Usage:
#   collect-changes.sh --count 20 [--repo PATH]
#   collect-changes.sh --since 2026-08-01 [--repo PATH]
#   collect-changes.sh --range v2.1..HEAD [--repo PATH]
set -euo pipefail

REPO="."; MODE=""; VALUE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --count|--since|--range) MODE="${1#--}"; VALUE="${2:-}"; shift 2 ;;
    --repo) REPO="${2:-.}"; shift 2 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done
[ -n "$MODE" ] && [ -n "$VALUE" ] || { echo "need --count N | --since DATE | --range A..B" >&2; exit 2; }

git -C "$REPO" rev-parse --git-dir >/dev/null 2>&1 || { echo "not a git repo: $REPO" >&2; exit 1; }

case "$MODE" in
  count) SEL=(-n "$VALUE") ;;
  since) SEL=(--since="$VALUE") ;;
  range) SEL=("$VALUE") ;;
esac

g() { git -C "$REPO" "$@"; }

echo "## SCOPE"
echo "repo: $(cd "$REPO" && pwd)"
echo "branch: $(g rev-parse --abbrev-ref HEAD)"
echo "selector: --$MODE $VALUE"
echo "generated: $(date +%Y-%m-%dT%H:%M:%S%z)"

echo
echo "## COMMITS"
g log "${SEL[@]}" --no-merges --date=short \
  --pretty=format:'%h|%ad|%an|%s'
echo

echo
echo "## TYPE BREAKDOWN"
g log "${SEL[@]}" --no-merges --pretty=format:'%s' \
  | sed -E 's/^([a-z]+)(\(.*\))?!?:.*/\1/; t; s/.*/other/' \
  | sort | uniq -c | sort -rn

echo
echo "## CONTRIBUTORS"
g log "${SEL[@]}" --no-merges --pretty=format:'%an' | sort | uniq -c | sort -rn

echo
echo "## FILE CHURN (top 25)"
g log "${SEL[@]}" --no-merges --name-only --pretty=format: \
  | grep -v '^$' | sort | uniq -c | sort -rn | head -25

echo
echo "## TOTALS"
g log "${SEL[@]}" --no-merges --shortstat --pretty=format: \
  | grep -E 'file[s]? changed' \
  | awk '{ f+=$1; for(i=1;i<=NF;i++){ if($i ~ /insertion/) a+=$(i-1); if($i ~ /deletion/) d+=$(i-1) } }
         END { printf "commits_touched_files=%d insertions=%d deletions=%d\n", f, a, d }'
g log "${SEL[@]}" --no-merges --oneline | wc -l | sed 's/^ *//; s/^/commits=/'

echo
echo "## NEXT STEP"
echo "Read the diffs of anything that will get its own slide: git -C $REPO show --stat <sha>"
