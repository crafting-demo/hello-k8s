#!/bin/bash

BASE="$(readlink -nf ${BASH_SOURCE[0]%/*})"

set -x
for arg; do
    IMAGE="gcr.io/crafting-playground/demo/specialized/$arg:dev-${SANDBOX_APP}-${SANDBOX_NAME}"
    docker build "$BASE/../$arg" -t "$IMAGE"
    docker push "$IMAGE"
done
