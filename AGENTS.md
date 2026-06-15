# AGENTS.md

## Mission

This repo is a portable Pi configuration kit. The goal is to configure any of my computers with one public repo: install or update `git:github.com/jbn/generativist-pi` and get my preferred Pi extensions, skills, prompts, themes, and notes scaffolding.

## Sources of truth

- `package.json` is the source of truth for the Pi manifest and npm dependencies.
- `package-lock.json` must be kept in sync with `package.json`.
- `README.md` is user-facing and should stay accurate for public install/update instructions.
- `AGENTS.md` is maintainer/agent-facing workflow guidance.
- `NOTES/` is for human-maintained Markdown notes and is not loaded by Pi automatically.

Do not commit local provider/model/auth settings or secrets. Pi auth and machine-specific settings belong outside this repo.

## Public install style

The repo is public, so README install instructions should prefer the public git shorthand:

```bash
pi install git:github.com/jbn/generativist-pi
```

The git remote may remain SSH for pushes.

## Bundling npm Pi packages

Prefer bundling reusable npm Pi packages into this kit instead of instructing me to install them separately.

When adding a bundled Pi package:

1. Add it to `dependencies` with an exact version.
2. Add it to `bundledDependencies`.
3. Add its resource paths to the `pi` manifest as needed:
   - `pi.extensions`
   - `pi.skills`
   - `pi.prompts`
   - `pi.themes`
4. Run `npm install --package-lock-only --ignore-scripts` if the lockfile needs syncing.
5. Update `README.md` with the bundled package and public package/repo links.
6. Mention remove commands for duplicate standalone installs when useful.

Do not maintain a duplicate current bundled package list in this file; use `package.json` and `README.md`.

## Versioning

Use SemVer sensibly for changes to this kit:

- Patch: dependency updates, README/maintenance tweaks, small fixes to existing resources.
- Minor: adding a new bundled Pi package or a new skill/prompt/theme family.
- Major: removing/renaming resources or introducing behavior that could break an existing setup.

Before committing, choose the appropriate bump and run one of:

```bash
make bump-patch
make bump-minor
make bump-major
```

For dependency-only update runs, use:

```bash
make update-and-push
```

That target updates all direct npm dependencies to `latest`, bumps patch, validates, commits, and pushes `main`.

Tags are optional snapshots. Only tag when asked, using:

```bash
make tag-current
```

## Validation and commit workflow

Before committing and pushing normal changes:

1. Update `README.md` if package/resource/user-facing behavior changed.
2. Run the right version bump target.
3. Run:

   ```bash
   make validate
   ```

4. Commit the relevant files, usually including `package.json` and `package-lock.json` after version/dependency changes.
5. Push to `origin main`.

Keep commits focused and use simple imperative commit messages.
