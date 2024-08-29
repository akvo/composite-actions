#!/usr/bin/env bash
set -exuo pipefail

# ${1} for app name
# ${2} for deployment name
# ${3} for image version
# ${4} for cluster name
# ${5} for container name
# ${6} for namespace name

gcloud_project="akvo-lumen"
registry="eu.gcr.io"
cluster_name=${4}

auth () {
    gcloud auth activate-service-account --key-file=gcp.json
    gcloud config set project ${gcloud_project}
    gcloud config set container/cluster europe-west1-d
    gcloud config set compute/zone europe-west1-d
    gcloud config set container/use_client_certificate False
    gcloud container clusters get-credentials "${cluster_name}"
}

auth

kubectl set image deployment/"${2}" "${5}"="${registry}"/"${gcloud_project}"/"${1}"/"${5}":"${3}" --namespace="${6}"

kubectl rollout status deployment/"${2}" --namespace="${6}" --timeout=300s
