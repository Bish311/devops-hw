BISHWAYAN CHATTERJEE -- 24BCS10200

# Docker Fundamentals: Hello World Applications

This module provides containerized implementations for 6 distinct web applications running across different runtimes and web servers.

---

## Directory Architecture

```text
05-docker-fundamental/
├── Apache-app/
│   ├── Dockerfile
│   └── index.html
├── React-app/
│   ├── Dockerfile
│   └── index.html
├── java-app/
│   ├── Dockerfile
│   └── Server.java
├── nginx-app/
│   ├── Dockerfile
│   └── index.html
├── nodejs-app/
│   ├── Dockerfile
│   ├── package.json
│   └── server.js
├── python-app/
│   ├── Dockerfile
│   └── server.py
├── build_and_run_all.sh
└── README.md
```

---

## Application Specifications & Port Allocations

| Application | Technology Stack | Internal Port | Host Port | Output Confirmation |
|---|---|---|---|---|
| **nodejs-app** | Express.js on Node 20 Alpine | 3000 | 3001 | `Hello World from Node.js!` |
| **python-app** | Python 3.11 Built-in HTTP Server | 5000 | 5001 | `Hello World from Python!` |
| **java-app** | Java 17 Temurin HttpServer | 8000 | 8001 | `Hello World from Java!` |
| **Apache-app** | Apache HTTP Server 2.4 Alpine | 80 | 8081 | `Hello World from Apache Web Server!` |
| **React-app** | React 18 SPA served via Nginx | 80 | 8082 | `Hello World from React!` |
| **nginx-app** | Nginx Web Server Alpine | 80 | 8083 | `Hello World from Nginx!` |

---

## Individual Build and Run Instructions

### 1. Node.js Application
```bash
cd nodejs-app
docker build -t bishwayan/nodejs-app:1.0 .
docker run -d --name nodejs-app-container -p 3001:3000 bishwayan/nodejs-app:1.0
curl http://localhost:3001
```

### 2. Python Application
```bash
cd python-app
docker build -t bishwayan/python-app:1.0 .
docker run -d --name python-app-container -p 5001:5000 bishwayan/python-app:1.0
curl http://localhost:5001
```

### 3. Java Application
```bash
cd java-app
docker build -t bishwayan/java-app:1.0 .
docker run -d --name java-app-container -p 8001:8000 bishwayan/java-app:1.0
curl http://localhost:8001
```

### 4. Apache Web Server
```bash
cd Apache-app
docker build -t bishwayan/apache-app:1.0 .
docker run -d --name apache-app-container -p 8081:80 bishwayan/apache-app:1.0
curl http://localhost:8081
```

### 5. React Application
```bash
cd React-app
docker build -t bishwayan/react-app:1.0 .
docker run -d --name react-app-container -p 8082:80 bishwayan/react-app:1.0
curl http://localhost:8082
```

### 6. Nginx Web Server
```bash
cd nginx-app
docker build -t bishwayan/nginx-app:1.0 .
docker run -d --name nginx-app-container -p 8083:80 bishwayan/nginx-app:1.0
curl http://localhost:8083
```

---

## Verified Execution Output (Git Bash Run)

### Web Endpoint Confirmations (`curl`)
```text
Node.js (3001):
Hello World from Node.js!

Python  (5001):
Hello World from Python!

Java    (8001):
Hello World from Java!

Apache  (8081):
Hello World from Apache Web Server!

React   (8082):
Hello World from React!

Nginx   (8083):
Hello World from Nginx!
```

### Running Containers Process Inspection (`docker ps`)
```text
CONTAINER ID   IMAGE                      COMMAND                  CREATED              STATUS              PORTS                                         NAMES
d0ab1f972e56   bishwayan/nginx-app:1.0    "/docker-entrypoint.…"   4 seconds ago        Up 3 seconds        0.0.0.0:8083->80/tcp, [::]:8083->80/tcp       nginx-app-container
e58e90389ad2   bishwayan/react-app:1.0    "/docker-entrypoint.…"   5 seconds ago        Up 5 seconds        0.0.0.0:8082->80/tcp, [::]:8082->80/tcp       react-app-container
8dcfcc54aa59   bishwayan/apache-app:1.0   "httpd-foreground"       18 seconds ago       Up 17 seconds       0.0.0.0:8081->80/tcp, [::]:8081->80/tcp       apache-app-container
ae300f9c05a8   bishwayan/java-app:1.0     "/__cacert_entrypoin…"   25 seconds ago       Up 25 seconds       0.0.0.0:8001->8000/tcp, [::]:8001->8000/tcp   java-app-container
ada864507d1c   bishwayan/python-app:1.0   "python server.py"       About a minute ago   Up About a minute   0.0.0.0:5001->5000/tcp, [::]:5001->5000/tcp   python-app-container
050a29590c7e   bishwayan/nodejs-app:1.0   "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:3001->3000/tcp, [::]:3001->3000/tcp   nodejs-app-container
```
