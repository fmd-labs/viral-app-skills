---
name: viral-app
description: Use the viral.app API from an agent with a local CLI for account analytics, tracked videos/accounts, projects, creator hub, and live data operations.
---

# viral-app

Use this skill when you need to read or manage data through the viral.app API.

## When to use

- Query analytics (accounts, videos, KPIs, exports).
- Manage tracked entities (accounts, videos, exclusions, refresh runs).
- Manage projects and creator hub resources.
- Pull live platform data (TikTok, Instagram, YouTube).

## Prerequisites

1. Install runtime once:

```bash
./scripts/install-restish.sh
```

2. Set API key:

```bash
export VIRAL_API_KEY="..."
```

The wrapper injects `x-api-key` automatically from `VIRAL_API_KEY` unless a header is already passed.

## Command patterns

Discover commands:

```bash
./bin/viral-app --help
./bin/viral-app accounts-list --help
```

Typical reads:

```bash
./bin/viral-app accounts-list --per-page 10
./bin/viral-app videos-list --per-page 10
./bin/viral-app analytics-get-kpis
```

Typical writes:

```bash
./bin/viral-app projects-create --body '{"name":"My Project"}'
./bin/viral-app accounts-tracked-refresh --body '{"accounts":["orgacc_..."]}'
```

## Behavior and safety

- Output defaults to JSON for agent-friendly parsing.
- Pagination defaults to disabled (`RSH_NO_PAGINATE=true`).
- Use `--help` before write operations and validate required flags/body shape.
- On auth failures, the API returns structured JSON with HTTP `401`.
