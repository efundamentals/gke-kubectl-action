#!/bin/sh

set -e

# TODO: add here 
#if [ ! -d "$HOME/.config/gcloud" ]; then.
# and as else condition check if there was a change in the application credentials

if [ -z "${APPLICATION_CREDENTIALS-}" ]; then
   echo "APPLICATION_CREDENTIALS not found. Exiting...."
   exit 1
fi

if [ -z "${PROJECT_ID-}" ]; then
   echo "PROJECT_ID not found. Exiting...."
   exit 1
fi

echo "$APPLICATION_CREDENTIALS" | base64 -d > /tmp/account.json

gcloud auth activate-service-account --key-file=/tmp/account.json --project "$PROJECT_ID"

# TODO: add these paths to the runner if we want to share the auth
#echo ::add-path::/google-cloud-sdk/bin/gcloud
#echo ::add-path::/google-cloud-sdk/bin/gsutil
# maybe???:
# echo "{/google-cloud-sdk/bin/gcloud}" >> $GITHUB_PATH
# echo "{/google-cloud-sdk/bin/gsutil}" >> $GITHUB_PATH

# Update kubeConfig.
gcloud container clusters get-credentials "$CLUSTER_NAME" --zone "$ZONE_NAME" --project "$PROJECT_ID"

# verify kube-context
kubectl config current-context

sh -c "kubectl $*"
