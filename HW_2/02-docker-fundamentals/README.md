BISHWAYAN CHATTERJEE -- 24BCS10200

# Docker Fundamentals: Architecture, Container Lifecycle & Orchestration

This module provides a production-grade implementation of container engineering: understanding the Docker engine architecture, authoring secure non-root Dockerfiles with layer caching, applying kernel cgroup resource constraints (CPU quotas and memory caps), and orchestrating multi-tier microservice stacks with Docker Compose.

---

## Architecture Overview

```text
  +-------------------------------------------------------------+
  |                        Docker Client                        |
  |             (docker CLI / docker compose CLI)               |
  +-------------------------------------------------------------+
                                 |  UNIX Socket / REST API
                                 v
  +-------------------------------------------------------------+
  |                        Docker Daemon                        |
  |                        (dockerd)                            |
  +-------------------------------------------------------------+
                                 |  gRPC
                                 v
  +-------------------------------------------------------------+
  |                         containerd                          |
  |               (Container lifecycle management)              |
  +-------------------------------------------------------------+
                                 |
                                 v
  +-------------------------------------------------------------+
  |                           runc                              |
  |         (OCI runtime creating cgroups & namespaces)         |
  +-------------------------------------------------------------+
         |                       |                       |
         v                       v                       v
    [ Frontend ]            [ Backend ]              [ Cache ]
    Nginx Alpine          Node.js (bish)           Redis Alpine
```

---

## Directory Contents

```text
02-docker-fundamentals/
├── app/
│   ├── Dockerfile             # Production-hardened multi-layer Dockerfile (non-root bish)
│   ├── package.json           # Node.js service descriptor
│   └── server.js              # Express microservice with health & metadata endpoints
├── docker-compose.yml         # 3-tier microservice stack definition
├── docker_operations.sh       # Comprehensive container automation script
├── nginx.conf                 # Reverse proxy configuration for frontend gateway
└── README.md                  # Complete technical documentation & live verified outputs
```

---

## Live Execution & Verified Outputs

### Task 1: Container Lifecycle Management & Resource Constraints

#### 1.1 Building the Production Image

Build the container image using the optimized Dockerfile:

```bash
docker build -t bishwayan/microservice:1.0 ./app
```

**Real Command Output:**
```text
#6 [1/6] FROM docker.io/library/node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f609372293
#6 CACHED
#5 [internal] load build context
#5 transferring context: 1.40kB done
#7 [2/6] WORKDIR /usr/src/app
#8 [3/6] COPY package*.json ./
#9 [4/6] RUN npm install --only=production --no-audit --no-fund && npm cache clean --force
#9 added 68 packages in 2s
#10 [5/6] COPY server.js ./
#11 [6/6] RUN addgroup -g 1001 -S bishgroup && adduser -u 1001 -S bish -G bishgroup && chown -R bish:bishgroup /usr/src/app
#12 exporting to image
#12 naming to docker.io/bishwayan/microservice:1.0 done
#12 unpacking to docker.io/bishwayan/microservice:1.0 done
```

Verify the image size:
```bash
docker images bishwayan/microservice:1.0
```

**Real Command Output:**
```text
IMAGE                        ID             DISK USAGE   CONTENT SIZE   EXTRA
bishwayan/microservice:1.0   7480b3f6584a        204MB         49.8MB        
```

#### 1.2 Running with Resource Constraints

Run the container detached, binding host port 3001 to container port 3000, constraining resources to 0.5 CPU cores and 128MB RAM:

```bash
docker run -d \
  --name bish-standalone-api \
  -p 3001:3000 \
  --cpus="0.5" \
  --memory="128m" \
  --restart="unless-stopped" \
  bishwayan/microservice:1.0
```

**Real Command Output:**
```text
c54fd28c2878b63b35bba8e1d49503fb2ee14dfc20da697b351f6122d6ec1dbf
```

Confirm container running state and port mapping:
```bash
docker ps --filter "name=bish-standalone-api"
```

**Real Command Output:**
```text
CONTAINER ID   IMAGE                        COMMAND                  CREATED        STATUS                                     PORTS                                         NAMES
c54fd28c2878   bishwayan/microservice:1.0   "docker-entrypoint.s…"   1 second ago   Up Less than a second (health: starting)   0.0.0.0:3001->3000/tcp, [::]:3001->3000/tcp   bish-standalone-api
```

#### 1.3 Verifying Resource Limits & Security Context

Verify that the configured memory limit and CPU quota are enforced by cgroups:

```bash
docker inspect bish-standalone-api --format 'Memory Limit: {{.HostConfig.Memory}} bytes, NanoCPUs: {{.HostConfig.NanoCpus}}'
```

**Real Command Output:**
```text
Memory Limit: 134217728 bytes, NanoCPUs: 500000000
```

Verify that the process executes under the unprivileged `bish` account (UID 1001) rather than root:

```bash
docker exec bish-standalone-api id
docker exec bish-standalone-api whoami
```

