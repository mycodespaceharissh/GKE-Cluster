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
    --zone "$ZONE" \
    --num-nodes="$NODE_COUNT" \
    --disk-type=pd-standard \
    --disk-size=50GB;
echo "Cluster created successfully in $ZONE"
echo ""
echo "Fetching cluster credentials..."

gcloud container clusters get-credentials \
    "$CLUSTER_NAME" \
    --zone "$ZONE"

echo ""
echo "Cluster Nodes:"
kubectl get nodes -o wide

echo ""
echo "======================================"
echo "GKE Cluster is Ready!"
echo "Zone: $ZONE"
echo "======================================"