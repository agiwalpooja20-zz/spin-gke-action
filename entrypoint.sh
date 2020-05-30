#!/bin/sh

set -e

if [ ! -d "$HOME/.config/gcloud" ]; then
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

fi

echo ::add-path::/google-cloud-sdk/bin/gcloud
echo ::add-path::/google-cloud-sdk/bin/gsutil

export GOOGLE_APPLICATION_CREDENTIALS="/tmp/account.json"

gcloud container clusters create "$CLUSTER_NAME" --zone "$ZONE_NAME" --scopes=https://www.googleapis.com/auth/cloud-platform,userinfo-email

gcloud container clusters list

gcloud config set account fission-accel@omni-163105.iam.gserviceaccount.com 

gcloud config set project "$PROJECT_ID"

gcloud config set compute/zone "$ZONE_NAME"

sleep 300

gcloud container clusters get-credentials "$CLUSTER_NAME" --zone "$ZONE_NAME" --project "$PROJECT_ID"

gcloud config list
