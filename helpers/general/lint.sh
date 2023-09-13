#!/usr/bin/env bash

set -eu

# Lint all script files
docker run --rm \
       --volume "$(pwd):/mnt" \
       --workdir /mnt \
       koalaman/shellcheck-alpine:v0.7.0 \
       sh -c "find /mnt -name '*.sh' -type f -print0 | xargs -0 -r -n1 shellcheck"