**Real Command Output:**
```text
uid=1001(bish) gid=1001(bishgroup) groups=1001(bishgroup)
bish
```

#### 1.4 Application Verification via HTTP

Query the root endpoint:
```bash
curl -s http://localhost:3001/
```

**Real Command Output:**
```json
{"status":"online","message":"Hello from containerized service engineered by Bishwayan!","environment":"production","timestamp":"2026-09-17T16:21:40.435Z","totalRequests":1}
```

Query the internal health check endpoint:
```bash
curl -s http://localhost:3001/health
```

**Real Command Output:**
```json
{"status":"healthy","uptimeSeconds":5,"memoryUsageMB":55}
```

---

### Task 2: Production Dockerfile Engineering

### Key Instructions & Best Practices Implemented

| Instruction | Implementation Purpose | Production Justification |
|---|---|---|
| `FROM node:20-alpine` | Minimal base image | Reduces attack surface and cuts download overhead compared to standard 1GB node images |
| `WORKDIR /usr/src/app` | Set operational directory | Avoids writing files to root filesystem |
| `COPY package*.json ./` | Dependency definition cache | Caches `npm install` layer so changes in `server.js` do not re-trigger package installation |
| `RUN adduser -u 1001 -S bish` | Non-root security user | Enforces container security; prevents container breakouts from gaining host root access |
| `USER bish` | Switch active execution user | Drops root privileges before application startup |
| `HEALTHCHECK` | Automated daemon probe | Allows Docker Engine and orchestrators to detect deadlocks or hung processes |
| `CMD ["node", "server.js"]` | Exec format command | Receives POSIX signals (`SIGTERM`, `SIGINT`) properly for graceful container shutdown |

---

### Task 3: Multi-Tier Microservice Orchestration (Docker Compose)

#### 3.1 Starting the Multi-Tier Stack

```bash
docker compose up -d
```

**Real Command Output:**
```text
 ✔ Network 02-docker-fundamentals_bish-net             Created
 ✔ Volume "02-docker-fundamentals_bish-cache-data"     Created
 ✔ Container bish-cache                                Started
 ✔ Container bish-backend                              Started
 ✔ Container bish-frontend                             Started
```

Inspect the orchestrated services:
```bash
docker compose ps
```

**Real Command Output:**
```text
NAME            IMAGE                        COMMAND                  SERVICE    CREATED        STATUS                                     PORTS
bish-backend    bishwayan/microservice:1.0   "docker-entrypoint.s…"   backend    1 second ago   Up Less than a second (health: starting)   3000/tcp
bish-cache      redis:7.2-alpine             "docker-entrypoint.s…"   cache      1 second ago   Up Less than a second                      6379/tcp
bish-frontend   nginx:1.25-alpine            "/docker-entrypoint.…"   frontend   1 second ago   Up Less than a second                      0.0.0.0:8080->80/tcp, [::]:8080->80/tcp
```

#### 3.2 End-to-End Verification through Frontend Gateway

Send an HTTP request to host port 8080:
```bash
curl -s http://localhost:8080/
```

**Real Command Output:**
```json
{"status":"online","message":"Hello from containerized service engineered by Bishwayan!","environment":"production","timestamp":"2026-09-17T16:21:51.527Z","totalRequests":1}
```

#### 3.3 Clean Stack Teardown

```bash
docker compose down -v
```

**Real Command Output:**
```text
 ✔ Container bish-frontend                             Removed
 ✔ Container bish-backend                              Removed
 ✔ Container bish-cache                                Removed
 ✔ Network 02-docker-fundamentals_bish-net             Removed
 ✔ Volume 02-docker-fundamentals_bish-cache-data       Removed
```

---

## Interview Questions & Answers

**Q1: What is the difference between `CMD` and `ENTRYPOINT` in a Dockerfile?**  
**A:** `ENTRYPOINT` defines the executable that should always run when the container starts. `CMD` provides default arguments or default commands. If both are specified in exec form (`["executable", "param1"]`), `CMD` parameters are appended as arguments to `ENTRYPOINT`. Users can override `CMD` from the CLI (`docker run <image> <override>`), while `ENTRYPOINT` requires `--entrypoint` to be altered.

**Q2: Why should application processes run as an unprivileged user inside Docker containers?**  
**A:** By default, containers run as UID 0 (`root`). While namespaces isolate the container, container root shares the exact same user ID as the host kernel root. In the event of a container breakout vulnerability, a root process inside the container can compromise the host OS. Running as a dedicated user (like `bish`, UID 1001) mitigates this vector.

**Q3: How does Docker layer caching work and how do you optimize it?**  
**A:** Docker builds images sequentially. Each instruction creates a read-only layer. If an instruction and its build context haven't changed since the previous build, Docker reuses the cached layer. To optimize, place instructions that change least frequently at the top (e.g., system package installs, `package.json`) and frequently changing source code files near the bottom.
