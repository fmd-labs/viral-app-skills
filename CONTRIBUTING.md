# Contributing

## Local setup

```bash
./scripts/install-restish.sh
./scripts/preflight.sh
```

## Validation before opening a PR

```bash
bash -n bin/viral-app scripts/*.sh
./scripts/command-index.sh | jq 'length'
./scripts/smoke.sh
```

## Release process

1. Update `CHANGELOG.md`.
2. Commit and merge to `main`.
3. Create a SemVer tag:

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

Pushing a `v*` tag triggers the GitHub release workflow.
