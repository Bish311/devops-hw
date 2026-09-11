BISHWAYAN CHATTERJEE -- 24BCS10200

# DevOps Homework 1 (HW_1)

Complete solutions, scripts, and documentation for Homework 1 modules based on class sessions.
---

## Module Directory Index

1. **[01-linux-fundamental](./01-linux-fundamental/README.md)**
   - Hard links vs Soft links (inodes, commands, interview preparation)
   - `adduser` vs `useradd`
   - `journalctl` logging
   - Linux commands cheat sheet
   - Demo script: `linux_tasks.sh`

2. **[02-shell-scripting](./02-shell-scripting/README.md)**
   - System information automation script: `system_info.sh`
   - Gathers date, hostname, user, disk usage (`df -h`), and process snapshots (`ps aux`)
   - Uses `read -p`, `mkdir`, `touch`, and output redirection (`>`)

3. **[03-networking-fundamentals](./03-networking-fundamentals/README.md)**
   - IP addressing classes and RFC 1918 private subnets
   - Command diagnostics: `ip a`, `ip route`, `ping`, `traceroute`, `ss`, `nslookup`, `curl`
   - Verification script: `network_checks.sh`

4. **[04-git-github](./04-git-github/README.md)**
   - `git commit -a -m` vs `git commit -m` deep dive
   - Git cherry-pick step-by-step workflow and branch history verification
   - Interactive demo script: `demo_cherry_pick.sh`

5. **[05-docker-fundamental](./05-docker-fundamental/README.md)**
   - Containerized Hello World web applications for 6 distinct stacks:
     - `nodejs-app/` (Express.js on Alpine)
     - `python-app/` (Python 3.11 HTTP Server)
     - `java-app/` (Java 17 Temurin HttpServer)
     - `Apache-app/` (Apache HTTP Server 2.4)
     - `React-app/` (React 18 SPA on Nginx)
     - `nginx-app/` (Nginx Alpine Web Server)
   - Automation script: `build_and_run_all.sh`

6. **[06-docker-multi-stage](./06-docker-multi-stage/README.md)**
   - Multi-stage Dockerfile build serving "Hello World from Docker multi-stage build" on port 8080
   - Process table and verification documentation
   - 3 standalone microservice deployments: Node.js, Python, Java
   - Deployment script: `build_and_run.sh`

7. **[07-docker-networking-volumes](./07-docker-networking-volumes/README.md)**
   - Task 1: 3-tier container networking with frontend, backend, database across 3 bridge networks
   - Task 2: Host networking driver with Apache2 on port 80
   - Task 3: Bind mounts and real-time host-to-container filesystem synchronization
   - Task 4: In-depth research on Docker Overlay Networks and multi-host VXLAN encapsulation
   - Setup script: `setup_networking_and_volumes.sh`
