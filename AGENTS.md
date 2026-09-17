# Distribution metadata

- This public repository contains Homebrew formulae and download documentation only.
- Never add proprietary product source, secrets, deployment configuration or user data.
- Pin an immutable public release URL and its verified SHA-256. Never overwrite releases.
- CLI and macOS desktop distribution have independent acceptance gates; do not add a Cask before desktop acceptance is complete.
- Use synthetic test data and a temporary OBSDOG_HOME; preserve real user installations and Spaces.
- Grant repository permissions through the existing organization maintainers team.
- Commit messages use `{type}: {imperative specific summary}`.
