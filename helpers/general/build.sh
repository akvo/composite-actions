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
service_name="${2}"
image_version="${3}"
dockerfile_location="${4}"
cluster_name="${5}"

image_build () {
    # Check if dockerfile_location is a directory
    if [ -d "${dockerfile_location}" ]; then
        # If it's a directory, change to that directory and build using the default Dockerfile
        cd "${dockerfile_location}" && docker build \
            --tag "${image_prefix}/${service_name}:latest-${cluster_name}" \
            --tag "${image_prefix}/${service_name}:${image_version}" .
    elif [ -f "${dockerfile_location}" ]; then
        # If it's a specific Dockerfile, change to the directory containing the Dockerfile
        dockerfile_dir="$(dirname "${dockerfile_location}")"
        dockerfile_name="$(basename "${dockerfile_location}")"
        cd "${dockerfile_dir}" && docker build --tag "${image_prefix}/${service_name}:latest-${cluster_name}" \
                                                  --tag "${image_prefix}/${service_name}:${image_version}" \
                                                  -f "${dockerfile_name}" .
    else
        echo "Error: The specified path is neither a directory nor a valid file."
        exit 1
    fi
}


image_build
