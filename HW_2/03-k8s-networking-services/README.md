BISHWAYAN CHATTERJEE -- 24BCS10200

# Kubernetes Networking & Services: The Complete Guide & Lab Outputs

This module provides a comprehensive implementation of Kubernetes networking, service abstraction, layer-7 ingress routing, and decoupled configuration patterns, synthesized directly from class curriculum sessions (Session 11: Kubernetes Services and Session 12: Ingress, ConfigMaps & Secrets).

---

## 1. Why Do We Need Kubernetes Services?

In Kubernetes, Pods are ephemeral:
- When a Pod crashes or a Node reboots, the replacement Pod receives a completely new, unpredictable IP address.
- Frontends cannot hardcode backend Pod IPs.
- **Kubernetes Service** provides a static, durable IP and DNS hostname that remains constant across the lifetime of the application, load balancing incoming traffic across all healthy replica Pods matching its label selector.

---

## 2. Port Architecture & Demystification

```text
 Client (Browser / External Traffic)
             |
             | Hits Node IP on:
             v
      [ nodePort: 30080 ]          <- Port exposed on every Worker Node machine (30000-32767)
             |
             | Forwarded to:
             v
      [ port: 80 ]                 <- Cluster-internal port on the Service virtual IP
             |
             | Forwarded by kube-proxy to:
             v
      [ targetPort: 80 ]           <- Port backend container listens on inside the Pod
             |
             v
      [ containerPort: 80 ]        <- Informational metadata inside Pod specification
```

| Port Name | Location | Who Connects to It? | Configurable Range |
|---|---|---|---|
| **`nodePort`** | Host Node interface | External clients via Node's IP | `30000–32767` |
| **`port`** | Service object (Virtual ClusterIP) | Internal cluster clients & Ingress | Any valid port (`1–65535`) |
| **`targetPort`** | Target Pod Container | The Kubernetes Service / Proxy | Port opened in application code |
| **`containerPort`** | Pod Container spec | Purely informational metadata | Same as application port |

---

## 3. Master Service Types Comparison

| Criteria | 1. ClusterIP | 2. NodePort | 3. LoadBalancer | 4. Headless (`None`) | 5. ExternalName |
|---|---|---|---|---|---|
| **Default Type** | ✅ Yes | ❌ No | ❌ No | ❌ No (`clusterIP: None`) | ❌ No |
| **ClusterIP Assigned** | ✅ Virtual IP | ✅ Virtual IP | ✅ Virtual IP | ❌ No | ❌ No |
| **External Access** | ❌ Internal only | ✅ Via NodeIP:NodePort | ✅ Via Public Cloud IP | ❌ Direct Pod-to-Pod | ❌ Redirects outbound |
| **Port Range** | `1–65535` | `30000–32767` | `80, 443`, etc. | Any valid port | Targets external port |
| **DNS Record** | Single `A` record $\rightarrow$ ClusterIP | Single `A` record $\rightarrow$ ClusterIP | Single `A` record $\rightarrow$ ClusterIP | Multiple `A` records (1 per Pod) | `CNAME` record $\rightarrow$ External FQDN |
| **Endpoints Created** | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes (Lists Pod IPs) | ❌ No |
| **Primary Use Case** | Microservice-to-microservice | Dev, node-level routing | Internet web traffic | StatefulSets (DBs, Kafka) | Access external cloud DBs |

---

## 4. Directory Contents

```text
03-k8s-networking-services/
├── manifests/
│   ├── 01-clusterip-service.yaml       # ClusterIP Service, 3-replica Backend & DNS test client
│   ├── 02-nodeport-service.yaml        # NodePort Service (Port 30080) & Frontend Deployment
│   ├── 03-loadbalancer-service.yaml    # Cloud LoadBalancer specification
│   ├── 04-headless-service.yaml        # Headless Service (clusterIP: None) & StatefulSet
│   ├── 05-externalname-service.yaml    # ExternalName Service mapping to external FQDN
│   ├── 06-configmap.yaml               # Environment variable decoupled configuration
│   ├── 07-secret.yaml                  # Base64 encrypted credentials Secret
│   └── 08-ingress.yaml                 # Layer 7 Ingress routing rules
├── deploy_networking.sh                # End-to-end deployment & validation script
├── cleanup.sh                          # Clean teardown script
└── README.md                           # Documentation, live execution logs & troubleshooting
```

