BISHWAYAN CHATTERJEE -- 24BCS10200

# Kubernetes Ingress, ConfigMaps & Secrets

This module provides a complete, hands-on implementation of decoupled application configuration, sensitive credential storage, and Layer-7 traffic routing synthesized directly from class curriculum (Session 12: Ingress, ConfigMaps & Secrets).

---

## 1. Architectural Overview

```text
                        External Ingress Traffic
                                  |
                                  v
                   +-----------------------------+
                   |  Ingress Controller (L7)    |
                   |  Host: gateway.internal...  |
                   +-----------------------------+
                                  |
                                  v
                   +-----------------------------+
                   |  Service: bish-gateway-svc  |
                   |  (ClusterIP on Port 80)     |
                   +-----------------------------+
                                  |
                                  v
       +-----------------------------------------------------+
       |           Pod: bish-gateway-deployment              |
       |                                                     |
       |   +-------------------+     +-------------------+   |
       |   |   ConfigMap Env   |     |   Secret (Base64) |   |
       |   |  APP_ENV, AUTHOR  |     |  DB_USER, DB_PASS |   |
       |   +-------------------+     +-------------------+   |
       |             \                         /             |
       |              v                       v              |
       |         +---------------------------------+         |
       |         |       Nginx Gateway Container   |         |
       |         |                                 |         |
       |         | Mounted: /etc/bish-config/      |         |
       |         |          (settings.json)        |         |
       |         +---------------------------------+         |
       +-----------------------------------------------------+
```

---

## 2. Directory Contents

```text
05-k8s-ingress-configmaps-secrets/
├── manifests/
│   ├── 01-configmap-env.yaml         # Plain-text environment variables ConfigMap
│   ├── 02-configmap-volume.yaml      # File-based ConfigMap mounted as volume (settings.json)
│   ├── 03-secret-opaque.yaml         # Sensitive credentials Opaque Secret
│   ├── 04-app-deployment.yaml        # Deployment consuming ConfigMap & Secret via env & volume
│   ├── 05-app-service.yaml           # ClusterIP Service abstraction
│   └── 06-ingress-routing.yaml       # Layer-7 Ingress path-based routing rule
├── run_demo.sh                       # Automated deployment, verification & in-pod inspection
├── cleanup.sh                        # Teardown script for all lab resources
└── README.md                         # Comprehensive guide, live verified outputs & cheat sheet
```

---

## 3. Live Execution & Verified Outputs

### Step 1: ConfigMaps Deployment (Environment & Volume File)

Apply both environment and file-based ConfigMaps:
```bash
kubectl apply -f manifests/01-configmap-env.yaml
kubectl apply -f manifests/02-configmap-volume.yaml
kubectl get configmap bish-gateway-config bish-file-config
```

**Real Command Output:**
```text
configmap/bish-gateway-config created
configmap/bish-file-config created
NAME                  DATA   AGE
bish-gateway-config   5      0s
bish-file-config      1      0s
```

---

### Step 2: Sensitive Credentials Secret Storage

Apply Secret and verify base64 decoding:
```bash
kubectl apply -f manifests/03-secret-opaque.yaml
kubectl get secret bish-gateway-secrets
kubectl get secret bish-gateway-secrets -o jsonpath='{.data.DB_USER}' | base64 --decode
echo ""
```

**Real Command Output:**
```text
secret/bish-gateway-secrets created
NAME                   TYPE     DATA   AGE
bish-gateway-secrets   Opaque   3      0s
bish_db_master
```

---

### Step 3: Application Deployment & ClusterIP Service

Deploy the workload consuming the configurations:
```bash
kubectl apply -f manifests/04-app-deployment.yaml
kubectl apply -f manifests/05-app-service.yaml
kubectl rollout status deployment/bish-gateway-deployment
kubectl get svc bish-gateway-svc
```

**Real Command Output:**
```text
deployment.apps/bish-gateway-deployment created
service/bish-gateway-svc created
Waiting for deployment "bish-gateway-deployment" rollout to finish: 0 of 2 updated replicas are available...
Waiting for deployment "bish-gateway-deployment" rollout to finish: 1 of 2 updated replicas are available...
deployment "bish-gateway-deployment" successfully rolled out
NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
bish-gateway-svc   ClusterIP   10.96.117.185   <none>        80/TCP    1s
```

---

### Step 4: In-Pod Configuration Verification

Query environment variables directly inside the running container:
```bash
TARGET_POD=$(kubectl get pods -l app=bish-gateway -o jsonpath='{.items[0].metadata.name}')
kubectl exec "${TARGET_POD}" -- env | grep -E 'APP_ENV|APP_AUTHOR|DB_USER'
```

**Real Command Output:**
```text
DB_USER=bish_db_master
APP_ENV=production
APP_AUTHOR=Bishwayan
```

Verify that the file-based ConfigMap was projected into `/etc/bish-config/settings.json`:
```bash
kubectl exec "${TARGET_POD}" -- cat /etc/bish-config/settings.json
```

**Real Command Output:**
```json
{
  "gateway": "bish-edge-router",
  "version": "2.4.0",
  "rateLimitPerMin": 1000,
  "adminEmail": "bish@example.com"
}
```

---

### Step 5: Layer-7 Ingress Route Deployment

Deploy the Ingress routing rules:
```bash
kubectl apply -f manifests/06-ingress-routing.yaml
kubectl get ingress bish-gateway-ingress
```

**Real Command Output:**
```text
ingress.networking.k8s.io/bish-gateway-ingress created
NAME                   CLASS   HOSTS                          ADDRESS   PORTS   AGE
bish-gateway-ingress   nginx   gateway.internal.example.com             80      1s
```

---

## 4. ConfigMap & Secret Ingestion Patterns

| Ingestion Pattern | Best For | Behavior on ConfigMap Update |
|---|---|---|
| **Environment Variable (`valueFrom.configMapKeyRef`)** | Simple scalar values (`PORT`, `ENV`) | Static; requires pod restart/rollout to take effect |
| **Bulk Environment (`envFrom.configMapRef`)** | Injecting all keys as env variables | Static; requires pod restart/rollout to take effect |
| **Volume Mount (`volumes.configMap`)** | Config files (`.conf`, `.json`, `.yaml`) | **Dynamic / Hot Reload**; kubelet automatically updates the mounted file without pod restart |

---

## 5. Interview Questions & Answers

**Q1: How are Kubernetes Secrets stored and are they encrypted by default?**  
**A:** By default, Kubernetes Secrets are stored as **base64-encoded plain text** inside `etcd`. Base64 is an encoding scheme, NOT encryption. In production, clusters must enable **Encryption at Rest** in `etcd` using AWS KMS, GCP Cloud KMS, or HashiCorp Vault, and enforce RBAC policies to restrict secret access.

**Q2: How does an Ingress Controller work under the hood?**  
**A:** An Ingress resource is simply metadata defining routing rules. The **Ingress Controller** (such as `ingress-nginx`) is a specialized reverse proxy daemon that runs inside the cluster, listens to the Kubernetes API server for Ingress, Service, and Endpoint events, and dynamically regenerates its routing configuration (e.g. `nginx.conf`) to proxy Layer-7 HTTP/HTTPS requests directly to backing Pod IPs.
