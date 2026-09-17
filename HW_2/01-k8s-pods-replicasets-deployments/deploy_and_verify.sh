#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFESTS_DIR="${SCRIPT_DIR}/manifests"

echo "================================================================"
echo " Kubernetes Core Objects Automation & Verification"
echo " Author: Bishwayan Chatterjee (24BCS10200)"
echo "================================================================"

echo ""
echo "[Step 1/6] Deploying single and multi-container pods..."
kubectl apply -f "${MANIFESTS_DIR}/01-pod.yaml"
kubectl apply -f "${MANIFESTS_DIR}/02-multi-container-pod.yaml"

echo "Waiting for pods to reach Running status..."
kubectl wait --for=condition=Ready pod/bish-web-pod --timeout=60s
kubectl wait --for=condition=Ready pod/bish-sidecar-pod --timeout=60s

echo "Verifying sidecar log streaming..."
sleep 6
kubectl logs bish-sidecar-pod -c sidecar-streamer --tail=5

echo ""
echo "[Step 2/6] Deploying ReplicaSet with self-healing..."
kubectl apply -f "${MANIFESTS_DIR}/03-replicaset.yaml"
kubectl rollout status replicaset/bish-api-rs || true
kubectl get pods -l app=bish-api -o wide

echo "Simulating pod failure to verify self-healing..."
TARGET_POD=$(kubectl get pods -l app=bish-api -o jsonpath='{.items[0].metadata.name}')
echo "Deleting pod ${TARGET_POD}..."
kubectl delete pod "${TARGET_POD}" --now

echo "Checking immediate recreation by ReplicaSet controller:"
sleep 3
kubectl get pods -l app=bish-api

echo ""
echo "[Step 3/6] Scaling ReplicaSet..."
echo "Scaling up to 5 replicas..."
kubectl scale rs/bish-api-rs --replicas=5
kubectl get rs bish-api-rs
sleep 2

echo "Scaling down to 2 replicas..."
kubectl scale rs/bish-api-rs --replicas=2
kubectl get rs bish-api-rs

echo ""
echo "[Step 4/6] Deploying Application Deployment (RollingUpdate)..."
kubectl apply -f "${MANIFESTS_DIR}/04-deployment-rolling.yaml"
kubectl rollout status deployment/bish-web-deployment
kubectl get deployment bish-web-deployment
kubectl get pods -l app=bish-web

echo ""
echo "[Step 5/6] Triggering Rolling Upgrade and Rollback..."
echo "Updating image from nginx:1.24-alpine to nginx:1.25-alpine..."
kubectl set image deployment/bish-web-deployment web=nginx:1.25-alpine --record
kubectl rollout status deployment/bish-web-deployment

echo "Viewing rollout history:"
kubectl rollout history deployment/bish-web-deployment

echo "Executing rollback to revision 1..."
kubectl rollout undo deployment/bish-web-deployment
kubectl rollout status deployment/bish-web-deployment

echo ""
echo "[Step 6/6] Deploying Recreate Strategy Deployment..."
kubectl apply -f "${MANIFESTS_DIR}/05-deployment-recreate.yaml"
kubectl rollout status deployment/bish-stateful-deployment
kubectl get deployment bish-stateful-deployment

echo ""
echo "================================================================"
echo " All Kubernetes core object operations completed successfully!"
echo "================================================================"
