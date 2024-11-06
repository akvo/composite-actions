#!/usr/bin/env bash
set -exuo pipefail

# ${1} for deployment name
# ${2} for cluster name
# ${3} for namespace name

gcloud_project="akvo-lumen"
cluster_name=${2}

auth () {
    gcloud auth activate-service-account --key-file=gcp.json
    gcloud config set project ${gcloud_project}
    gcloud config set container/cluster europe-west1-d
    gcloud config set compute/zone europe-west1-d
    gcloud config set container/use_client_certificate False
    gcloud container clusters get-credentials "${cluster_name}"
}

auth

kubectl rollout restart deployment/"${1}" --namespace="${3}"

kubectl rollout status deployment/"${1}" --namespace="${3}" --timeout=300s
