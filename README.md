# ObsDog Homebrew tap

Official binary distribution metadata for [ObsDog](https://obsdog.ai). Product source remains private and proprietary; this tap does not contain product source.

## Install the CLI

```sh
brew install obsdoghq/tap/obsdog
obsdog version
obsdog document list
obsdog dashboard serve
```

Currently available for **Apple silicon macOS** only. No ObsDog or GitHub account is required for local use. Homebrew verifies the SHA-256 of the immutable public release asset.

CLI v0.2.0 defaults to the same Personal Space from any directory. `init`,
`--path` and `--source-path` have been removed without compatibility aliases.
Use `--space personal` or an exact local Space ID when selecting explicitly;
working directories and old project bindings do not select a Space. Existing ambiguous libraries require
`obsdog space default --set <space-id>`; they are never silently merged or synced.

v0.1.13 includes an explicit recoverable Personal-history adoption workflow for an
already populated local and hosted library. It requires full-Space upload
consent and server v0.1.24; installing or logging in does not upload anything.
See the [current release notes](https://github.com/obsdoghq/obsdog-releases/blob/main/releases/v0.2.4.md)
and `obsdog sync --help` before using the advanced `sync adopt-preview` / `sync adopt` commands.

v0.1.15 retains revision-bound sources and authoring reviews, explicit source/temporal
filters and read-only quality inspection. See the [care guide](https://github.com/obsdoghq/obsdog-releases/blob/main/guides/knowledge-care.md).
Connected care writes require server v0.1.26 and compatible clients. Installing
does not classify existing notes or start a background worker.

The CLI is not the macOS desktop app. A desktop Cask is not currently offered.

v0.1.16 adds bounded usefulness reranking and `memory show`: actual usage traces
strengthen, fade and recover without deleting sources. `--ranking lexical`
retains the comparison baseline. See [Living memory](https://github.com/obsdoghq/obsdog-releases/blob/main/guides/living-memory.md).

v0.2.2 adds whitespace-insensitive substring discovery (`lexical/compact-substring-v1`),
`document list`, typed source checks and an offline dashboard with measured
Top K utilization, observation coverage, activity and source evidence. It retains
v0.2.1's separation of current scoring from historical snapshots. No benchmark
hit-rate improvement is claimed. The [AI plugin](https://github.com/obsdoghq/skills)
is installed separately; confirm CLI readiness with `obsdog version`.
[Setup guide](https://github.com/obsdoghq/skills/blob/main/docs/SETUP.md) ·
[Product feedback](https://github.com/obsdoghq/obsdog-releases/issues/new/choose).

v0.2.3 adds frozen, globally ranked search pages, explicit first-page-use samples,
exact imported relative links and separate graph proposals from question comments.
See [search pages](https://github.com/obsdoghq/obsdog-releases/blob/main/guides/search-pages.md).
Installing does not inject examples into Personal, open a browser or upload data.

## Update and uninstall

v0.2.4 adds bounded AI care plans, exact outcome/history receipts, atomic
structural sync and conditional recovery. Connected care needs server v0.1.29+,
compatible active writers and preparation of the existing connection; installation
does not enable sync. Read the [care guide](https://github.com/obsdoghq/obsdog-releases/blob/main/guides/ai-care.md).

```sh
brew update
brew upgrade obsdoghq/tap/obsdog
brew uninstall obsdog
```

`obsdog update` recognizes Homebrew ownership and directs you to `brew upgrade`; it does not replace a Homebrew-managed binary. Uninstalling the formula does not delete `~/.obsdog` or project bindings. The default local Wiki is `http://127.0.0.1:47777`.

Choose either Homebrew or the [standalone installer](https://github.com/obsdoghq/obsdog-releases), not both for the same CLI on your PATH. Use `command -v obsdog` to check the active installation.

If Homebrew asks you to trust third-party code, review this exact formula and approve only this formula; whole-tap trust is unnecessary. Binary terms and third-party notices are installed with the package and available through `obsdog --licenses`.

## Maintainers

Update the formula only after the exact public release is anonymously downloadable and its checksums and standalone upgrade have passed. Never rewrite a published tag or checksum. Run `brew style`, `brew audit --strict`, `brew install` and `brew test` against the candidate formula before advertising it.

Formula tests use synthetic local knowledge and an isolated `OBSDOG_HOME`; they do not log in, upload documents, or inspect an existing Space. Release evidence is tracked in the private product repository; public installation guidance belongs here and in [ObsDog downloads](https://github.com/obsdoghq/obsdog-releases).

The v0.2.4 formula passes style, strict audit, actual installation alongside a
retained 0.2.3 keg and formula tests. Rejected legacy entrypoints, directory-independent Personal
selection, agent attribution, the substring policy, document inventory,
read-only insights, page coordinates/eligible samples, bounded-care help,
connected preparation help and Homebrew updater ownership are checked. Synthetic
tests use a temporary profile; testing does not restructure existing knowledge.

Public documentation checks run with `python3 scripts/check_public_content.py`
and `python3 -m unittest discover -s tests`. They supplement review; they are not
a complete credential or historical-exposure audit.
