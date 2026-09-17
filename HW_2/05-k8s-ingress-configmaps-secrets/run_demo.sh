#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFESTS_DIR="${SCRIPT_DIR}/manifests"

echo "================================================================"
echo " Kubernetes Ingress, ConfigMaps & Secrets Automation"
echo " Author: Bishwayan Chatterjee (24BCS10200)"
echo "================================================================"

echo ""
echo "[Step 1/5] Applying ConfigMaps (Env & Volume File)..."
kubectl apply -f "${MANIFESTS_DIR}/01-configmap-env.yaml"
kubectl apply -f "${MANIFESTS_DIR}/02-configmap-volume.yaml"
kubectl get configmap bish-gateway-config bish-file-config

echo ""
echo "[Step 2/5] Applying Secret (Opaque Base64 Credentials)..."
kubectl apply -f "${MANIFESTS_DIR}/03-secret-opaque.yaml"
kubectl get secret bish-gateway-secrets

echo "Decoding stored DB_USER secret:"
kubectl get secret bish-gateway-secrets -o jsonpath='{.data.DB_USER}' | base64 --decode
echo ""

echo ""
echo "[Step 3/5] Deploying Application & ClusterIP Service..."
kubectl apply -f "${MANIFESTS_DIR}/04-app-deployment.yaml"
kubectl apply -f "${MANIFESTS_DIR}/05-app-service.yaml"
kubectl rollout status deployment/bish-gateway-deployment
kubectl get svc bish-gateway-svc

echo ""
echo "[Step 4/5] Verifying In-Container Injected Configurations..."
TARGET_POD=$(kubectl get pods -l app=bish-gateway -o jsonpath='{.items[0].metadata.name}')

echo "Checking environment variables inside ${TARGET_POD}:"
kubectl exec "${TARGET_POD}" -- env | grep -E 'APP_ENV|APP_AUTHOR|DB_USER'

echo "Checking mounted configuration volume file:"
kubectl exec "${TARGET_POD}" -- cat //etc/bish-config/settings.json

echo ""
echo "[Step 5/5] Deploying & Verifying Ingress Layer-7 Route..."
kubectl apply -f "${MANIFESTS_DIR}/06-ingress-routing.yaml"
kubectl get ingress bish-gateway-ingress

echo ""
echo "================================================================"
echo " Ingress, ConfigMaps & Secrets demonstration completed!"
echo "================================================================"
