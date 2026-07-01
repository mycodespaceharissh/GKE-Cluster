#!/bin/bash
set -e

source ../configs/cluster-config.env

echo "Creating GKE cluster..."

gcloud config set project $PROJECT_ID

gcloud container clusters create $CLUSTER_NAME \
  --zone $ZONE \
  --num-nodes $NODE_COUNT \
  --machine-type $MACHINE_TYPE \
  --enable-ip-alias \
  --release-channel regular \
  --disk-type=pd-standard \
  --disk-size "50GB" \
  --no-enable-master-authorized-networks

echo "Cluster created successfully!"

# Get credentials
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE

kubectl get nodes