#!/usr/bin/env bash
set -euv

# ${1} for node version
# ${2} for npm command

docker run \
       --rm \
       --volume "$(pwd)/frontend:/app" \
       --workdir "/app" \
       --entrypoint /bin/sh \
       akvo/akvo-node-18-alpine:20250306.055839.23cadbd -c "${2}"
