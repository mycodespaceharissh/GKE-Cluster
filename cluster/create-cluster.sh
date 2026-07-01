#!/bin/bash
set -euo pipefail

# Load configuration
source ../configs/cluster-config.env

echo "======================================"
echo "Creating GKE Cluster"
echo "======================================"
echo "Project       : $PROJECT_ID"
echo "Cluster Name  : $CLUSTER_NAME"
echo "Region        : $REGION"
echo "Zone          : $ZONE"
echo "Node Count    : $NODE_COUNT"
echo "Machine Type  : $MACHINE_TYPE"
echo "======================================"

# Set the project
gcloud config set project "$PROJECT_ID"

# Create the cluster
gcloud container clusters create "$CLUSTER_NAME" \
  --zone "$ZONE" \
  --num-nodes "$NODE_COUNT" \
  --machine-type "$MACHINE_TYPE" \
  --enable-ip-alias \
  --release-channel regular \
  --disk-type=pd-standard \
  --disk-size=50GB \
  --no-enable-master-authorized-networks

echo "Cluster created successfully."

# Fetch cluster credentials
gcloud container clusters get-credentials "$CLUSTER_NAME" \
  --zone "$ZONE"

echo "Cluster nodes:"
kubectl get nodes -o wide

echo "======================================"
echo "GKE Cluster is Ready!"
echo "======================================"