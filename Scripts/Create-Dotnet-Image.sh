#!/bin/bash

set -e
set -o errtrace

IMAGE_MANIFEST_PATH="./kpack-image-config.yaml"
IMAGE_NAME="kpack-dotnet-image"
LOG_EXE="/mnt/c/Users/pivotal/Downloads/kpack/logs"

echo "Creating kpack dotnet image"
if ! ret=$(kubectl apply -f "${IMAGE_MANIFEST_PATH}"); then
    echo "Could not apply image"
    exit 1
fi

echo "Check image initialization"
if ! ret=$(kubectl get image ${IMAGE_NAME} -o json); then
    echo "Could not get image ${IMAGE_NAME}"
    exit 1
fi

if [[ ! $(echo "${ret}" | jq '.status.conditions[0].status') == *"Unknown"* ]]; then
    echo "Image status not correct"
    exit 1
fi

if [[ ! $(echo "${ret}" | jq '.status.conditions[0].type') == *"Ready"* ]]; then
    echo "Image type not ready"
    exit 1
fi

${LOG_EXE} -image ${IMAGE_NAME}  

echo "Image created"
exit 0