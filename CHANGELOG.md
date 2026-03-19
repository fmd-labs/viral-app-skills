# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project follows Semantic Versioning.

## [Unreleased]

## [0.1.3] - 2026-03-19

### Added
- Documented how agents should build direct viral.app product links for analytics, creator hub, payouts, and viral video library flows.
- Added concrete production URL patterns and supported query params so agents can return UI links alongside CLI results.

## [0.1.2] - 2026-03-19

### Added
- Dedicated root `AGENTS.md` with an agent-focused release, versioning, and ClawHub publishing playbook.

### Changed
- Reverted root `README.md` to stay user-facing and keep release-process guidance out of the main README.

## [0.1.1] - 2026-03-19

### Changed
- Declared `viral-app` as a required binary for OpenClaw/ClawHub skill loading.
- Declared `VIRAL_API_KEY` as the required and primary environment variable for the skill.
- Added a top-level skill homepage so registry listings can show the GitHub source more clearly.

## [0.1.0] - 2026-03-18

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
- Refreshed the pinned OpenAPI spec from `https://viral.app/api/v1/openapi.json`.
- Added Viral Video Library endpoints for listing viral videos and fetching per-video AI insights.
- Expanded live account lookup responses with `is_verified`, `is_private`, `follower_count`, `following_count`, `video_count`, and `bio`.
- Clarified `/accounts` percentile field ordering and average-view descriptions in the schema examples.
