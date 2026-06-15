# generativist-pi

Portable Pi configuration packaged for installation from git.

This repo is the start of moving reusable Pi resources out of `~/.pi` and into a versioned package.

## Install

Once this repository is pushed to GitHub and tagged, install it with:

```bash
pi install git:github.com/jbn/generativist-pi@v0.0.1
```

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
      "./node_modules/pi-powerline-footer/index.ts"
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

## Migrated from `~/.pi`

The current global Pi settings included `npm:pi-powerline-footer`. This kit now installs it as an npm dependency and loads it from:

```json
"./node_modules/pi-powerline-footer/index.ts"
```

Provider/model/auth settings remain local machine settings and are not bundled by Pi packages.

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
