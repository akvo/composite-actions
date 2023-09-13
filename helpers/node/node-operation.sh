#!/usr/bin/env bash
set -euv

# ${1} for node version
# ${2} for npm command

docker run \
       --rm \
       --volume "$(pwd)/frontend:/app" \
       --workdir "/app" \
       --entrypoint /bin/sh \
       akvo/akvo-node-18-alpine:20230831.105309.b9593b7 -c "${2}"
