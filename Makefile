SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help deps update-packages validate bump-patch bump-minor bump-major tag-current update-and-push update-push

help:
	@printf "Available targets:\n"
	@printf "  make deps             Show direct npm dependencies that will be updated\n"
	@printf "  make update-packages  Update all direct npm dependencies to npm latest locally\n"
	@printf "  make validate         Install deps and run npm pack --dry-run\n"
	@printf "  make bump-patch       Bump package.json/package-lock.json patch version\n"
	@printf "  make bump-minor       Bump package.json/package-lock.json minor version\n"
	@printf "  make bump-major       Bump package.json/package-lock.json major version\n"
	@printf "  make tag-current      Tag HEAD as v$$(node -p \"require('./package.json').version\") and push the tag\n"
	@printf "  make update-and-push  Pull main, update deps, bump patch, validate, commit, push\n"
	@printf "  make update-push      Alias for update-and-push\n"

deps:
	@node -e 'const p=require("./package.json"); const deps=Object.keys(p.dependencies||{}); console.log(deps.length ? deps.join("\n") : "No dependencies in package.json");'

update-packages:
	@set -euo pipefail; \
	deps="$$(node -e 'const p=require("./package.json"); process.stdout.write(Object.keys(p.dependencies||{}).map(function(name){return name+"@latest";}).join(" "));')"; \
	if [[ -z "$$deps" ]]; then \
		echo "No dependencies in package.json"; \
		exit 0; \
	fi; \
	echo "Updating: $$deps"; \
	npm install --save-exact --package-lock-only --ignore-scripts $$deps

bump-patch:
	@npm version patch --no-git-tag-version
	@npm install --package-lock-only --ignore-scripts

bump-minor:
	@npm version minor --no-git-tag-version
	@npm install --package-lock-only --ignore-scripts

bump-major:
	@npm version major --no-git-tag-version
	@npm install --package-lock-only --ignore-scripts

validate:
	@set -euo pipefail; \
	npm install --ignore-scripts; \
	npm pack --dry-run; \
	rm -rf node_modules

tag-current:
	@set -euo pipefail; \
	version="$$(node -p "require('./package.json').version")"; \
	git tag "v$$version"; \
	git push origin "v$$version"

update-and-push:
	@set -euo pipefail; \
	if [[ "$$(git branch --show-current)" != "main" ]]; then \
		echo "Must be on main" >&2; \
		exit 1; \
	fi; \
	if [[ -n "$$(git status --porcelain)" ]]; then \
		echo "Working tree is not clean; commit or stash changes first." >&2; \
		git status --short; \
		exit 1; \
	fi; \
	git pull --ff-only origin main; \
	$(MAKE) update-packages; \
	if git diff --quiet -- package.json package-lock.json; then \
		echo "No package updates to commit."; \
		exit 0; \
	fi; \
	$(MAKE) bump-patch; \
	$(MAKE) validate; \
	git add package.json package-lock.json; \
	version="$$(node -p "require('./package.json').version")"; \
	git commit -m "Update bundled Pi packages to v$$version"; \
	git push origin main

update-push: update-and-push
