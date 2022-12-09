# actions-export-envs

This action exports ACTIONS_RUNTIME_TOKEN and ACTIONS_CACHE_URL to enable the Docker layer caching on GitHub Actions.


## Usage

Example:

- https://github.com/peaceiris/hugo-extended-docker/blob/43ca6dc7587711fca59346e16e0c25264413f1a4/.github/workflows/ci.yml
- https://github.com/peaceiris/hugo-extended-docker/blob/43ca6dc7587711fca59346e16e0c25264413f1a4/Makefile

```Makefile
DOCKER_CLI_EXPERIMENTAL := enabled
DOCKER_BUILDKIT := 1
DOCKER_SCOPE := action-image-${GITHUB_REF_NAME}

PKG_NAME := ghcr.io/peaceiris/actions-export-envs:latest

.PHONY: setup-buildx
setup-buildx:
	docker buildx create --use --driver docker-container

.PHONY: build
build: setup-buildx
	docker buildx build . \
		--tag "${PKG_NAME}" \
		--platform "linux/amd64" \
		--output "type=docker" \
		--cache-from "type=gha,scope=${DOCKER_SCOPE}" \
		--cache-to "type=gha,mode=max,scope=${DOCKER_SCOPE}"
```

```yaml
name: CI

on:
  push:
  pull_request:

jobs:
  main:
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v3

      - uses: peaceiris/actions-export-envs@v1.0.0
        id: envs

      - run: make build
        env:
          ACTIONS_RUNTIME_TOKEN: ${{ steps.envs.outputs.ACTIONS_RUNTIME_TOKEN }}
          ACTIONS_CACHE_URL: ${{ steps.envs.outputs.ACTIONS_CACHE_URL }}
```
