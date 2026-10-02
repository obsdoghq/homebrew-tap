# ObsDog Homebrew tap

Official binary distribution metadata for [ObsDog](https://obsdog.ai). Product source remains private and proprietary; this tap does not contain product source.

Track internal work only in Project draft tickets, not duplicate Issues.
Use [issues](https://github.com/obsdoghq/homebrew-tap/issues) for feedback and follow the
[feedback privacy guide](https://github.com/obsdoghq/obsdog-releases/blob/main/FEEDBACK.md);
private operations plans stay separate.

## Install the CLI

```sh
brew install obsdoghq/tap/obsdog
obsdog version
obsdog document list
obsdog dashboard serve
```

Currently available for **Apple silicon macOS** only. No ObsDog or GitHub account is required for local use. Homebrew verifies the SHA-256 of the immutable public release asset.

The v0.2.23 formula preserves v0.2.22's schema 12 and repairs sync receipts,
credential coherence and bounded diagnostics. Already-transitioned schema-12
libraries need no repeat migration. **Existing schema-11
libraries need the separate backup-first transition tool**; installing or
upgrading never migrates them. Read the
[exact migration guide](https://github.com/obsdoghq/obsdog-releases/blob/v0.2.23/guides/local-schema-migration.md)
before opening an older library. Keep private consistent backups, pause that
library's writers, then reconnect its MCPs and restart its dashboard after the
transition. This read-oriented beta still has write/WAL costs, not a general
write-speed or temporary-file reduction guarantee. Linux x64 uses the
[standalone release installer](https://github.com/obsdoghq/obsdog-releases#linux-x64-support),
not this macOS-only formula. Retain the usual process-restart and instruction
review checks after updating either installation method.

CLI v0.2.0 defaults to the same Personal Space from any directory. `init`,
`--path` and `--source-path` have been removed without compatibility aliases.
Use `--space personal` or an exact local Space ID when selecting explicitly;
working directories and old project bindings do not select a Space. Existing ambiguous libraries require
`obsdog space default --set <space-id>`; they are never silently merged or synced.

v0.1.13 includes an explicit recoverable Personal-history adoption workflow for an
already populated local and hosted library. It requires full-Space upload
consent and server v0.1.24; installing or logging in does not upload anything.
See the [current release notes](https://github.com/obsdoghq/obsdog-releases/blob/main/releases/v0.2.8.md)
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

v0.2.18 adapts marker/click sizes, title density and zoom/Fit to the map and
viewport, including tiny, dense, many-component and independent document maps.
Every loaded document remains in the same view, with the full title/ID index
available when overview markers are small.

v0.2.17 shows all loaded documents together in the shared hosted/offline Graph,
including independent notes. Circular focus emphasizes direct neighbors while
preserving the complete map and camera. Explicit dashboard deep links work
without allowing cross-site API access. Passive exploration records no search or use.
See the [dashboard guide](https://github.com/obsdoghq/obsdog-releases/blob/main/guides/local-dashboard.md).
After upgrading, restart a running `obsdog dashboard serve` with the same
Space/port flags and reconnect agent sessions that own an `obsdog mcp` process.
A browser refresh alone cannot replace a running server.

v0.2.4 adds bounded AI care plans, exact outcome/history receipts, atomic
structural sync and conditional recovery. Connected care needs server v0.1.29+,
compatible active writers and preparation of the existing connection; installation
does not enable sync. Read the [care guide](https://github.com/obsdoghq/obsdog-releases/blob/main/guides/ai-care.md).

v0.2.5 excludes returned-only searches from the bounded Living-memory scoring
input without removing those events from history. Scoring weights and historical
chunks are unchanged; this is a correctness repair, not a benchmarked quality gain.

v0.2.6 adds bounded recent activity with exact search traces, browser-device
time display for individual events (daily totals remain UTC), and quiet update
notices. Agent block edits require a base revision; structural edits still need
single-writer coordination or a checked care plan.

v0.2.8 refuses exact duplicate imports by default. Import is create-only, not an
upsert; `--fork` deliberately makes another copy. New searches honor document
retirement labels and hide deprecated knowledge by default. Use
`--include-deprecated` for an audit; older recorded traces are preserved.

```sh
brew update
brew upgrade obsdoghq/tap/obsdog
brew uninstall obsdog
```

`obsdog update` recognizes Homebrew ownership and directs you to `brew upgrade`; it does not replace a Homebrew-managed binary. Uninstalling the formula does not delete `~/.obsdog` or project bindings. The default local Wiki is `http://127.0.0.1:47777`.

After upgrading, follow the [AI-client update checklist](https://github.com/obsdoghq/skills/blob/main/docs/SETUP.md#updating-cli-and-agent-guidance): update the separate plugin, restart any running dashboard or `wiki serve`, and reconnect host-owned MCP sessions. Review the ObsDog section in your `AGENTS.md` / `CLAUDE.md` against the current guidance; the plugin does not overwrite these files.

Choose either Homebrew or the [standalone installer](https://github.com/obsdoghq/obsdog-releases), not both for the same CLI on your PATH. Use `command -v obsdog` to check the active installation.

If Homebrew asks you to trust third-party code, review this exact formula and approve only this formula; whole-tap trust is unnecessary. Binary terms and third-party notices are installed with the package and available through `obsdog --licenses`.

## Maintainers

Update the formula only after the exact public release is anonymously downloadable and its checksums and standalone upgrade have passed. Never rewrite a published tag or checksum. Run `brew style`, `brew audit --strict`, `brew install` and `brew test` against the candidate formula before advertising it.

Formula tests use synthetic local knowledge and an isolated `OBSDOG_HOME`; they do not log in, upload documents, or inspect an existing Space. Release evidence is tracked in the private product repository; public installation guidance belongs here and in [ObsDog downloads](https://github.com/obsdoghq/obsdog-releases).

The **Verify public Homebrew formula** workflow checks the exact checked-out
formula on a fresh GitHub-hosted Apple silicon runner. It runs style, strict
audit, installation and the formula's synthetic tests without changing a
maintainer's installation. The workflow needs read-only repository access and
does not build, sign or publish product binaries. An unpublished release URL
must fail; run this gate only once the immutable public assets are available.
Formula tests keep local knowledge and package-ownership checks offline. The
live Homebrew update check runs separately, outside the formula's credential
sanitization, with the workflow's short-lived, read-only GitHub token instead of
the shared runner's anonymous API budget. No maintainer secret or user account
is needed. This does not replace separate anonymous installer and
standalone-update acceptance; the live gate still fails on an incorrect result.
See [GitHub's standard runner labels](https://docs.github.com/en/actions/reference/runners/github-hosted-runners)
and [Homebrew's formula checks](https://docs.brew.sh/Formula-Cookbook#audit-the-formula).

The v0.2.5 formula passed style, strict audit, actual upgrade from v0.2.4 and
formula tests. Rejected legacy entrypoints, directory-independent Personal
selection, agent attribution, the substring policy, document inventory,
read-only insights, page coordinates/eligible samples, bounded-care help,
connected preparation help and Homebrew updater ownership are checked. Synthetic
tests use a temporary profile; testing does not restructure existing knowledge.

Public documentation checks run with `python3 scripts/check_public_content.py`
and `python3 -m unittest discover -s tests`. They supplement review; they are not
a complete credential or historical-exposure audit.
