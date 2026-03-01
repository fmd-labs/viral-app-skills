#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"$ROOT_DIR/scripts/preflight.sh" >/dev/null
"$ROOT_DIR/bin/viral-app" --help >/dev/null

INDEX_LEN="$("$ROOT_DIR/scripts/command-index.sh" | jq 'length')"
if [[ "$INDEX_LEN" -le 0 ]]; then
  echo "Command index is empty." >&2
  exit 1
fi

unset VIRAL_API_KEY
OUTPUT="$("$ROOT_DIR/bin/viral-app" accounts-list --per-page 1 2>/dev/null || true)"
if [[ -z "$OUTPUT" ]]; then
  echo "No output received from unauthenticated request." >&2
  exit 1
fi

echo "$OUTPUT" | jq -e '.status == 401 and (.code | type == "string") and (.message | type == "string")' >/dev/null

echo "Smoke checks passed."
