#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_tools=(bash curl jq tar)
missing=0

for tool in "${required_tools[@]}"; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required tool: $tool" >&2
    missing=1
  fi
done

if [[ $missing -ne 0 ]]; then
  exit 1
fi

if [[ ! -x "$ROOT_DIR/.tools/restish/restish" ]]; then
  echo "restish is not installed. Run: $ROOT_DIR/scripts/install-restish.sh" >&2
  exit 1
fi

if [[ ! -f "$ROOT_DIR/openapi/viral.openapi.patched.json" ]]; then
  echo "OpenAPI spec is missing. Run: $ROOT_DIR/scripts/update-openapi.sh" >&2
  exit 1
fi

echo "Preflight checks passed."
