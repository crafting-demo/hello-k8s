#!/bin/bash

TAG="dev-${SANDBOX_APP}-${SANDBOX_NAME}"
sed -r "s/^(\\s+image:[^:]+:)latest\$/\\1$TAG/g" "${BASH_SOURCE[0]%/*}/kubernetes.yaml" | kubectl apply -n "$APP_NS" -f -
