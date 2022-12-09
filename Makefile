DOCKER_IMAGE_BASE_NAME := ghcr.io/peaceiris/actions-export-envs
DOCKER_IMAGE_FULL_NAME := ${DOCKER_IMAGE_BASE_NAME}:latest
DOCKER_SCOPE := action-image-${GITHUB_REF_NAME}
DOCKER_CLI_EXPERIMENTAL := enabled
DOCKER_BUILDKIT := 1
ACTION_FILE := action.yml

.PHONY: setup-buildx
setup-buildx:
	docker buildx create --use --driver docker-container

.PHONY: build
build: setup-buildx
	docker buildx build . \
		--tag "${DOCKER_IMAGE_FULL_NAME}" \
		--platform "linux/amd64,linux/arm64" \
		--output "type=docker" \
		--cache-from "type=gha,scope=${DOCKER_SCOPE}" \
		--cache-to "type=gha,mode=max,scope=${DOCKER_SCOPE}"

.PHONY: login
login:
	echo "${GITHUB_TOKEN}" | docker login ghcr.io -u peaceiris --password-stdin

.PHONY: push
push:
	docker push "${DOCKER_IMAGE_FULL_NAME}"

.PHONY: pull
pull:
	docker pull "${DOCKER_IMAGE_FULL_NAME}"

.PHONY: release
release:
	DOCKER_IMAGE_FULL_NAME=${DOCKER_IMAGE_FULL_NAME} ACTION_FILE=${ACTION_FILE} \
		bash ./scripts/release.sh
