# skills

Project-local CLI for the viral.app API, powered by `restish` with a pinned local OpenAPI spec.

## What this gives you

- `skills` command via `./bin/skills`
- JSON output by default (agent-friendly)
- All endpoints from the viral.app OpenAPI spec
- Pinned local spec (`openapi/viral.openapi.patched.json`)

## Setup

1. Install globally (recommended):

```bash
./scripts/install-global.sh
```

This creates a `skills` command in `~/.local/bin` (or `$SKILLS_BIN_DIR`) so you can run `skills` from anywhere.

2. Or install project-local only:

```bash
./scripts/install-restish.sh
```

3. Fetch/update the pinned OpenAPI spec:

```bash
./scripts/update-openapi.sh
```

4. Run CLI:

```bash
skills --help
```

## Usage

List all available commands:

```bash
skills --help
```

Example account listing:

```bash
skills accounts-list --per-page 5
```

## Output format

Default is JSON. To override:

```bash
skills -o table accounts-list --per-page 5
```

Auto-pagination is disabled by default for cleaner scripted output. Override if needed:

```bash
RSH_NO_PAGINATE=false skills accounts-list --per-page 5
```

## Update pinned OpenAPI spec

```bash
./scripts/update-openapi.sh
```

## Agent Discoverability

The built-in help is enough to explore:

```bash
skills --help
skills accounts-list --help
```

You can also generate a full machine-readable command index from the pinned spec:

```bash
./scripts/command-index.sh | jq .
```

## Distribution

This repo layout is ready for source distribution.

- Share/clone the repo and run `./scripts/install-global.sh` (or `./scripts/install-restish.sh` for local-only use).

To remove the global command:

```bash
./scripts/uninstall-global.sh
```
