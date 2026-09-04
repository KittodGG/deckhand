#!/usr/bin/env bash
# deckhand installer — one copy on disk, a pointer in every harness that is
# actually installed. Nothing is written to a config directory that does not
# already exist.
#
#   curl -fsSL https://raw.githubusercontent.com/KittodGG/deckhand/main/install.sh | bash
#   bash install.sh --project        # also point this repo's AGENTS.md at it
#   bash install.sh --uninstall
set -euo pipefail

REPO="${DECKHAND_REPO:-https://github.com/KittodGG/deckhand}"
DH="${DECKHAND_HOME:-$HOME/.deckhand}"
START="<!-- deckhand:start -->"
END="<!-- deckhand:end -->"
PROJECT=0; UNINSTALL=0

while [ $# -gt 0 ]; do
  case "$1" in
    --project) PROJECT=1; shift ;;
    --uninstall) UNINSTALL=1; shift ;;
    --home) DH="$2"; shift 2 ;;
    -h|--help) sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

say() { printf '  %s\n' "$1"; }

block() {
  cat <<BLOCK
$START
## deckhand — progress-update presentations

When the user asks for a presentation, slide deck, progress update, sprint
review, or demo deck built from what changed in a repo, follow
\`$DH/skills/deckhand/SKILL.md\` start to finish.

For a standalone diagram with no deck around it, follow
\`$DH/skills/deck-svg/SKILL.md\`.

Ask scope, audience, language, and theme before writing anything. Never state a
number that is not in the git log, a diff, an issue, or a measurement you ran.
$END
BLOCK
}

# Replace an existing deckhand block, or append one. Idempotent.
write_block() {
  local f="$1"
  mkdir -p "$(dirname "$f")"
  [ -f "$f" ] || : > "$f"
  strip_block "$f"
  [ -s "$f" ] && printf '\n' >> "$f"
  block >> "$f"
  say "pointer  $f"
}

strip_block() {
  local f="$1" tmp
  [ -f "$f" ] || return 0
  tmp="$(mktemp)"
  awk -v s="$START" -v e="$END" '
    index($0,s){skip=1} !skip{print} index($0,e){skip=0}
  ' "$f" > "$tmp"
  # drop a trailing blank line left behind by the removal
  awk 'BEGIN{n=0} {lines[NR]=$0} END{while(NR>0 && lines[NR]==""){NR--} for(i=1;i<=NR;i++) print lines[i]}' "$tmp" > "$f"
  rm -f "$tmp"
}

# ── uninstall ────────────────────────────────────────────────────────────────
if [ "$UNINSTALL" = 1 ]; then
  echo "Removing deckhand."
  rm -rf "$HOME/.claude/skills/deckhand" "$HOME/.claude/skills/deck-svg"
  for f in "$HOME/.codex/AGENTS.md" "$HOME/.gemini/GEMINI.md" \
           "$HOME/.config/opencode/AGENTS.md" "$HOME/.cursor/AGENTS.md" \
           "$HOME/.copilot/AGENTS.md" "$HOME/.factory/AGENTS.md" \
           "$HOME/.cline/AGENTS.md" "$HOME/.aider/AGENTS.md" \
           "$HOME/.goose/AGENTS.md" "$HOME/.amp/AGENTS.md" \
           "$HOME/.continue/AGENTS.md" "$HOME/.pi/AGENTS.md" \
           "$HOME/.opencode/AGENTS.md" "$HOME/AGENTS.md" "./AGENTS.md"; do
    [ -f "$f" ] && grep -q "$START" "$f" 2>/dev/null && { strip_block "$f"; say "cleaned  $f"; }
  done
  rm -rf "$DH"
  say "removed  $DH"
  echo "Done."
  exit 0
fi

# ── fetch or update the one copy on disk ─────────────────────────────────────
echo "deckhand"
if [ -d "$DH/.git" ]; then
  git -C "$DH" pull --quiet --ff-only || true
  say "updated  $DH"
elif [ -f "$(dirname "$0")/skills/deckhand/SKILL.md" ]; then
  SRC="$(cd "$(dirname "$0")" && pwd)"
  if [ "$SRC" != "$DH" ]; then
    mkdir -p "$DH"
    cp -R "$SRC/skills" "$SRC/AGENTS.md" "$SRC/README.md" "$DH/" 2>/dev/null || true
  fi
  say "copied   $DH"
else
  git clone --quiet --depth 1 "$REPO" "$DH"
  say "cloned   $DH"
fi
chmod +x "$DH/skills/deckhand/scripts/collect-changes.sh" 2>/dev/null || true

# ── Claude Code: a real skill directory, no config file needed ───────────────
if [ -d "$HOME/.claude" ]; then
  if grep -q '"deckhand@deckhand"' "$HOME/.claude/plugins/installed_plugins.json" 2>/dev/null; then
    say "skipped  ~/.claude/skills (plugin deckhand@deckhand already installed)"
  else
    mkdir -p "$HOME/.claude/skills"
    rm -rf "$HOME/.claude/skills/deckhand" "$HOME/.claude/skills/deck-svg"
    cp -R "$DH/skills/deckhand" "$HOME/.claude/skills/deckhand"
    cp -R "$DH/skills/deck-svg" "$HOME/.claude/skills/deck-svg"
    say "skill    ~/.claude/skills/deckhand"
  fi
fi

# ── every other harness: a pointer in the instruction file it already reads ──
[ -d "$HOME/.codex" ]            && write_block "$HOME/.codex/AGENTS.md"
[ -d "$HOME/.gemini" ]           && write_block "$HOME/.gemini/GEMINI.md"
[ -d "$HOME/.config/opencode" ]  && write_block "$HOME/.config/opencode/AGENTS.md"
[ -d "$HOME/.opencode" ]         && write_block "$HOME/.opencode/AGENTS.md"
[ -d "$HOME/.cursor" ]           && write_block "$HOME/.cursor/AGENTS.md"
[ -d "$HOME/.copilot" ]          && write_block "$HOME/.copilot/AGENTS.md"
[ -d "$HOME/.factory" ]          && write_block "$HOME/.factory/AGENTS.md"
[ -d "$HOME/.cline" ]            && write_block "$HOME/.cline/AGENTS.md"
[ -d "$HOME/.aider" ]            && write_block "$HOME/.aider/AGENTS.md"
[ -d "$HOME/.goose" ]            && write_block "$HOME/.goose/AGENTS.md"
[ -d "$HOME/.amp" ]              && write_block "$HOME/.amp/AGENTS.md"
[ -d "$HOME/.continue" ]         && write_block "$HOME/.continue/AGENTS.md"
[ -d "$HOME/.pi" ]               && write_block "$HOME/.pi/AGENTS.md"

[ "$PROJECT" = 1 ] && write_block "./AGENTS.md"

echo
echo "Ask any of them: \"buatkan presentasi update dari 20 commit terakhir\""
echo "Claude Code with the plugin installed also has /deckhand:deck."
