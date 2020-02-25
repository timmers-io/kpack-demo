#!/bin/bash

set -e
set -o errtrace

ROOT_FOLDER="$(pwd)"
THIS_FOLDER="$(dirname "${BASH_SOURCE[0]}")"

# PRODUCT PREVIEW BITS
KPACK_MANIFEST_PATH="${1}" #"/mnt/c/Users/pivotal/Downloads/kpack/release-0.0.6.yaml"

# K8s MANIFESTS
CLUSTERBUILDER_MANIFEST_PATH="${THIS_FOLDER}/kpack-assets.yaml"

# VARIABLES
CLUSTERBUILDER_NAME="cloud-foundry"

if ! command -v "jq" >/dev/null; then
    writeErr "jq needs to be installed - 'apt-get -y install jq'"
    exit 1;
fi

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

echo "======= kpack namspace and assets created successfully ======="

echo "Creating ClusterBuilder resource, Service Account, and Account Secret from ${CLUSTERBUILDER_MANIFEST_PATH}"
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

exit 0
