---
name: viral-app
description: Use the viral.app API from an agent with a local CLI for account analytics, tracked videos/accounts, projects, creator hub, and live data operations.
homepage: https://github.com/fmd-labs/viral-app-skills
---

# viral-app

Use this skill when you need to read or manage data through the viral.app API.

## When to use

- Query analytics (accounts, videos, KPIs, exports).
- Manage tracked entities (accounts, videos, exclusions, refresh runs).
- Manage projects and creator hub resources.
- Pull live platform data (TikTok, Instagram, YouTube).

## Quick start

1. Install runtime once:

```bash
./scripts/install-restish.sh
```

2. Set API key:

```bash
export VIRAL_API_KEY="..."
```

3. Verify access:

```bash
./bin/viral-app accounts-list --per-page 1
```

The wrapper injects `x-api-key` automatically from `VIRAL_API_KEY` unless a header is already passed.

## Inputs to collect first

- Task type: read/report or mutate/manage resources.
- Org-scoped IDs: `orgacc_*`, `orgproj_*`, creator/campaign/payout IDs when relevant.
- Platform and entity identifiers (`tiktok|instagram|youtube`, platform account/video IDs).
- Time bounds (`--date-range[from]`, `--date-range[to]`) for analytics tasks.
- Pagination/scope (`--per-page`, filters) to keep output focused.

## Command cookbook

Discover available operations:

```bash
./bin/viral-app --help
./bin/viral-app <command> --help
```

Common reads:

```bash
./bin/viral-app accounts-list --per-page 10
./bin/viral-app videos-list --per-page 10
./bin/viral-app analytics-get-kpis
./bin/viral-app analytics-top-videos --per-page 10
./bin/viral-app integrations-apps-list
```

Common mutations:

```bash
./bin/viral-app projects-create --body '{"name":"My Project"}'
./bin/viral-app accounts-tracked-refresh --body '{"accounts":["orgacc_..."]}'
./bin/viral-app projects-add-to-account --body '{"projectId":"orgproj_...","accountId":"orgacc_..."}'
```

## Safety rules

- Confirm intent before `POST`, `PUT`, `PATCH`, or `DELETE` unless the user explicitly asked for that mutation.
- Run `<command> --help` before mutations to verify required flags and body schema.
- Prefer narrow queries first (`--per-page`, filters, date ranges) before broad exports.
- Keep output machine-readable by default; only switch format when requested.

## Troubleshooting

- `401 UNAUTHORIZED`: missing/invalid API key; verify `VIRAL_API_KEY` or `-H "x-api-key: ..."` value.
- `429` or retry hints: back off and retry later; inspect response headers such as `Retry-After`.
- Empty `data` arrays: validate filters, project/account IDs, and date range constraints.
- If command names are unclear, regenerate a command map:

```bash
./scripts/command-index.sh | jq .
```

## Agent defaults

- Output defaults to JSON (`RSH_OUTPUT_FORMAT=json` unless overridden).
- Auto-pagination defaults to disabled (`RSH_NO_PAGINATE=true`) for predictable scripted behavior.
- Summarize key metrics after reads and explicitly call out write-side effects after mutations.
