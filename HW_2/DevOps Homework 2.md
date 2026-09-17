# Kubernetes Pods, ReplicaSets & Deployments

**Kubernetes Core Objects Homework Tasks**

## Task 1: Pod Lifecycle & Multi-Container Pods
* Understand the Pod lifecycle states (`Pending`, `Running`, `Succeeded`, `Failed`, `Unknown`).
* Create a single-container Pod running an Nginx web server with configured resource requests, limits, and HTTP liveness probes.
* Create a multi-container Pod demonstrating the Sidecar pattern (a main application container writing log entries to a shared volume and a sidecar container reading and streaming those logs).
* Verify container logs and inspect pod status using `kubectl get pods`, `kubectl describe pod`, and `kubectl logs`.

## Task 2: ReplicaSets & Self-Healing
* Create a ReplicaSet manifest managing 3 pod replicas.
* Understand label selectors (`matchLabels`) and how the ReplicaSet controller maintains the desired state.
* Test self-healing by manually terminating a running pod and observing the ReplicaSet controller instantly spinning up a replacement pod.
* Scale the ReplicaSet up to 5 replicas and down to 2 replicas using both imperative commands (`kubectl scale`) and declarative manifest updates.

## Task 3: Deployments & Release Strategies
* Create a Kubernetes Deployment managing application replicas with a `RollingUpdate` strategy (`maxSurge: 1`, `maxUnavailable: 0`).
* Perform a rolling upgrade to a newer image version and track rollout progression with `kubectl rollout status`.
* Inspect rollout revision history using `kubectl rollout history`.
* Simulate an application deployment rollback to a previous stable revision using `kubectl rollout undo`.
* Compare `RollingUpdate` with the `Recreate` deployment strategy.

---

# Docker Fundamentals

**Docker Architecture & Container Operations Homework Tasks**

## Task 1: Container Lifecycle Management
* Understand the Docker client-server architecture, containerd runtime, and image layer storage.
* Practice container operations: `docker run`, `docker exec`, `docker stop`, `docker start`, `docker logs`, `docker inspect`, and `docker stats`.
* Enforce container resource constraints by assigning CPU quota limits (`--cpus`) and memory caps (`--memory`).

## Task 2: Production Dockerfile Engineering
* Create an optimized Dockerfile for an Express microservice authored by Bishwayan.
* Implement production-grade practices:
  * Minimal base image (Node Alpine).
  * Layer caching optimization by copying package descriptors before application code.
  * Dedicated non-root system user (`bish`) for security compliance.
  * Built-in `HEALTHCHECK` instruction.

## Task 3: Multi-Tier Microservice Orchestration with Docker Compose
* Define a 3-tier architecture using `docker-compose.yml`:
  * Frontend: Nginx reverse proxy serving client assets on port 8080.
  * Backend: Node.js API processing business logic on port 3000.
  * Cache/Storage: Redis caching layer with persistent volume storage.
* Configure custom bridge networks to isolate tiers.
* Verify multi-container orchestration, connectivity, and volume persistence across container restarts.

---

# Kubernetes Networking & Services

**Kubernetes Services, Ingress, ConfigMaps & Secrets Homework Tasks**

## Task 1: The 5 Kubernetes Service Types
* Understand port mapping concepts: `nodePort`, `port`, `targetPort`, and `containerPort`.
* Implement and test:
  * **ClusterIP**: Default internal service providing stable cluster-internal DNS and load balancing.
  * **NodePort**: Expose service externally across cluster nodes on high-range ports (`30000–32767`).
  * **LoadBalancer**: Integrate external cloud load balancers to route public internet traffic.
  * **Headless Service (`clusterIP: None`)**: Enable direct pod-to-pod IP resolution and discovery for stateful distributed services.
  * **ExternalName**: Map an internal service DNS query directly to an external FQDN CNAME without proxy overhead.

## Task 2: ConfigMaps & Secrets Management
* Create a ConfigMap storing non-sensitive environment variables and configuration properties.
* Create a Kubernetes Secret storing sensitive database credentials and API tokens.
* Inject configuration into application pods via environment variables (`valueFrom`) and volume mounts.
* Verify environment variables inside running application pods.

## Task 3: Layer-7 Routing with Ingress Controller
* Deploy an Nginx Ingress Controller rule routing traffic to multiple internal backend services based on HTTP request paths (`/` to frontend and `/api` to backend).
* Test path-based routing rules and verify HTTP response headers.
