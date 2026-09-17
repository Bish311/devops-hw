#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFESTS_DIR="${SCRIPT_DIR}/manifests"

echo "================================================================"
echo " Kubernetes Fundamentals: Architecture & Core Management"
echo " Author: Bishwayan Chatterjee (24BCS10200)"
echo "================================================================"

echo ""
echo "[Step 1/5] Cluster Architecture & Node Inspection..."
kubectl cluster-info
kubectl get nodes -o wide
kubectl get componentstatus 2>/dev/null || kubectl get --raw='/readyz?verbose'

echo ""
echo "[Step 2/5] Imperative Workload Operations..."
kubectl delete pod bish-imperative-test --ignore-not-found=true
echo "Running imperative test pod..."
kubectl run bish-imperative-test --image=nginx:1.25-alpine --port=80 --labels="env=test,owner=bishwayan"

echo "Waiting for pod to be ready..."
kubectl wait --for=condition=Ready pod/bish-imperative-test --timeout=60s

echo "Adding labels and annotations imperatively:"
kubectl label pod bish-imperative-test tier=frontend --overwrite
kubectl annotate pod bish-imperative-test release-lead="Bishwayan" --overwrite

echo "Inspecting imperative pod labels and status:"
kubectl get pod bish-imperative-test --show-labels

echo ""
echo "[Step 3/5] Declarative Deployment across Custom Namespaces..."
kubectl apply -f "${MANIFESTS_DIR}/01-namespace.yaml"
kubectl apply -f "${MANIFESTS_DIR}/02-basic-pod.yaml"
kubectl apply -f "${MANIFESTS_DIR}/03-multi-port-pod.yaml"

echo "Waiting for declarative pods in bish-stage namespace..."
kubectl wait --for=condition=Ready pod/bish-core-web -n bish-stage --timeout=60s
kubectl wait --for=condition=Ready pod/bish-diagnostic-pod -n bish-stage --timeout=60s

echo "Listing pods in bish-stage namespace:"
kubectl get pods -n bish-stage -o wide

echo ""
echo "[Step 4/5] Pod Diagnostics, Describe & In-Pod Execution..."
echo "Describing bish-core-web pod:"
kubectl describe pod bish-core-web -n bish-stage | head -n 30

echo "Executing command inside bish-core-web pod:"
kubectl exec -n bish-stage bish-core-web -- uname -a
kubectl exec -n bish-stage bish-core-web -- cat //etc/os-release

echo ""
echo "[Step 5/5] Resource Teardown & Namespace Cleanup..."
echo "Deleting imperative pod..."
kubectl delete pod bish-imperative-test --now

echo "Deleting bish-stage namespace and enclosed resources..."
kubectl delete namespace bish-stage --now

echo ""
echo "================================================================"
echo " Kubernetes fundamentals operations completed successfully!"
echo "================================================================"
