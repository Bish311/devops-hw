BISHWAYAN CHATTERJEE -- 24BCS10200

# Kubernetes Pods, ReplicaSets & Deployments

This module covers the design, deployment, lifecycle management, and verification of foundational Kubernetes workload controllers: Pods (single and multi-container patterns), ReplicaSets (label selector matching and self-healing), and Deployments (zero-downtime rolling updates, recreate strategy, and rollback execution).

---

## Architecture Overview

```text
       +-------------------------------------------------------------+
       |                         Deployment                          |
       |  (Declarative updates, rollout history, revision control)   |
       +-------------------------------------------------------------+
                                      |
                                      v  manages
       +-------------------------------------------------------------+
       |                         ReplicaSet                          |
       |  (Ensures exact desired replica count, self-healing)        |
       +-------------------------------------------------------------+
                                      |
                       +--------------+--------------+
                       |              |              |
                       v              v              v
                 +-----------+  +-----------+  +-----------+
                 |    Pod    |  |    Pod    |  |    Pod    |
                 | Container |  | Container |  | Container |
                 +-----------+  +-----------+  +-----------+
```

---

## Directory Contents

```text
01-k8s-pods-replicasets-deployments/
├── manifests/
│   ├── 01-pod.yaml                  # Single container Pod with liveness probe & resource limits
│   ├── 02-multi-container-pod.yaml  # Multi-container Pod (Sidecar logging pattern with emptyDir)
│   ├── 03-replicaset.yaml           # ReplicaSet specification (3 replicas, label selector)
│   ├── 04-deployment-rolling.yaml   # Deployment with RollingUpdate strategy (zero downtime)
│   └── 05-deployment-recreate.yaml  # Deployment with Recreate strategy (stateful workload)
├── deploy_and_verify.sh             # End-to-end automated lifecycle execution script
└── README.md                        # Technical guide, live verified outputs & interview cheat sheet
```

---

## Live Execution & Verified Outputs

### Task 1: Pod Lifecycle & Multi-Container Pods

#### 1.1 Single-Container Pod (`bish-web-pod`)

Deploy a web server pod with defined CPU/memory requests and an HTTP liveness probe:

```bash
kubectl apply -f manifests/01-pod.yaml
kubectl wait --for=condition=Ready pod/bish-web-pod --timeout=60s
```

**Real Command Output:**
```text
pod/bish-web-pod created
pod/bish-web-pod condition met
```

Inspect the running pod:
```bash
kubectl get pod bish-web-pod -o wide
```

**Real Command Output:**
```text
NAME           READY   STATUS    RESTARTS   AGE   IP            NODE                    NOMINATED NODE   READINESS GATES
bish-web-pod   1/1     Running   0          47s   10.244.0.21   desktop-control-plane   <none>           <none>
```

#### 1.2 Multi-Container Pod: Sidecar Pattern (`bish-sidecar-pod`)

Deploy a multi-container pod where the primary application container (`app-producer`) writes events to an `emptyDir` volume, and the secondary sidecar container (`sidecar-streamer`) tails and streams the logs:

```bash
kubectl apply -f manifests/02-multi-container-pod.yaml
kubectl wait --for=condition=Ready pod/bish-sidecar-pod --timeout=60s
```

**Real Command Output:**
```text
pod/bish-sidecar-pod created
pod/bish-sidecar-pod condition met
```

Stream logs from the sidecar container:
```bash
kubectl logs bish-sidecar-pod -c sidecar-streamer --tail=4
```

**Real Command Output:**
```text
[2026-09-17T16:18:00Z] Event recorded by Bishwayan service
[2026-09-17T16:18:05Z] Event recorded by Bishwayan service
[2026-09-17T16:18:10Z] Event recorded by Bishwayan service
```

---

### Task 2: ReplicaSets & Self-Healing

#### 2.1 Deploy ReplicaSet

```bash
kubectl apply -f manifests/03-replicaset.yaml
kubectl get pods -l app=bish-api -o wide
```

