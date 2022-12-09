DOCKER_IMAGE_NAME := ghcr.io/peaceiris/peaceiris/actions-export-envs
DOCKER_SCOPE := action-image-${GITHUB_REF_NAME}
DOCKER_CLI_EXPERIMENTAL := enabled
DOCKER_BUILDKIT := 1

.PHONY: setup-buildx
setup-buildx:
	docker buildx create --use --driver docker-container

.PHONY: build
build: setup-buildx
	docker buildx build . \
		--tag "${DOCKER_IMAGE_NAME}:latest" \
		--platform "linux/amd64" \
		--output "type=docker" \
		--cache-from "type=gha,scope=${DOCKER_SCOPE}" \
		--cache-to "type=gha,mode=max,scope=${DOCKER_SCOPE}"

.PHONY: login
login:
	echo "${GITHUB_TOKEN}" | docker login ghcr.io -u peaceiris --password-stdin

.PHONY: push
push:
	docker push "${DOCKER_IMAGE_NAME}:latest"
