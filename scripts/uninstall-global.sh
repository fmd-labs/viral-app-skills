#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="${VIRAL_APP_BIN_DIR:-$HOME/.local/bin}"
GLOBAL_CMD="$BIN_DIR/viral-app"

if [[ -f "$GLOBAL_CMD" ]]; then
  rm "$GLOBAL_CMD"
  echo "Removed $GLOBAL_CMD"
else
  echo "No global viral-app command found at $GLOBAL_CMD"
fi
