#!/bin/bash

set -x
set -e

build_args=(
  --tag ibkr-client-portal-api:latest
  --platform linux/amd64,linux/arm64
)

if [ ! -z "$DEBUG_DOCKER" ]; then
  build_args+=(--progress=plain)
  build_args+=(--no-cache)
fi

DOCKER_BUILDKIT=1 docker buildx build "${build_args[@]}" .
