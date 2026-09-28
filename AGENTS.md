# Distribution metadata

- This public repository contains Homebrew formulae and download documentation only.
- Never add proprietary product source, secrets, deployment configuration or user data.
- Pin an immutable public release URL and its verified SHA-256. Never overwrite releases.
- CLI and macOS desktop distribution have independent acceptance gates; do not add a Cask before desktop acceptance is complete.
- Use synthetic test data and a temporary OBSDOG_HOME; preserve real user installations and Spaces.
- Keep operator permissions, named runners and deployment procedures private.
- Run `python3 scripts/check_public_content.py` and its tests for documentation
  changes; preserve public product behavior, license notices and support details.
- Commit messages use `{type}: {imperative specific summary}`.
