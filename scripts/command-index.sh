#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPEC_FILE="$ROOT_DIR/openapi/viral.openapi.patched.json"

jq '
  def cli_name:
    gsub("_"; "-")
    | ascii_downcase;

  def op_cmd($method; $path):
    ($method + "-" + ($path
      | ltrimstr("/")
      | gsub("\\{"; "")
      | gsub("\\}"; "")
      | gsub("/"; "-")));

  [
    .paths
    | to_entries[] as $path
    | $path.value
    | to_entries[]
    | .key as $method
    | select(["get", "post", "put", "patch", "delete", "head", "options"] | index($method))
    | {
        command: op_cmd(.key; $path.key),
        method: (.key | ascii_upcase),
        path: $path.key,
        operation_id: (.value.operationId // ""),
        summary: (.value.summary // ""),
        args: [
          (.value.parameters // [])[]
          | select(.in == "path")
          | {
              name: (.name | cli_name),
              original_name: .name,
              required: (.required // true),
              type: (.schema.type // "string")
            }
        ],
        flags: [
          (.value.parameters // [])[]
          | select(.in != "path")
          | {
              name: ("--" + (.name | cli_name)),
              original_name: .name,
              required: (.required // false),
              in: .in,
              type: (.schema.type // "string")
            }
        ]
      }
  ]
  | sort_by(.command)
' "$SPEC_FILE"
