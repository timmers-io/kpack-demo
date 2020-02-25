#!/bin/bash

set -e
set -o errtrace

ROOT_FOLDER="$(pwd)"
THIS_FOLDER="$(dirname "${BASH_SOURCE[0]}")"

# PRODUCT PREVIEW BITS
KPACK_MANIFEST_PATH="/mnt/c/Users/pivotal/Downloads/kpack/release-0.0.6.yaml"
LOGS_ARCHIVE_PATH="/mnt/c/Users/pivotal/Downloads/kpack/logs-v0.0.6-linux.tgz"

# K8s MANIFESTS
CLUSTERBUILDER_MANIFEST_PATH="${THIS_FOLDER}/cluster-builder.yaml"
SECRET_MANIFEST_PATH="${THIS_FOLDER}/secret.yaml"
SERVICE_ACCOUNT_MANIFEST_PATH="${THIS_FOLDER}/service-account.yaml"

# VARIABLES
K8_CONTEXT_NAME="docker-desktop"
CLUSTERBUILDER_NAME="cloud-foundry"

if ! command -v "jq" >/dev/null; then
    writeErr "jq needs to be installed - 'apt-get -y install jq'"
    exit 1;
fi

echo "Setting K8 context to ${K8_CONTEXT_NAME}"
kubectl config use-context "${K8_CONTEXT_NAME}"

echo "Creating kpack things in K8 cluster"
if ! ret=$(kubectl apply --filename "${KPACK_MANIFEST_PATH}"); then
    echo "Could not apply kpack namespace"
    exit 1
fi

echo "Waiting for namespace kpack to be ready"
while true; do
    a=$(kubectl get pods --namespace kpack -o json)
    
    container1=$(echo "${a}" | jq '.items[0].status.phase')
    container2=$(echo "${a}" | jq '.items[1].status.phase')

    if [[ ("${container1}" == *"Running"*) && ("${container2}" == *"Running"*) ]]; then
        break
    fi

    echo -ne "."
    sleep 5s
done
echo ""

echo "Creating ClusterBuilder resource from ${CLUSTERBUILDER_MANIFEST_PATH}"
if ! kubectl apply -f "${CLUSTERBUILDER_MANIFEST_PATH}"; then
    echo "Could not apply ClusterBuilder"
    exit 1
fi

echo "Validate builder was created"
if ! ret=$(kubectl get clusterbuilder ${CLUSTERBUILDER_NAME} -o json); then
    echo "Could not get ClusterBuilder info"
    exit 1
fi

if [[ ! $(echo "${ret}" | jq '.status.conditions[0].status') == *"True"* ]]; then
    echo "ClusterBuilder status not true"
    exit 1
fi

echo "======= kpack resources installed successfully ======="

echo "Creating docker service secret"
if ! kubectl apply -f "${SECRET_MANIFEST_PATH}"; then
    echo "Could not create secret"
    exit 1
fi

echo "Creating docker service-account"
if ! kubectl apply -f "${SERVICE_ACCOUNT_MANIFEST_PATH}"; then
    echo "Could not create service-account"
    exit 1
fi

echo "======= docker secret and service-account created successfully ======="
exit 0
