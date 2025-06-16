#!/usr/bin/env bash
set -eu

docker run \
       --rm \
       --volume "$(pwd)/app:/app" \
       --workdir "/app" \
       --entrypoint /bin/sh \
			 akvo/akvo-node-18-alpine:20250306.055839.23cadbd \
			 -c 'yarn install && yarn build'
