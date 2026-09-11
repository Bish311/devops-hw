#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

echo "=== Task 1: Docker Container Networking ==="
# Clean up previous resources if any
docker rm -f frontend backend database 2>/dev/null || true
docker network rm frontend-net backend-net db-net 2>/dev/null || true

# Create 3 distinct bridge networks
docker network create --driver bridge frontend-net
docker network create --driver bridge backend-net
docker network create --driver bridge db-net

# 1. Frontend container connected to frontend-net
docker run -d --name frontend --network frontend-net nginx:alpine

# 2. Database container connected to db-net
docker run -d --name database --network db-net -e MYSQL_ROOT_PASSWORD=bishwayan_secure_pass mysql:8.0

# 3. Backend container connected initially to backend-net, then joined to frontend-net and db-net
docker run -d --name backend --network backend-net alpine:latest sleep 3600
docker network connect frontend-net backend
docker network connect db-net backend

echo "Verifying network memberships:"
docker inspect frontend --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}'
docker inspect backend --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}'
docker inspect database --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}'

echo "Testing connectivity from Backend to Frontend:"
docker exec backend ping -c 2 frontend

echo "Testing connectivity from Backend to Database:"
docker exec backend ping -c 2 database

echo "Verifying isolation: Frontend should NOT resolve or reach Database:"
docker exec frontend ping -c 2 database 2>&1 || echo "Isolation confirmed: Frontend cannot route to Database."

echo "=== Task 2: Host Network ==="
docker rm -f host-apache 2>/dev/null || true
docker run -d --name host-apache --network host httpd:alpine
echo "Verifying Apache on host network port 80:"
curl -I http://localhost:80 || true

echo "=== Task 3: Bind Mount Demonstration ==="
docker rm -f bind-mount-nginx 2>/dev/null || true
MOUNT_DIR="$(pwd -W 2>/dev/null || pwd)/task3-bind-mount/html"
docker run -d --name bind-mount-nginx -p 8085:80 -v "${MOUNT_DIR}:/usr/share/nginx/html:ro" nginx:alpine

echo "Initial content on port 8085:"
curl -s http://localhost:8085

echo "Modifying index.html on host filesystem dynamically..."
sed -i 's/Hello students/Hello students - Updated in Real Time without Container Restart/g' "${MOUNT_DIR}/index.html"

echo "Verifying updated content on port 8085 immediately:"
curl -s http://localhost:8085

# Restore original content
sed -i 's/Hello students - Updated in Real Time without Container Restart/Hello students/g' "${MOUNT_DIR}/index.html"

echo "=== All Docker Networking & Volume tasks executed successfully ==="
