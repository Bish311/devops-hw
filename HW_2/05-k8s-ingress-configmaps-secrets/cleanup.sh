#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFESTS_DIR="${SCRIPT_DIR}/manifests"

echo "================================================================"
echo " Kubernetes Ingress, ConfigMaps & Secrets Teardown"
echo " Author: Bishwayan Chatterjee (24BCS10200)"
echo "================================================================"

kubectl delete -f "${MANIFESTS_DIR}/06-ingress-routing.yaml" --ignore-not-found=true
kubectl delete -f "${MANIFESTS_DIR}/05-app-service.yaml" --ignore-not-found=true
kubectl delete -f "${MANIFESTS_DIR}/04-app-deployment.yaml" --ignore-not-found=true
kubectl delete -f "${MANIFESTS_DIR}/03-secret-opaque.yaml" --ignore-not-found=true
kubectl delete -f "${MANIFESTS_DIR}/02-configmap-volume.yaml" --ignore-not-found=true
kubectl delete -f "${MANIFESTS_DIR}/01-configmap-env.yaml" --ignore-not-found=true

echo "Cleanup completed successfully."
