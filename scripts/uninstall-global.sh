#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="${SKILLS_BIN_DIR:-$HOME/.local/bin}"
GLOBAL_CMD="$BIN_DIR/skills"

if [[ -f "$GLOBAL_CMD" ]]; then
  rm "$GLOBAL_CMD"
  echo "Removed $GLOBAL_CMD"
else
  echo "No global skills command found at $GLOBAL_CMD"
fi
