#!/usr/bin/env bash
set -eu

docker run \
       --rm \
       --volume "$(pwd)/app:/app" \
       --workdir "/app" \
       --entrypoint /bin/sh \
			 akvo/akvo-node-18-alpine:20220923.084347.0558ee6 \
			 -c 'yarn install && yarn build'
