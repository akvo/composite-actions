#!/usr/bin/env bash
#shellcheck disable=SC2039
set -exuo pipefail

# ${1} for repo/app name (image path segment under the gcloud project)
# ${2} for services (space-separated list)
# ${3} for source image tag to promote FROM (an already-built, tested tag, e.g. main.<sha>)
# ${4} for target cluster name (produces :latest-<cluster>, e.g. production)
# ${5} for optional extra version tag to also create (e.g. <ref>.<sha>);
#      skipped when empty or equal to the source tag

gcloud_project="akvo-lumen"
registry="eu.gcr.io"
image_prefix="${registry}/${gcloud_project}/${1}"
services="${2}"
source_tag="${3}"
cluster_name="${4}"
version_tag="${5:-}"

auth () {
    gcloud auth activate-service-account --key-file=gcp.json
    gcloud config set project "${gcloud_project}"
}

promote () {
    for service_name in ${services}; do
        dest_tags=("${image_prefix}/${service_name}:latest-${cluster_name}")
        if [ -n "${version_tag}" ] && [ "${version_tag}" != "${source_tag}" ]; then
            dest_tags+=("${image_prefix}/${service_name}:${version_tag}")
        fi
        # add-tag only moves manifest pointers (no layer pull/push) and fails
        # loudly if the source (tested) image does not exist for this commit.
        gcloud container images add-tag --quiet \
            "${image_prefix}/${service_name}:${source_tag}" \
            "${dest_tags[@]}"
    done
}

auth
promote
