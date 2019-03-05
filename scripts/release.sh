#!/bin/bash
set -e
export SHOPBASH_HOME=$HOME/.shopbash
source ${SHOPBASH_HOME}/utils/colors
# bump version frist but dont push
shopbash ms bump --no-push --no-tag
NEXT_VERSION="$(node -p "require('./package.json').version")"
# tag version
MESSAGE="feat: release version ${NEXT_VERSION}"
# git commit --amend -m "$MESSAGE"
git tag -a "v${NEXT_VERSION}" -m "$MESSAGE"
# release packages
npm run release
# prepare to publish dependency packages
cGreen "Publishing packages to Nexus"
npm run clean
npm install
npm run bootstrap
npm run publish
# clean after publish
npm run clean:build-artifacts
cGreen "Packages released to Nexus"
#
cPurple "Now you can run shopbash ms release [country]"
