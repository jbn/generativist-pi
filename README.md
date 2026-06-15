# generativist-pi

Portable Pi configuration packaged for installation from git.

This repo is the start of moving reusable Pi resources out of `~/.pi` and into a versioned package.

## Install

Recommended during active development: install from the public GitHub repo without a pinned ref. This tracks the default branch, so Pi can notice when new commits are available.

```bash
pi install git:github.com/jbn/generativist-pi
```

Refresh/update later with:

```bash
pi update --extensions
```

For a fixed version, install a tagged ref instead:

```bash
pi install git:github.com/jbn/generativist-pi@v0.0.1
```

Pinned git tags do not auto-advance to newer tags; move them explicitly with `pi install git:github.com/jbn/generativist-pi@v0.0.2`.

This package is not published to npm. Do not use `npm:generativist-pi` unless it is published there later.

For local development/testing from this checkout:

```bash
npm install
pi -e .
```

If the GitHub owner/repo changes, update the install URL and the `repository.url` in `package.json`.

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
      "./node_modules/@juicesharp/rpiv-ask-user-question/index.ts"
    ],
    "skills": ["./skills"],
    "prompts": ["./prompts"],
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

## Migrated from `~/.pi`

The current global Pi settings included `npm:pi-powerline-footer`. This kit now installs it as an npm dependency and loads it from:

```json
"./node_modules/pi-powerline-footer/index.ts"
```

This kit also bundles `@juicesharp/rpiv-ask-user-question` and loads it from:

```json
"./node_modules/@juicesharp/rpiv-ask-user-question/index.ts"
```

If either extension is still installed separately, remove it after installing this kit to avoid loading it twice:

```bash
pi remove npm:pi-powerline-footer
pi remove npm:@juicesharp/rpiv-ask-user-question
```

Provider/model/auth settings remain local machine settings and are not bundled by Pi packages.

## Maintenance

Update every direct npm dependency in this kit to `latest`, validate the package, commit `package.json`/`package-lock.json`, and push `main`:

```bash
make update-and-push
```

Useful related targets:

```bash
make deps
make update-packages
make validate
```

## Release a new version

```bash
npm version patch --no-git-tag-version
VERSION=$(node -p "require('./package.json').version")
git add .
git commit -m "Release v$VERSION"
git tag "v$VERSION"
git push origin main --tags
```

Then install the new tag:

```bash
pi install git:github.com/jbn/generativist-pi@v0.0.2
```
