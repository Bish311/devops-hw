BISHWAYAN CHATTERJEE -- 24BCS10200

# Kubernetes Fundamentals: Architecture & Core Management

This module explores core Kubernetes fundamentals: control plane vs worker node component architecture, declarative YAML resource management vs imperative CLI operations, namespaces, pod scheduling diagnostics, and in-container process execution.

---

## 1. Kubernetes Architecture Overview

```text
+-------------------------------------------------------------------------------+
|                               Control Plane Node                              |
|                                                                               |
|   +-----------------------+     +-----------------------+     +-----------+   |
|   |   kube-apiserver      |<--->|   kube-scheduler      |     |   etcd    |   |
|   | (REST API Gateway)    |     | (Node Placement Logic)|     | (KV Store)|   |
|   +-----------------------+     +-----------------------+     +-----------+   |
|               ^                             |                                 |
|               |                             v                                 |
|   +-----------------------+     +-----------------------+                     |
|   |kube-controller-manager|     | cloud-controller-mgr  |                     |
|   | (Reconciliation Loops)|     |  (Optional Cloud APIs)|                     |
|   +-----------------------+     +-----------------------+                     |
+-------------------------------------------------------------------------------+
                                      |
                                      v (gRPC / TLS)
+-------------------------------------------------------------------------------+
|                                Worker Node                                    |
|                                                                               |
|   +-----------------------+     +-----------------------+                     |
|   |        kubelet        |     |      kube-proxy       |                     |
|   |  (Pod Lifecycle Agent)|     |  (iptables / Service) |                     |
|   +-----------------------+     +-----------------------+                     |
|               |                                                               |
|               v                                                               |
|   +-----------------------------------------------------+                     |
|   |         Container Runtime (containerd / runc)       |                     |
|   |                 +-----------------+                 |                     |
|   |                 | Running Pods    |                 |                     |
|   |                 +-----------------+                 |                     |
|   +-----------------------------------------------------+                     |
+-------------------------------------------------------------------------------+
```

---

## 2. Directory Contents

```text
04-k8s-fundamentals/
├── manifests/
│   ├── 01-namespace.yaml             # Custom namespace manifest (bish-stage)
│   ├── 02-basic-pod.yaml             # Pod manifest with labels, annotations & resource limits
│   └── 03-multi-port-pod.yaml        # Diagnostic worker pod manifest
├── run_fundamentals.sh               # Automated execution script for fundamental operations
└── README.md                         # Technical guide, live verified logs & interview cheat sheet
```

---

## 3. Live Execution & Verified Outputs

### Step 1: Cluster Architecture & Node Health Inspection

Query cluster endpoint and node runtime details:
```bash
kubectl cluster-info
kubectl get nodes -o wide
```

**Real Command Output:**
```text
Kubernetes control plane is running at https://127.0.0.1:4878
CoreDNS is running at https://127.0.0.1:4878/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

NAME                    STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                       KERNEL-VERSION                             CONTAINER-RUNTIME
desktop-control-plane   Ready    control-plane   84m   v1.36.1   172.20.0.2    <none>        Debian GNU/Linux 13 (trixie)   6.6.87.1-microsoft-standard-WSL2 (amd64)   containerd://2.3.1
```

Inspect core control plane components:
```bash
kubectl get componentstatus
```

**Real Command Output:**
```text
NAME                 STATUS    MESSAGE   ERROR
scheduler            Healthy   ok        
controller-manager   Healthy   ok        
etcd-0               Healthy   ok        
```

---

### Step 2: Imperative Operations & Dynamic Metadata Labeling

Run an imperative test pod and dynamically modify labels and annotations:
```bash
kubectl run bish-imperative-test --image=nginx:1.25-alpine --port=80 --labels="env=test,owner=bishwayan"
kubectl wait --for=condition=Ready pod/bish-imperative-test --timeout=60s
kubectl label pod bish-imperative-test tier=frontend --overwrite
kubectl annotate pod bish-imperative-test release-lead="Bishwayan" --overwrite
kubectl get pod bish-imperative-test --show-labels
```

**Real Command Output:**
```text
pod/bish-imperative-test created
pod/bish-imperative-test condition met
pod/bish-imperative-test labeled
pod/bish-imperative-test annotated
NAME                   READY   STATUS    RESTARTS   AGE   LABELS
bish-imperative-test   1/1     Running   0          1s    env=test,owner=bishwayan,tier=frontend
```

