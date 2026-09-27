# ObsDog Homebrew tap

Official binary distribution metadata for [ObsDog](https://obsdog.ai). Product source remains private and proprietary; this tap does not contain product source.

## Install the CLI

```sh
brew install obsdoghq/tap/obsdog
obsdog version
obsdog wiki serve
```

Currently available for **Apple silicon macOS** only. No ObsDog or GitHub account is required for local use. Homebrew verifies the SHA-256 of the immutable public release asset.

CLI v0.1.11 defaults to the same Personal Space from any directory; `init` is
optional project guidance, not a prerequisite. Use `--space personal` or an exact
local Space ID when selecting explicitly. Existing ambiguous libraries require
`obsdog space default --set <space-id>`; they are never silently merged or synced.

The CLI is not the macOS desktop app. No desktop Cask is published until its separate installation, recovery and signed-update checks pass.

## Update and uninstall

```sh
brew update
brew upgrade obsdoghq/tap/obsdog
brew uninstall obsdog
```

`obsdog update` recognizes Homebrew ownership and directs you to `brew upgrade`; it does not replace a Homebrew-managed binary. Uninstalling the formula does not delete `~/.obsdog` or project bindings. The default local Wiki is `http://127.0.0.1:47777`.

Choose either Homebrew or the [standalone installer](https://github.com/obsdoghq/obsdog-releases), not both for the same CLI on your PATH. Use `command -v obsdog` to check the active installation. The development command `odev` has separate state and is not installed by this formula.

If Homebrew asks you to trust third-party code, review this exact formula and approve only this formula; whole-tap trust is unnecessary. Binary terms and third-party notices are installed with the package and available through `obsdog --licenses`.

## Maintainers

Update the formula only after the exact public release is anonymously downloadable and its checksums and standalone upgrade have passed. Never rewrite a published tag or checksum. Use repository permissions through the `obsdoghq/maintainers` team. Run `brew style`, `brew audit --strict`, `brew install` and `brew test` against the candidate formula before advertising it.

Formula tests use synthetic local knowledge and an isolated `OBSDOG_HOME`; they do not log in, upload documents, or inspect an existing Space. Release evidence is tracked in the private product repository; public installation guidance belongs here and in [ObsDog downloads](https://github.com/obsdoghq/obsdog-releases).
