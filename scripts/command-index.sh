#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPEC_FILE="$ROOT_DIR/openapi/viral.openapi.patched.json"

jq '
  def cli_name:
    gsub("_"; "-")
    | gsub("(?<x>[A-Z])"; "-\(.x | ascii_downcase)")
    | gsub("--+"; "-")
    | ltrimstr("-")
    | ascii_downcase;

  def path_cmd($method; $path):
    ($method + "-" + ($path
      | ltrimstr("/")
      | gsub("\\{"; "")
      | gsub("\\}"; "")
      | gsub("/"; "-")));

  def op_cmd($method; $path; $operation_id):
    if ($operation_id | type) == "string" and ($operation_id | length) > 0 then
      ($operation_id | split(".") | map(cli_name) | join("-"))
    else
      path_cmd($method; $path)
    end;

  def schema_type:
    if .type then
      .type
    elif (.anyOf | type) == "array" then
      ([.anyOf[]?.type | select(. != "null")] | .[0] // "string")
    else
      "string"
    end;

  [
    .paths
    | to_entries[] as $path
    | $path.value
    | to_entries[]
    | .key as $method
    | .value as $op
    | select(["get", "post", "put", "patch", "delete", "head", "options"] | index($method))
    | {
        command: op_cmd($method; $path.key; ($op.operationId // "")),
        method: ($method | ascii_upcase),
        path: $path.key,
        operation_id: ($op.operationId // ""),
        summary: ($op.summary // ""),
        args: [
          ($op.parameters // [])[]
          | select(.in == "path")
          | {
              name: (.name | cli_name),
              original_name: .name,
              required: (.required // true),
              type: ((.schema // {}) | schema_type)
            }
        ],
        flags: [
          ($op.parameters // [])[]
          | select(.in != "path")
          | {
              name: ("--" + (.name | cli_name)),
              original_name: .name,
              required: (.required // false),
              in: .in,
              type: ((.schema // {}) | schema_type)
            }
        ]
      }
  ]
  | sort_by(.command)
' "$SPEC_FILE"
