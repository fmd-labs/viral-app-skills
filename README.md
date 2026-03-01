# viral-app

`viral-app` is an agent skill package plus local CLI for the viral.app API.
It uses `restish` with a pinned OpenAPI spec and defaults to JSON output.

## Install as a skill

Install from GitHub with the open `skills` ecosystem CLI:

```bash
npx skills add fmd-labs/viral-app-skills --skill viral-app
```

List skills from this repo:

```bash
npx skills add fmd-labs/viral-app-skills --list
```

Install for specific agents:

```bash
npx skills add fmd-labs/viral-app-skills --skill viral-app -a codex
npx skills add fmd-labs/viral-app-skills --skill viral-app -a claude-code
npx skills add fmd-labs/viral-app-skills --skill viral-app -a cursor
```

## Local CLI setup

1. Install globally:

```bash
./scripts/install-global.sh
```

This creates `viral-app` in `~/.local/bin` (or `$VIRAL_APP_BIN_DIR`).

2. Or install project-local runtime only:

```bash
./scripts/install-restish.sh
```

3. Update pinned spec:

```bash
./scripts/update-openapi.sh
```

4. Validate local prerequisites:

```bash
./scripts/preflight.sh
```

## Auth

Use your API key in one of these ways:

```bash
export VIRAL_API_KEY="..."
viral-app accounts-list --per-page 5
```

```bash
viral-app -H "x-api-key: ..." accounts-list --per-page 5
```

If `VIRAL_API_KEY` is set, the wrapper injects `x-api-key` automatically unless you already pass that header.

## Usage

```bash
viral-app --help
viral-app accounts-list --help
viral-app accounts-list --per-page 5
```

Override output format:

```bash
viral-app -o table accounts-list --per-page 5
```

Disable/enable pagination behavior:

```bash
RSH_NO_PAGINATE=true viral-app accounts-list --per-page 5
RSH_NO_PAGINATE=false viral-app accounts-list --per-page 5
```

Generate machine-readable command index:

```bash
./scripts/command-index.sh | jq .
```

## Quality checks

Run smoke checks:

```bash
./scripts/smoke.sh
```

CI verifies:

- Shell syntax + `shellcheck`
- Skill detection with `npx skills add . --list`
- CLI help + command index validity
- Smoke behavior for unauthenticated API response shape

## Releases and publishing

Use SemVer tags and GitHub Releases:

```bash
git tag v0.1.0
git push origin v0.1.0
```

Tag pushes (`v*`) trigger the release workflow.

To remove the global command:

```bash
./scripts/uninstall-global.sh
```
