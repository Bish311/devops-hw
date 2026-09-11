BISHWAYAN CHATTERJEE -- 24BCS10200

# Docker Multi-Stage Build & Application Deployment

## Student Metadata
- **Name:** Bish
- **Enrollment Number:** Bx001

---

## Task 1 & Task 2: Multi-Stage Build Documentation

### Purpose of Multi-Stage Builds
Multi-stage builds allow developers to define multiple `FROM` instructions in a single `Dockerfile`. Each `FROM` represents a distinct build stage. Build tools, package managers, development dependencies, and compilers exist only in early stages (e.g., `builder` / `compiler`). The final production stage selectively copies only the minimal compiled artifacts or production dependencies from previous stages via `COPY --from=<stage>`.

**Benefits:**
- **Drastically Reduced Image Size:** Eliminates build-time dependencies, package caches, compilers, and intermediate layers from final images.
- **Enhanced Security:** Build tools (gcc, javac, npm dev-tools) are excluded from the attack surface of the production container.
- **Simplified CI/CD:** A single `Dockerfile` contains both build and deployment instructions without requiring external build scripts.

---

### Verification: Running Container on Port 8080

#### Build & Run Commands
```bash
cd multi-stage-app
docker build -t bishwayan/multistage-main:1.0 .
docker run -d --name multistage-main-container -p 8080:8080 bishwayan/multistage-main:1.0
```

#### Application Output Verification (`curl http://localhost:8080`)
```text
$ curl -i http://localhost:8080
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html; charset=utf-8
Content-Length: 51
Date: Fri, 11 Sep 2026 12:00:00 GMT
Connection: keep-alive

<h1>Hello World from Docker multi-stage build</h1>
```

#### Container Process Table (`docker ps`)
```text
$ docker ps --filter "name=multistage-main-container"
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS          PORTS                                         NAMES
1c942123d736   bishwayan/multistage-main:1.0   "docker-entrypoint.s…"   30 seconds ago   Up 29 seconds   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp   multistage-main-container
```

---

## Task 3: Docker Application Deployment (3 Distinct Stacks)

We have containerized and deployed 3 independent microservices:

### 1. Node.js Application
- **Directory:** `deployed-apps/nodejs/`
- **Internal Port:** 3000
- **Host Port:** 3002
- **Verification Command:** `curl http://localhost:3002`
- **Output:** `<h1>Node.js Microservice Active</h1>`

### 2. Python Application
- **Directory:** `deployed-apps/python/`
- **Internal Port:** 5000
- **Host Port:** 5002
- **Verification Command:** `curl http://localhost:5002`
- **Output:** `<h1>Python Microservice Active</h1>`

### 3. Java Application (Compiled Multi-Stage)
- **Directory:** `deployed-apps/java/`
- **Build Architecture:** Stage 1 JDK 17 compiles `Server.java` \(\rightarrow\) Stage 2 JRE 17 runs bytecode.
- **Internal Port:** 8000
- **Host Port:** 8002
- **Verification Command:** `curl http://localhost:8002`
- **Output:** `<h1>Java Microservice Active</h1>`

---

### Process Verification Across All Deployed Services

```text
$ docker ps --filter "name=multistage-main-container" --filter "name=deploy-"
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS          PORTS                                         NAMES
b03655666254   bishwayan/deploy-java:1.0       "/__cacert_entrypoin…"   4 seconds ago    Up 3 seconds    0.0.0.0:8002->8000/tcp, [::]:8002->8000/tcp   deploy-java-container
1dc79f01add4   bishwayan/deploy-python:1.0     "python server.py"       26 seconds ago   Up 25 seconds   0.0.0.0:5002->5000/tcp, [::]:5002->5000/tcp   deploy-python-container
c4f2a511d444   bishwayan/deploy-node:1.0       "docker-entrypoint.s…"   28 seconds ago   Up 27 seconds   0.0.0.0:3002->3000/tcp, [::]:3002->3000/tcp   deploy-node-container
1c942123d736   bishwayan/multistage-main:1.0   "docker-entrypoint.s…"   30 seconds ago   Up 29 seconds   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp   multistage-main-container
```
