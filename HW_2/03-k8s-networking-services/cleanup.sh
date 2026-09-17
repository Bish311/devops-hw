#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFESTS_DIR="${SCRIPT_DIR}/manifests"

echo "================================================================"
echo " Kubernetes Networking & Services Teardown"
echo " Author: Bishwayan Chatterjee (24BCS10200)"
echo "================================================================"

echo "Deleting Ingress resources..."
kubectl delete -f "${MANIFESTS_DIR}/08-ingress.yaml" --ignore-not-found=true

echo "Deleting Services and Deployments..."
kubectl delete -f "${MANIFESTS_DIR}/05-externalname-service.yaml" --ignore-not-found=true
kubectl delete -f "${MANIFESTS_DIR}/04-headless-service.yaml" --ignore-not-found=true
kubectl delete -f "${MANIFESTS_DIR}/03-loadbalancer-service.yaml" --ignore-not-found=true
kubectl delete -f "${MANIFESTS_DIR}/02-nodeport-service.yaml" --ignore-not-found=true
kubectl delete -f "${MANIFESTS_DIR}/01-clusterip-service.yaml" --ignore-not-found=true

echo "Deleting ConfigMap and Secret..."
kubectl delete -f "${MANIFESTS_DIR}/07-secret.yaml" --ignore-not-found=true
kubectl delete -f "${MANIFESTS_DIR}/06-configmap.yaml" --ignore-not-found=true

echo "All networking and service lab resources removed cleanly."