---

### Step 3: Declarative Workload Deployment in Custom Namespaces

Apply namespace and workload manifests:
```bash
kubectl apply -f manifests/01-namespace.yaml
kubectl apply -f manifests/02-basic-pod.yaml
kubectl apply -f manifests/03-multi-port-pod.yaml
kubectl get pods -n bish-stage -o wide
```

**Real Command Output:**
```text
namespace/bish-stage created
pod/bish-core-web created
pod/bish-diagnostic-pod created
pod/bish-core-web condition met
pod/bish-diagnostic-pod condition met
NAME                  READY   STATUS    RESTARTS   AGE   IP           NODE                    NOMINATED NODE   READINESS GATES
bish-core-web         1/1     Running   0          34s   10.244.0.6   desktop-control-plane   <none>           <none>
bish-diagnostic-pod   1/1     Running   0          34s   10.244.0.7   desktop-control-plane   <none>           <none>
```

---

### Step 4: Pod Diagnostics & In-Container Command Execution

Inspect pod specification and resources:
```bash
kubectl describe pod bish-core-web -n bish-stage
```

**Real Command Output:**
```text
Name:             bish-core-web
Namespace:        bish-stage
Priority:         0
Service Account:  default
Node:             desktop-control-plane/172.20.0.2
Start Time:       Thu, 17 Sep 2026 23:08:32 +0530
Labels:           app=core-web
                  engineer=bishwayan
                  tier=frontend
Annotations:      build.version: 1.0.0
                  contact: bish@example.com
Status:           Running
IP:               10.244.0.6
Containers:
  nginx-server:
    Container ID:   containerd://02d10793fe3520c1d0cc35008bfe6811104c638bd1b8aa98861435bde5424132
    Image:          nginx:1.25-alpine
    Port:           80/TCP (http)
    Limits:
      cpu:     50m
      memory:  64Mi
    Requests:
      cpu:     25m
      memory:  32Mi
```

Execute non-invasive diagnostic commands inside the container:
```bash
kubectl exec -n bish-stage bish-core-web -- uname -a
kubectl exec -n bish-stage bish-core-web -- cat /etc/os-release
```

**Real Command Output:**
```text
Linux bish-core-web 6.6.87.1-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Mon Apr 21 17:08:54 UTC 2025 x86_64 Linux
NAME="Alpine Linux"
ID=alpine
VERSION_ID=3.19.1
PRETTY_NAME="Alpine Linux v3.19"
HOME_URL="https://alpinelinux.org/"
BUG_REPORT_URL="https://gitlab.alpinelinux.org/alpine/aports/-/issues"
```

---

## 4. Imperative vs Declarative Operations

| Criteria | Imperative (`kubectl run`, `kubectl create`) | Declarative (`kubectl apply -f`) |
|---|---|---|
| **Source of Truth** | Ephemeral CLI command arguments | Version-controlled YAML / JSON manifests (GitOps) |
| **Idempotency** | Non-idempotent; errors if object exists | Fully idempotent; reconciles diff against cluster state |
| **Auditability** | Difficult to track changes or review in PRs | Tracked via Git commits, code reviews, and CI/CD pipelines |
| **Best Practice** | Quick debugging, ad-hoc diagnostics, testing | All production deployments, infrastructure pipelines |

---

## 5. Interview Questions & Answers

**Q1: What are the primary control plane components and their responsibilities?**  
**A:**  
- **`kube-apiserver`**: The front-end entry point that exposes the Kubernetes REST API and handles authentication, authorization, and admission control.
- **`etcd`**: A consistent and highly-available distributed key-value store holding the complete cluster state.
- **`kube-scheduler`**: Watches for newly created unscheduled Pods and assigns them to suitable worker nodes based on resource requests, taints, and affinity rules.
- **`kube-controller-manager`**: Runs core control loops (Node Controller, ReplicaSet Controller, EndpointSlice Controller) to continuously drive cluster state toward the desired state.

**Q2: What is the exact role of the `kubelet` on worker nodes?**  
**A:** The `kubelet` is the primary node agent that registers the node with the API server. It watches PodSpecs assigned to that node and instructs the Container Runtime Interface (CRI, e.g., containerd) to pull images, run containers, mount volumes, and monitor container liveness/readiness probes, reporting status back to the control plane.
