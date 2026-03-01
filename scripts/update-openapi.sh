#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_FILE="$ROOT_DIR/openapi/viral.openapi.patched.json"
SRC_URL="https://viral.app/api/v1/openapi.json"

curl -fsSL "$SRC_URL" \
  | jq '.' \
  > "$OUT_FILE"

echo "Updated $OUT_FILE"
echo -n "OpenAPI version: "
jq -r '.openapi' "$OUT_FILE"
echo -n "API version: "
jq -r '.info.version' "$OUT_FILE"
