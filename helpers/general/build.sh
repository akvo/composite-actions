#!/usr/bin/env bash
#shellcheck disable=SC2039

set -exuo pipefail
# ${1} for repo name
# ${2} for service name
# ${3} for image version
# ${4} for dockerfile location

gcloud_project="akvo-lumen"
registry="eu.gcr.io"

image_prefix="${registry}/${gcloud_project}/${1}"

image_build () {
    service_name="${1}"
    image_version="${2}"
    dockerfile_location="${3}"

    cd "${dockerfile_location}" && docker build \
        --tag "${image_prefix}/${service_name}:latest-test" \
        --tag "${image_prefix}/${service_name}:${image_version}" .
}


image_build "${1}" "${2}" "${3}"