#!/usr/bin/env bash
set -exuo pipefail

# ${1} for repo name
# ${2} for service name
# ${3} for image version
# ${4} for cluster name

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

kubectl set image deployment/"${1}" "${2}"="${registry}"/"${gcloud_project}"/"${1}"/"${2}":"${3}" --namespace="${5}" --timeout=300s

kubectl rollout status deployment/"${1}" --namespace="${5}" --timeout=300s
