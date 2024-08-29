#!/usr/bin/env bash
set -exuo pipefail

# ${1} for repo name
# ${2} for service name
# ${3} for image version
# ${4} for cluster name

gcloud_project="akvo-lumen"
registry="eu.gcr.io"
image_prefix="${registry}/${gcloud_project}/${1}"
service_name="${2}"
image_version="${3}"
cluster_name="${4}"

auth () {
    gcloud auth activate-service-account --key-file=gcp.json
    gcloud config set project ${gcloud_project}
    gcloud config set container/cluster europe-west1-d
    gcloud config set compute/zone europe-west1-d
    gcloud config set container/use_client_certificate False
    gcloud auth configure-docker "${registry}"
}

push_image () {
    docker push "${image_prefix}/${service_name}:${image_version}"
    docker push "${image_prefix}/${service_name}:latest-${cluster_name}"
}

auth
push_image