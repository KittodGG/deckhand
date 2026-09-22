#!/bin/bash
# validate-widget.sh — lint widget HTML deckhand.
# Checks: <template>, data-widget, init function, theme conformance (no hardcode hex/font).
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WIDGET_DIR="$SCRIPT_DIR/../widgets"
FAIL=0

if [ ! -d "$WIDGET_DIR" ]; then
  echo "No widgets/ folder found at $WIDGET_DIR"
  exit 1
fi

for widget in "$WIDGET_DIR"/*.html; do
  [ -e "$widget" ] || continue
  name=$(basename "$widget")
  echo "Validating $name..."

  grep -q '<template' "$widget" || { echo "  ERROR: No <template> tag"; FAIL=1; }
  grep -q 'data-widget=' "$widget" || { echo "  ERROR: No data-widget attr"; FAIL=1; }
  grep -q 'function init' "$widget" || { echo "  ERROR: No init function"; FAIL=1; }

  # Theme conformance: tolak hex hardcode (kecuali di komentar) dan font luar.
  # color-mix() dengan var(--...) diperbolehkan; hex murni tidak.
  if grep -Eo '#[0-9a-fA-F]{3,8}\b' "$widget" | grep -qv '^$'; then
    echo "  ERROR: Hardcoded hex found (pakai var(--...) deck):"
    grep -Eo '#[0-9a-fA-F]{3,8}\b' "$widget" | sort -u | sed 's/^/    /'
    FAIL=1
  fi

  if grep -Ei 'Space Grotesk|JetBrains Mono|fonts\.googleapis' "$widget" | grep -qv '^$'; then
    echo "  ERROR: External font found (warisi Manrope/Playfair dari deck):"
    grep -Ei 'Space Grotesk|JetBrains Mono|fonts\.googleapis' "$widget" | sed 's/^/    /'
    FAIL=1
  fi

  # External deps selain deck template dilarang
  if grep -E 'src="https?://' "$widget" | grep -qv '^$'; then
    echo "  ERROR: External script src found"
    FAIL=1
  fi

  echo "  done $name"
done

if [ "$FAIL" -eq 1 ]; then
  echo "VALIDATION FAILED — perbaiki error di atas (lihat theme rule di widgets/README.md)."
  exit 1
fi
echo "All widgets valid (theme-conformant)."
