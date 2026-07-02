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
echo "Preferred Zone: $ZONE"
echo "Node Count    : $NODE_COUNT"
echo "Machine Type  : $MACHINE_TYPE"
echo "======================================"

# Set project
gcloud config set project "$PROJECT_ID"

gcloud container clusters create "$CLUSTER_NAME" \
    --zone "$zone" \
    --num-nodes="$NODE_COUNT" \
    --disk-type=pd-"DISK_TYPE" \
    --disk-size="DISK_SIZE";

echo "Cluster created successfully in $zone"
echo ""
echo "Fetching cluster credentials..."

gcloud container clusters get-credentials \
    "$CLUSTER_NAME" \
    --zone "$zone"

echo ""
echo "Cluster Nodes:"
kubectl get nodes -o wide

echo ""
echo "======================================"
echo "GKE Cluster is Ready!"
echo "Zone: $zone"
echo "======================================"