#!/usr/bin/env bash
set -exuo pipefail

# ${1} for repo name
# ${2} for service name
# ${3} for image version

gcloud_project="akvo-lumen"
registry="eu.gcr.io"

auth () {
#    cat gcp.json
    gcloud auth activate-service-account --key-file=gcp.json
    gcloud config set project ${gcloud_project}
    gcloud config set container/cluster europe-west1-d
    gcloud config set compute/zone europe-west1-d
    gcloud config set container/use_client_certificate False
    gcloud auth configure-docker "${registry}"
}

push_image () {
    prefix="${registry}/${gcloud_project}/${1}"
    docker push "${prefix}/${2}:${3}"
    docker push "${prefix}/${2}:latest-test"
}

auth
push_image "${1}" "${2}" "${3}"