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

# Build zone list (preferred zone first, then fallbacks without duplicates)
ZONES=("$ZONE")
for z in $FALLBACK_ZONES; do
    if [[ "$z" != "$ZONE" ]]; then
        ZONES+=("$z")
    fi
done

SUCCESS_ZONE=""

for zone in "${ZONES[@]}"; do
    echo ""
    echo "======================================"
    echo "Trying zone: $zone"
    echo "======================================"

    if gcloud container clusters create "$CLUSTER_NAME" \
        --zone "$zone" \
        --num-nodes="$NODE_COUNT" \
        --machine-type="$MACHINE_TYPE" \
        --enable-ip-alias \
        --release-channel=regular \
        --disk-type=pd-standard \
        --disk-size=50GB \
        --no-enable-master-authorized-networks; then

        SUCCESS_ZONE="$zone"
        echo "Cluster created successfully in $zone"
        break
    fi

    echo "Cluster creation failed in $zone."
    echo "Trying next available zone..."
done

if [[ -z "$SUCCESS_ZONE" ]]; then
    echo "ERROR: Cluster creation failed in all configured zones."
    exit 1
fi

echo ""
echo "Fetching cluster credentials..."

gcloud container clusters get-credentials \
    "$CLUSTER_NAME" \
    --zone "$SUCCESS_ZONE"

echo ""
echo "Cluster Nodes:"
kubectl get nodes -o wide

echo ""
echo "======================================"
echo "GKE Cluster is Ready!"
echo "Zone: $SUCCESS_ZONE"
echo "======================================"