**Real Command Output:**
```text
replicaset.apps/bish-api-rs created
NAME                READY   STATUS              RESTARTS   AGE   IP       NODE                    NOMINATED NODE   READINESS GATES
bish-api-rs-6qjvs   0/1     ContainerCreating   0          1s    <none>   desktop-control-plane   <none>           <none>
bish-api-rs-87qcq   0/1     ContainerCreating   0          1s    <none>   desktop-control-plane   <none>           <none>
bish-api-rs-bl2kw   0/1     ContainerCreating   0          1s    <none>   desktop-control-plane   <none>           <none>
```

#### 2.2 Self-Healing Demonstration

Simulate pod failure by directly deleting active pod `bish-api-rs-6qjvs`:
```bash
kubectl delete pod bish-api-rs-6qjvs
```

**Real Command Output:**
```text
pod "bish-api-rs-6qjvs" deleted from default namespace
```

Check immediate recreation by the ReplicaSet controller:
```bash
kubectl get pods -l app=bish-api
```

**Real Command Output:**
```text
NAME                READY   STATUS    RESTARTS   AGE
bish-api-rs-87qcq   1/1     Running   0          8s
bish-api-rs-bl2kw   1/1     Running   0          8s
bish-api-rs-gpjbj   1/1     Running   0          7s
```
*Verification: Pod `bish-api-rs-gpjbj` was automatically created to maintain the desired count of 3.*

#### 2.3 Horizontal Scaling

Scale up to 5 replicas:
```bash
kubectl scale rs/bish-api-rs --replicas=5
kubectl get rs bish-api-rs
```

**Real Command Output:**
```text
replicaset.apps/bish-api-rs scaled
NAME          DESIRED   CURRENT   READY   AGE
bish-api-rs   5         5         3       8s
```

Scale down to 2 replicas:
```bash
kubectl scale rs/bish-api-rs --replicas=2
kubectl get rs bish-api-rs
```

**Real Command Output:**
```text
replicaset.apps/bish-api-rs scaled
NAME          DESIRED   CURRENT   READY   AGE
bish-api-rs   2         2         2       10s
```

---

### Task 3: Deployments & Release Strategies

#### 3.1 Rolling Update Strategy

Deploy application using the `RollingUpdate` strategy:
```bash
kubectl apply -f manifests/04-deployment-rolling.yaml
kubectl rollout status deployment/bish-web-deployment
```

**Real Command Output:**
```text
deployment.apps/bish-web-deployment created
Waiting for deployment "bish-web-deployment" rollout to finish: 0 of 4 updated replicas are available...
Waiting for deployment "bish-web-deployment" rollout to finish: 1 of 4 updated replicas are available...
Waiting for deployment "bish-web-deployment" rollout to finish: 2 of 4 updated replicas are available...
Waiting for deployment "bish-web-deployment" rollout to finish: 3 of 4 updated replicas are available...
deployment "bish-web-deployment" successfully rolled out
```

Verify deployment replicas:
```bash
kubectl get deployment bish-web-deployment
kubectl get pods -l app=bish-web
```

**Real Command Output:**
```text
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
bish-web-deployment   4/4     4            4           18s

NAME                                   READY   STATUS    RESTARTS   AGE
bish-web-deployment-58bc65749c-64gfb   1/1     Running   0          18s
bish-web-deployment-58bc65749c-6pkm5   1/1     Running   0          18s
bish-web-deployment-58bc65749c-pfcjj   1/1     Running   0          18s
bish-web-deployment-58bc65749c-v4w8k   1/1     Running   0          18s
```

#### 3.2 Executing a Rolling Image Upgrade

Update container image from `nginx:1.24-alpine` to `nginx:1.25-alpine`:
```bash
kubectl set image deployment/bish-web-deployment web=nginx:1.25-alpine --record
kubectl rollout status deployment/bish-web-deployment
```

**Real Command Output:**
```text
deployment.apps/bish-web-deployment image updated
Waiting for deployment "bish-web-deployment" rollout to finish: 1 out of 4 new replicas have been updated...
Waiting for deployment "bish-web-deployment" rollout to finish: 2 out of 4 new replicas have been updated...
Waiting for deployment "bish-web-deployment" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "bish-web-deployment" rollout to finish: 1 old replicas are pending termination...
deployment "bish-web-deployment" successfully rolled out
```