---

## 5. Live Execution & Verified Outputs

### 5.1 Configuration & Secrets Deployment (Session 12)

Apply ConfigMap and Secret:
```bash
kubectl apply -f manifests/06-configmap.yaml
kubectl apply -f manifests/07-secret.yaml
```

**Real Command Output:**
```text
configmap/bish-app-config created
secret/bish-app-secret created
```

Verify ConfigMap and Secret storage:
```bash
kubectl get configmap bish-app-config
kubectl get secret bish-app-secret
```

**Real Command Output:**
```text
NAME              DATA   AGE
bish-app-config   5      0s
NAME              TYPE     DATA   AGE
bish-app-secret   Opaque   3      0s
```

---

### 5.2 Type 1: ClusterIP Service & DNS Resolution

Deploy the backend deployment, ClusterIP service, and diagnostic client pod:
```bash
kubectl apply -f manifests/01-clusterip-service.yaml
kubectl rollout status deployment/bish-backend-deployment
```

**Real Command Output:**
```text
deployment.apps/bish-backend-deployment created
service/bish-backend-svc created
pod/bish-dns-client created
Waiting for deployment "bish-backend-deployment" rollout to finish: 0 of 3 updated replicas are available...
Waiting for deployment "bish-backend-deployment" rollout to finish: 1 of 3 updated replicas are available...
Waiting for deployment "bish-backend-deployment" rollout to finish: 2 of 3 updated replicas are available...
deployment "bish-backend-deployment" successfully rolled out
pod/bish-dns-client condition met
```

Verify the allocated ClusterIP:
```bash
kubectl get svc bish-backend-svc -o wide
```

**Real Command Output:**
```text
NAME               TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE   SELECTOR
bish-backend-svc   ClusterIP   10.96.68.158   <none>        80/TCP    8s    app=bish-backend
```

Inspect Endpoints to verify the service selected the 3 backend pods:
```bash
kubectl get endpoints bish-backend-svc
```

**Real Command Output:**
```text
NAME               ENDPOINTS                                      AGE
bish-backend-svc   10.244.0.27:80,10.244.0.28:80,10.244.0.29:80   8s
```

Perform DNS resolution from inside the `bish-dns-client` pod:
```bash
kubectl exec bish-dns-client -- nslookup bish-backend-svc
```

**Real Command Output:**
```text
Server:		10.96.0.10
Address:	10.96.0.10:53

Name:	bish-backend-svc.default.svc.cluster.local
Address: 10.96.68.158
```

Send internal HTTP traffic through the ClusterIP service DNS name:
```bash
kubectl exec bish-dns-client -- curl -s -I http://bish-backend-svc/
```

**Real Command Output:**
```text
HTTP/1.1 200 OK
Server: nginx/1.25.5
Date: Thu, 17 Sep 2026 16:19:49 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Tue, 16 Apr 2024 15:47:06 GMT
Connection: keep-alive
ETag: "661e9d7a-267"
Accept-Ranges: bytes
```

---

### 5.3 Type 2 & Type 3: NodePort & LoadBalancer Services

Deploy the NodePort and LoadBalancer services:
```bash
kubectl apply -f manifests/02-nodeport-service.yaml
kubectl apply -f manifests/03-loadbalancer-service.yaml
kubectl rollout status deployment/bish-frontend-deployment
kubectl get svc bish-frontend-nodeport bish-gateway-lb
```

**Real Command Output:**
```text
deployment.apps/bish-frontend-deployment created
service/bish-frontend-nodeport created
service/bish-gateway-lb created
Waiting for deployment "bish-frontend-deployment" rollout to finish: 0 of 2 updated replicas are available...
Waiting for deployment "bish-frontend-deployment" rollout to finish: 1 of 2 updated replicas are available...
deployment "bish-frontend-deployment" successfully rolled out
NAME                     TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
bish-frontend-nodeport   NodePort       10.96.20.129   <none>        80:30080/TCP   1s
bish-gateway-lb          LoadBalancer   10.96.206.60   172.20.0.5    80:31883/TCP   1s
```

---

### 5.4 Type 4: Headless Service (`clusterIP: None`)

