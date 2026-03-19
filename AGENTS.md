# AGENTS.md

Agent operating guide for maintaining and releasing the `viral-app-skills` repository.

## Purpose

Use this repo to:

- pin the upstream viral.app OpenAPI spec for the local `viral-app` CLI
- expose the API to agents via the published `viral-app` skill
- ship matching updates to both GitHub releases and ClawHub

The public skill bundle is the folder [`viral-app/`](viral-app). The rest of the repo supports generation, validation, packaging, and publishing.

## Files That Matter

- [`viral-app/SKILL.md`](viral-app/SKILL.md): the actual skill instructions and ClawHub/OpenClaw metadata
- [`openapi/viral.openapi.patched.json`](openapi/viral.openapi.patched.json): pinned spec consumed by the wrapper
- [`bin/viral-app`](bin/viral-app): local CLI wrapper around Restish
- [`.restish/apis.json`](.restish/apis.json): points Restish at the pinned spec
- [`scripts/update-openapi.sh`](scripts/update-openapi.sh): refreshes the pinned spec from upstream
- [`scripts/preflight.sh`](scripts/preflight.sh): prerequisite validation
- [`scripts/smoke.sh`](scripts/smoke.sh): CLI smoke checks, including unauthenticated `401` shape validation
- [`CHANGELOG.md`](CHANGELOG.md): release notes

## Required Runtime Assumptions

- `viral-app` CLI is installed and available in `PATH` if the skill is expected to run on the host
- `VIRAL_API_KEY` is required for authenticated requests
- `clawhub` is required to publish or inspect the ClawHub listing
- `git`, `curl`, `jq`, `tar`, and `npm` are expected on the host for normal maintenance

## Release Surfaces

There are two separate release surfaces:

1. GitHub release
   - versioned by git tag `vX.Y.Z`
   - tag push triggers the GitHub Release workflow
2. ClawHub skill release
   - versioned by skill semver `X.Y.Z`
   - published from the [`viral-app/`](viral-app) folder with `clawhub publish`

Keep these versions aligned unless there is a strong reason not to.

## Standard Agent Workflow

### 1. Refresh and inspect the API

When the user asks for the latest API changes:

```bash
./scripts/update-openapi.sh
./scripts/preflight.sh
./scripts/smoke.sh
./bin/viral-app --help
./scripts/command-index.sh | jq .
```

Then compare the refreshed spec against git:

```bash
git diff --stat
git diff -- openapi/viral.openapi.patched.json
```

Check for:

- new or removed endpoints
- changed response fields
- changed auth/runtime expectations
- command name churn from Restish/OpenAPI generation

### 2. Decide whether the skill metadata also needs updating

Update [`viral-app/SKILL.md`](viral-app/SKILL.md) when any of these change:

- required binary names
- required env vars
- `primaryEnv`
- homepage/source URL
- safety guidance for mutations
- command examples that should highlight new endpoints

OpenClaw/ClawHub metadata should stay accurate:

- `metadata.openclaw.requires.bins`
- `metadata.openclaw.requires.env`
- `metadata.openclaw.primaryEnv`

### 3. Validate before release

Minimum validation:

```bash
./scripts/preflight.sh
./scripts/smoke.sh
./bin/viral-app --help
```

If the spec introduced notable commands, also run:

```bash
./bin/viral-app <new-command> --help
```

If an API key is available, prefer one authenticated read against a narrow endpoint:

```bash
viral-app accounts-list --per-page 1
```

or:

```bash
viral-app library-viral-videos-list --limit 1
```

Never commit or echo live API keys into docs or commit messages.

### 4. Update release notes

Add release notes to [`CHANGELOG.md`](CHANGELOG.md) before tagging or publishing.

Use:

- `Added` for new endpoints/commands
- `Changed` for schema, metadata, or behavior updates
- `Fixed` for packaging, publishing, or runtime requirement corrections

### 5. Ship the GitHub release

Commit the repo changes first, then tag:

```bash
git push origin main
git tag vX.Y.Z
git push origin vX.Y.Z
```

The repo’s release workflow is tag-driven. There is no separate version file in this repo.

### 6. Ship the ClawHub release

Log in if needed:

```bash
clawhub whoami || clawhub login
```

Publish from the skill folder, not the repo root:

```bash
clawhub publish /absolute/path/to/viral-app \
  --slug viral-app \
  --name "Viral App" \
  --version X.Y.Z \
  --changelog "Short changelog text"
```

Important:

- use the absolute path if the relative path behaves inconsistently
- publish the folder containing `SKILL.md`
- ClawHub may temporarily hide the new version while the security scan is pending

Verify after publish:

```bash
clawhub inspect viral-app
```

Check:

- latest version matches the intended release
- runtime requirements show the expected bin/env declarations
- the listing summary still matches the skill purpose

## Versioning Policy

Use semver with practical rules:

- patch: metadata/docs fixes, packaging fixes, small non-breaking skill updates
- minor: new API coverage, new commands, additive endpoint/schema support
- major: breaking command or behavior changes that would surprise existing users

Default bias:

- spec-only additive endpoint changes usually mean a minor release
- ClawHub metadata-only fixes usually mean a patch release

## Agent Safety Rules

- Do not publish from the repo root; publish from [`viral-app/`](viral-app)
- Do not tag a GitHub release without updating [`CHANGELOG.md`](CHANGELOG.md)
- Do not claim the ClawHub page is updated until `clawhub inspect viral-app` confirms the new version
- Do not assume a security scan finished immediately after publish
- Do not paste API keys into commit messages, docs, or chat logs
- Confirm with the user before running mutating viral.app API commands unrelated to release validation

## Upgrade Guidance To Give Users

Choose the right path based on how they installed it:

- git checkout users: `git pull`
- users of the global wrapper from this checkout: usually no extra step beyond pulling
- `npx skills add ...` users: rerun the same install command for the target agent
- ClawHub users: `clawhub update viral-app`

## Fast Path Checklist

For an agent doing a normal update/release:

1. Refresh spec with `./scripts/update-openapi.sh`
2. Run `./scripts/preflight.sh`
3. Run `./scripts/smoke.sh`
4. Inspect new commands with `./bin/viral-app --help`
5. Update [`viral-app/SKILL.md`](viral-app/SKILL.md) if runtime requirements changed
6. Update [`CHANGELOG.md`](CHANGELOG.md)
7. Commit and push `main`
8. Tag and push `vX.Y.Z`
9. Publish `X.Y.Z` to ClawHub from [`viral-app/`](viral-app)
10. Confirm with `clawhub inspect viral-app`
