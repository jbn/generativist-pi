SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help deps update-packages validate update-and-push update-push

help:
	@printf "Available targets:\n"
	@printf "  make deps             Show direct npm dependencies that will be updated\n"
	@printf "  make update-packages  Update all direct npm dependencies to npm latest locally\n"
	@printf "  make validate         Install deps and run npm pack --dry-run\n"
	@printf "  make update-and-push  Pull main, update deps, commit package files, push main\n"
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
	npm install --save-exact --ignore-scripts $$deps; \
	npm install --package-lock-only --ignore-scripts

validate:
	@set -euo pipefail; \
	npm install --ignore-scripts; \
	npm pack --dry-run; \
	rm -rf node_modules

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
	$(MAKE) validate; \
	if git diff --quiet -- package.json package-lock.json; then \
		echo "No package updates to commit."; \
		exit 0; \
	fi; \
	git add package.json package-lock.json; \
	git commit -m "Update bundled Pi packages"; \
	git push origin main

update-push: update-and-push