Deploy the headless service and its corresponding StatefulSet:
```bash
kubectl apply -f manifests/04-headless-service.yaml
kubectl rollout status statefulset/bish-db
kubectl get endpoints bish-db-headless
```

**Real Command Output:**
```text
service/bish-db-headless created
statefulset.apps/bish-db created
Waiting for 2 pods to be ready...
Waiting for 1 pods to be ready...
partitioned roll out complete: 2 new pods have been updated...
NAME               ENDPOINTS                           AGE
bish-db-headless   10.244.0.33:5432,10.244.0.34:5432   1s
```
*Verification: The Headless service endpoints directly list the two StatefulSet Pod IPs (`10.244.0.33:5432` and `10.244.0.34:5432`), allowing direct peer-to-peer routing without virtual IP proxying.*

---

### 5.5 Type 5: ExternalName Service

Deploy the ExternalName service:
```bash
kubectl apply -f manifests/05-externalname-service.yaml
kubectl get svc bish-external-db
```

**Real Command Output:**
```text
service/bish-external-db created
NAME               TYPE           CLUSTER-IP   EXTERNAL-IP               PORT(S)   AGE
bish-external-db   ExternalName   <none>       db.internal.example.com   <none>    1s
```

---

### 5.6 Layer-7 Ingress Routing (Session 12)

Apply the Ingress rules:
```bash
kubectl apply -f manifests/08-ingress.yaml
kubectl get ingress bish-suite-ingress
```

**Real Command Output:**
```text
ingress.networking.k8s.io/bish-suite-ingress created
NAME                 CLASS   HOSTS              ADDRESS   PORTS   AGE
bish-suite-ingress   nginx   bish-suite.local             80      0s
```

---

## 6. Fully Qualified Domain Name (FQDN) Structure

Kubernetes internal DNS names follow a standardized hierarchical convention:

$$\text{\textbf{<service-name>}}.\text{\textbf{<namespace>}}.\text{\textbf{svc}}.\text{\textbf{cluster.local}}$$

Example:
- Cross-namespace query from `production` to `default`:
  `curl http://bish-backend-svc.default.svc.cluster.local`
- Same-namespace query:
  `curl http://bish-backend-svc` (resolves automatically via search domains in `/etc/resolv.conf`).

---

## 7. Troubleshooting Cheat Sheet

1. **Service has no Endpoints (`<none>`):**
   * Check label match: Compare `service.spec.selector` with `deployment.spec.template.metadata.labels`.
   * Check pod readiness: If pods are failing readiness probes, they are removed from Endpoints.
2. **Connection Refused:**
   * Verify `targetPort` in the Service matches the port your application container is listening on.
3. **External Client Cannot Connect to NodePort:**
   * Verify Node firewall/Security Group allows ingress traffic on the port (`30080`).

---

## 8. Interview Questions & Answers

**Q1: How does traffic actually reach a Pod from a ClusterIP Service if ClusterIP is not a real network interface?**  
**A:** A ClusterIP is a virtual IP that does not belong to any physical or virtual network interface. Instead, `kube-proxy` runs on every node and watches the API server for Service and Endpoint creation. It writes rules into the Linux kernel using `iptables` or `IPVS`. When a packet is sent to the ClusterIP, the kernel intercepts it and performs Destination Network Address Translation (DNAT), rewriting the target IP to one of the matching Pod IPs in the Endpoints list.

**Q2: What is the key difference between a regular Service and a Headless Service?**  
**A:** A standard Service allocates a single virtual ClusterIP and relies on `kube-proxy` to distribute requests. A Headless Service (`clusterIP: None`) does not allocate an IP; instead, CoreDNS returns the `A` records of all backing Pods directly. This enables direct peer-to-peer communication and deterministic pod addressing required by distributed databases like Cassandra, MongoDB, or Kafka.

**Q3: When should you use Ingress instead of NodePort or LoadBalancer?**  
**A:** LoadBalancer provisions an external cloud load balancer per Service, which quickly becomes expensive and difficult to manage. NodePort exposes non-standard ports (30000-32767) requiring manual routing. Ingress acts as a single Layer-7 entry point that provides SSL/TLS termination, name-based virtual hosting, and path-based routing (`/` to frontend, `/api` to backend) behind a single IP address and standard HTTP/HTTPS ports (80/443).
