#!/usr/bin/env bash

# fail on unset variables and command errors
set -eu -o pipefail # -x: is for debugging

DOCKER_DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' "${DOCKER_IMAGE_FULL_NAME}" | tr -d '\n')
sed -i "s%image: 'Dockerfile'%image: 'docker://${DOCKER_DIGEST}'%" "${ACTION_FILE}"

git add "${ACTION_FILE}"
git commit -m "chore: update digest"
git push origin main

RELEASE_NOTES=$(mktemp)
CURRENT_TAG=$(git describe --abbrev=0)
NEW_VERSION=$(npm_config_yes=true npx semver "${CURRENT_TAG}" --increment "${SEMVER_TYPE}")
NEW_TAG="v${NEW_VERSION}"
RELEASE_TITLE="Release ${NEW_TAG}"
git tag -a "${NEW_TAG}" -m "${RELEASE_TITLE}"
git push origin "${NEW_TAG}"
echo "See [CHANGELOG](https://github.com/${GITHUB_REPOSITORY}/compare/${CURRENT_TAG}...${NEW_TAG}) for more details." > "${RELEASE_NOTES}"
gh release create "${NEW_TAG}" --title "${RELEASE_TITLE}" --notes-file "${RELEASE_NOTES}"

sed -i "s%image: 'docker://${DOCKER_DIGEST}'%image: 'Dockerfile'%" "${ACTION_FILE}"

git add "${ACTION_FILE}"
git commit -m "chore: revert digest"
git push origin main
