#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFESTS_DIR="${SCRIPT_DIR}/manifests"

echo "================================================================"
echo " Kubernetes Services, Ingress, ConfigMaps & Secrets Automation"
echo " Author: Bishwayan Chatterjee (24BCS10200)"
echo "================================================================"

echo ""
echo "[Step 1/6] Applying Configuration (ConfigMap & Secret)..."
kubectl apply -f "${MANIFESTS_DIR}/06-configmap.yaml"
kubectl apply -f "${MANIFESTS_DIR}/07-secret.yaml"

echo "Verifying ConfigMap and Secret creation:"
kubectl get configmap bish-app-config
kubectl get secret bish-app-secret

echo ""
echo "[Step 2/6] Deploying ClusterIP Service, Backend API & DNS Client..."
kubectl apply -f "${MANIFESTS_DIR}/01-clusterip-service.yaml"

echo "Waiting for backend pods and DNS test pod to reach Ready status..."
kubectl rollout status deployment/bish-backend-deployment
kubectl wait --for=condition=Ready pod/bish-dns-client --timeout=60s

echo "ClusterIP Service Details:"
kubectl get svc bish-backend-svc -o wide
echo "Endpoints registered for backend service:"
kubectl get endpoints bish-backend-svc

echo ""
echo "[Step 3/6] Verifying ClusterIP Internal DNS & Service Routing..."
echo "Executing CoreDNS lookup from within bish-dns-client pod:"
kubectl exec bish-dns-client -- nslookup bish-backend-svc || true

echo "Sending internal HTTP request via ClusterIP DNS name:"
kubectl exec bish-dns-client -- curl -s -I http://bish-backend-svc/

echo ""
echo "[Step 4/6] Deploying NodePort & LoadBalancer Services..."
kubectl apply -f "${MANIFESTS_DIR}/02-nodeport-service.yaml"
kubectl apply -f "${MANIFESTS_DIR}/03-loadbalancer-service.yaml"

echo "Waiting for frontend deployment rollout..."
kubectl rollout status deployment/bish-frontend-deployment

echo "Inspecting NodePort and LoadBalancer status:"
kubectl get svc bish-frontend-nodeport bish-gateway-lb

echo ""
echo "[Step 5/6] Deploying Headless Service & ExternalName Service..."
kubectl apply -f "${MANIFESTS_DIR}/04-headless-service.yaml"
kubectl apply -f "${MANIFESTS_DIR}/05-externalname-service.yaml"

echo "Waiting for StatefulSet pods..."
kubectl rollout status statefulset/bish-db --timeout=60s || true

echo "Headless Service Endpoints (Direct Pod IPs):"
kubectl get endpoints bish-db-headless

echo "ExternalName Service specification:"
kubectl get svc bish-external-db

echo ""
echo "[Step 6/6] Applying Ingress Layer-7 Routing Rules..."
kubectl apply -f "${MANIFESTS_DIR}/08-ingress.yaml"
kubectl get ingress bish-suite-ingress

echo ""
echo "================================================================"
echo " Kubernetes networking & services deployed and verified!"
echo "================================================================"
