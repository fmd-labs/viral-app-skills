# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project follows Semantic Versioning.

## [Unreleased]

### Added
- Root `SKILL.md` package (`name: viral-app`) for skills ecosystem compatibility.
- `viral-app` CLI wrapper with `VIRAL_API_KEY` header injection.
- Preflight and smoke test scripts.
- CI and tag-based release workflows.
- Contribution and security guidance.

### Changed
- Renamed user-facing command from `skills` to `viral-app`.
- Switched restish API alias from `skills` to `viral-app`.
- Improved command index generation to prefer OpenAPI `operationId`.
