# actions-export-envs

This action exports `ACTIONS_RUNTIME_TOKEN` and `ACTIONS_CACHE_URL` to enable the Docker layer caching on GitHub Actions.

cf. [GitHub Actions cache | Docker Documentation](https://docs.docker.com/build/building/cache/backends/gha/)


## Usage

Example:

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

https://github.com/peaceiris/actions-export-envs/blob/31e89d21c33421aee2c7780a6391715be3dd901a/Makefile#L12-L19

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

      - uses: peaceiris/actions-export-envs@v1.1.0
        id: envs

      - run: make build
        env:
          ACTIONS_RUNTIME_TOKEN: ${{ steps.envs.outputs.ACTIONS_RUNTIME_TOKEN }}
          ACTIONS_CACHE_URL: ${{ steps.envs.outputs.ACTIONS_CACHE_URL }}
```

https://github.com/peaceiris/actions-export-envs/blob/31e89d21c33421aee2c7780a6391715be3dd901a/.github/workflows/ci.yml#L48-L54