#### 3.3 Rollout History & Rollback Execution

Inspect revision history:
```bash
kubectl rollout history deployment/bish-web-deployment
```

**Real Command Output:**
```text
deployment.apps/bish-web-deployment 
REVISION  CHANGE-CAUSE
1         <none>
2         kubectl.exe set image deployment/bish-web-deployment web=nginx:1.25-alpine --record=true
```

Roll back to Revision 1:
```bash
kubectl rollout undo deployment/bish-web-deployment
kubectl rollout status deployment/bish-web-deployment
```

**Real Command Output:**
```text
deployment.apps/bish-web-deployment rolled back
Waiting for deployment "bish-web-deployment" rollout to finish: 1 out of 4 new replicas have been updated...
Waiting for deployment "bish-web-deployment" rollout to finish: 2 out of 4 new replicas have been updated...
Waiting for deployment "bish-web-deployment" rollout to finish: 3 out of 4 new replicas have been updated...
Waiting for deployment "bish-web-deployment" rollout to finish: 1 old replicas are pending termination...
deployment "bish-web-deployment" successfully rolled out
```

#### 3.4 Recreate Strategy Verification

Deploy the background worker using the `Recreate` deployment strategy:
```bash
kubectl apply -f manifests/05-deployment-recreate.yaml
kubectl rollout status deployment/bish-stateful-deployment
kubectl get deployment bish-stateful-deployment
```

**Real Command Output:**
```text
deployment.apps/bish-stateful-deployment created
Waiting for deployment "bish-stateful-deployment" rollout to finish: 0 of 2 updated replicas are available...
Waiting for deployment "bish-stateful-deployment" rollout to finish: 1 of 2 updated replicas are available...
deployment "bish-stateful-deployment" successfully rolled out
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
bish-stateful-deployment   2/2     2            2           2s
```

---

## Deployment Strategy Comparison Matrix

| Strategy | Downtime? | Resource Overhead | Use Case |
|---|---|---|---|
| **RollingUpdate** | ❌ Zero downtime | Medium (`maxSurge` requires temporary additional pods) | Stateless web applications, APIs, production defaults |
| **Recreate** | ⚠️ Brief downtime | Lowest (Terminates all existing pods before starting new ones) | Applications incompatible with running two versions simultaneously, single-attach storage |
| **Blue-Green** | ❌ Zero downtime | High (Requires doubling full environment capacity) | Instantaneous switchover and instant rollback capabilities |
| **Canary** | ❌ Zero downtime | Low | Validating new releases on a small percentage of live user traffic |

---

## Interview Questions & Answers

**Q1: Why should you rarely manage naked Pods directly in production?**  
**A:** Naked pods are ephemeral and unmanaged. If a worker node crashes or reboots, Kubernetes does not automatically reschedule or recreate individual pods. Workload controllers (Deployments, StatefulSets, DaemonSets) maintain desired state through reconciliation loops and provide self-healing, scaling, and rolling upgrades.

**Q2: What is the exact difference between `matchLabels` and `template.metadata.labels` in a Deployment manifest?**  
**A:** `spec.selector.matchLabels` defines which Pods the controller will select and manage. `spec.template.metadata.labels` defines the labels assigned to new Pods created from that template. In Kubernetes `apps/v1`, the selector's `matchLabels` must match the template's labels; otherwise, the manifest will be rejected by the API server.

**Q3: How do `maxSurge` and `maxUnavailable` control a rolling update?**  
**A:** `maxSurge` specifies the maximum number of Pods that can be created above the desired replica count during an update (e.g., `maxSurge: 1` on 4 replicas allows up to 5 pods during rollout). `maxUnavailable` specifies the maximum number of Pods that can be unavailable during the update (e.g., `maxUnavailable: 0` guarantees that all 4 replicas remain running until new ones pass readiness probes).
