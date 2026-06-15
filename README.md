# generativist-pi

Portable Pi configuration packaged for installation from git.

Public repo: <https://github.com/jbn/generativist-pi>

This repo is my portable Pi configuration kit: one repo I can install or update on any computer to get my preferred Pi extensions, skills, prompts, themes, and notes scaffolding.

## Install

Recommended: install from the public GitHub repo without a pinned ref. This tracks the default branch, so Pi can notice when new commits are available.

```bash
pi install git:github.com/jbn/generativist-pi
```

Refresh/update later with:

```bash
pi update --extensions
```

For a fixed snapshot, install a tagged ref instead:

```bash
pi install git:github.com/jbn/generativist-pi@v0.0.1
```

Pinned git tags do not auto-advance to newer tags; move them explicitly with `pi install git:github.com/jbn/generativist-pi@<tag>`.

This package is not published to npm. Do not use `npm:generativist-pi` unless it is published there later.

For local development/testing from this checkout:

```bash
npm install
pi -e .
```

## Package layout

Pi loads resources declared in `package.json`:

```json
{
  "name": "generativist-pi",
  "keywords": ["pi-package"],
  "pi": {
    "extensions": [
      "./extensions",
      "./node_modules/pi-powerline-footer/index.ts",
      "./node_modules/@juicesharp/rpiv-ask-user-question/index.ts",
      "./node_modules/pi-simplify/dist/index.js",
      "./node_modules/pi-subagents/src/extension/index.ts"
    ],
    "skills": ["./skills", "./node_modules/pi-subagents/skills"],
    "prompts": ["./prompts", "./node_modules/pi-subagents/prompts"],
    "themes": ["./themes"]
  }
}
```

Current directories:

- `extensions/` - custom Pi extensions (`.ts` / `.js`)
- `skills/` - Pi skills (`SKILL.md` folders or top-level `.md` files)
- `prompts/` - reusable prompt templates (`.md`)
- `themes/` - Pi themes (`.json`)
- `NOTES/` - personal/project Markdown notes (not loaded by Pi automatically)

## Bundled Pi packages

This kit currently bundles these npm Pi packages and loads their resources from `node_modules/`:

- [`pi-powerline-footer`](https://github.com/nicobailon/pi-powerline-footer) - powerline-style Pi footer/status bar
- [`@juicesharp/rpiv-ask-user-question`](https://github.com/juicesharp/rpiv-mono/tree/main/packages/rpiv-ask-user-question) - structured `ask_user_question` tool
- [`pi-simplify`](https://github.com/MattDevy/pi-extensions/tree/main/packages/pi-simplify) - code clarity/simplification review command
- [`pi-subagents`](https://github.com/nicobailon/pi-subagents) - subagent delegation extension, skills, and prompts

If any bundled package is still installed separately, remove it after installing this kit to avoid loading it twice:

```bash
pi remove npm:pi-powerline-footer
pi remove npm:@juicesharp/rpiv-ask-user-question
pi remove npm:pi-simplify
pi remove npm:pi-subagents
```

Provider/model/auth settings remain local machine settings and are not bundled by Pi packages.

## Maintenance

Validate the package:

```bash
make validate
```

Bump versions before committing meaningful changes:

```bash
make bump-patch   # dependency updates, docs/maintenance, small fixes
make bump-minor   # new bundled package or new skill/prompt/theme family
make bump-major   # breaking removals/renames/behavior changes
```

Update every direct npm dependency in this kit to `latest`, bump patch, validate, commit `package.json`/`package-lock.json`, and push `main`:

```bash
make update-and-push
```

Useful related targets:

```bash
make deps
make update-packages
make tag-current
```

## Version tags

Normal installs should track `main` with `git:github.com/jbn/generativist-pi`. Tags are optional fixed snapshots. To tag the current package version and push the tag:

```bash
make tag-current
```
