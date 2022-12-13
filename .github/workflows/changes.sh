#!/bin/bash

set -ex
set -o pipefail

git fetch --no-tag --no-recurse-submodules --depth=10000 origin $GITHUB_BASE_REF
git fetch --no-tag --no-recurse-submodules --depth=10000 origin $GITHUB_HEAD_REF
MERGE_BASE="$(git merge-base --fork-point origin/$GITHUB_BASE_REF origin/$GITHUB_HEAD_REF)" || {
    echo "Probably this PR is not up-to-date. Please rebase with latest master and try again!" >&2
    exit 1
}
git diff ${MERGE_BASE}..${GITHUB_SHA} --name-only -- . | grep "$@"
