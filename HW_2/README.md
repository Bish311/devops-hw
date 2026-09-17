BISHWAYAN CHATTERJEE -- 24BCS10200

# DevOps Homework 2 (HW_2)

Complete solutions, manifests, scripts, and production documentation for Homework 2 modules based on class sessions (Kubernetes Core Objects, Docker Architecture & Operations, Kubernetes Services, and Ingress/ConfigMaps/Secrets).

---

## Module Directory Index

1. **[01-k8s-pods-replicasets-deployments](./01-k8s-pods-replicasets-deployments/README.md)**
   - Pod lifecycle states, single-container Pod with resource requests/limits and liveness probes.
   - Multi-container Pod implementing the Sidecar pattern with an `emptyDir` shared volume.
   - ReplicaSet controller managing desired state, selector label matching, and pod self-healing demonstration.
   - Deployments: zero-downtime `RollingUpdate` strategy, image upgrades, rollout status, rollout history inspection, and rollback (`kubectl rollout undo`).
   - `Recreate` deployment strategy verification.
   - Automation script: `deploy_and_verify.sh`.

2. **[02-docker-fundamentals](./02-docker-fundamentals/README.md)**
   - Docker engine architecture: client, daemon, containerd, and runc.
   - Container lifecycle operations: `docker run`, `docker exec`, `docker stop`, `docker start`, `docker logs`, `docker inspect`, and `docker stats`.
   - Kernel cgroup enforcement: CPU quotas (`--cpus="0.5"`) and memory limits (`--memory="128m"`).
   - Production-hardened Dockerfile: multi-layer caching, non-root system user (`bish`), and container `HEALTHCHECK`.
   - 3-tier microservice orchestration via `docker-compose.yml`: Nginx frontend reverse proxy, Node.js microservice, and Redis cache with persistent volume storage.
   - Automation script: `docker_operations.sh`.

3. **[03-k8s-networking-services](./03-k8s-networking-services/README.md)**
   - Comprehensive analysis and implementation of all 5 Kubernetes Service types:
     - `ClusterIP`: Default internal service discovery and load balancing via CoreDNS.
     - `NodePort`: External node-level access across port `30080`.
     - `LoadBalancer`: Cloud provider integration and public IP ingress.
     - `Headless Service (`clusterIP: None`)`: Direct Pod IP resolution for stateful distributed clusters.
     - `ExternalName`: Internal DNS CNAME redirection without proxy overhead.
   - Port mapping architecture: `nodePort`, `port`, `targetPort`, and `containerPort`.
   - Decoupled configuration: `ConfigMap` (environment variables) and `Secret` (base64 credentials).
   - Layer-7 path-based routing via Nginx Ingress Controller (`/` to frontend, `/api` to backend).
   - Automation and teardown scripts: `deploy_networking.sh` and `cleanup.sh`.

---

## Summary of Deliverables & Verification

| Module | Core Scripts | Key Manifests / Source Files | Primary Deliverables |
|---|---|---|---|
| **01-k8s-pods-replicasets-deployments** | `deploy_and_verify.sh` | `01-pod.yaml`, `02-multi-container-pod.yaml`, `03-replicaset.yaml`, `04-deployment-rolling.yaml`, `05-deployment-recreate.yaml` | Workload manifests, self-healing validation, rolling update & rollback logs |
| **02-docker-fundamentals** | `docker_operations.sh` | `app/Dockerfile`, `app/server.js`, `app/package.json`, `docker-compose.yml`, `nginx.conf` | Hardened image, cgroup resource limit outputs, multi-tier Compose stack |
| **03-k8s-networking-services** | `deploy_networking.sh`, `cleanup.sh` | `01-clusterip-service.yaml`, `02-nodeport-service.yaml`, `03-loadbalancer-service.yaml`, `04-headless-service.yaml`, `05-externalname-service.yaml`, `06-configmap.yaml`, `07-secret.yaml`, `08-ingress.yaml` | 5 Service architectures, CoreDNS queries, ConfigMaps/Secrets, Ingress L7 routes |
