#!/bin/bash

set -e
set -o errtrace

SECRET_MANIFEST_PATH="./secret.yaml"
SERVICE_ACCOUNT_MANIFEST_PATH="./service-account.yaml"

#echo "Installing dependencies"
#apt-get -y update
#apt-get -y install jq

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

echo "docker secret and service-account created successfully"
exit 0