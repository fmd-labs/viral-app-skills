#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_FILE="$ROOT_DIR/openapi/viral.openapi.patched.json"
SRC_URL="https://viral.app/api/v1/openapi.json"
TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

curl -fsSL "$SRC_URL" | jq '.' > "$TMP_FILE"
jq -e '.openapi and .info and .paths' "$TMP_FILE" >/dev/null
mv "$TMP_FILE" "$OUT_FILE"

echo "Updated $OUT_FILE"
echo -n "OpenAPI version: "
jq -r '.openapi' "$OUT_FILE"
echo -n "API version: "
jq -r '.info.version' "$OUT_FILE"
