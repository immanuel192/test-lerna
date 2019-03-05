#!/bin/bash
set -e
export SHOPBASH_HOME=$HOME/.shopbash
source ${SHOPBASH_HOME}/utils/colors

CURRENT_VERSION="$(node -p "require('./lerna.json').version")"
npm run release
NEXT_VERSION="$(node -p "require('./lerna.json').version")"
if [ "$CURRENT_VERSION" != "$NEXT_VERSION" ]; then
  cGreen "Publishing packages to Nexus"
  sed -i "" "s/\"version\": \"[0-9]*\.[0-9]*\.[0-9]*\"/\"version\": \"${NEXT_VERSION}\"/g" package.json
  git add . -A
  MESSAGE="feat(rate-and-tier-service): release version ${NEXT_VERSION}"
  git commit -m "$MESSAGE"
  git tag -a "v${NEXT_VERSION}" -m "$MESSAGE"
  npm run clean
  npm install
  npm run bootstrap
  npm run publish
  # after publish, there are some unnecessary changes in package.json files that to be clean
  # git reset --hard
  npm run clean:build-artifacts
  cGreen "Packages released to Nexus"
fi
