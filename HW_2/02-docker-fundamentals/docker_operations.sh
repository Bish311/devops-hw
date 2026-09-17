#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="${SCRIPT_DIR}/app"
IMAGE_TAG="bishwayan/microservice:1.0"
CONTAINER_NAME="bish-standalone-api"

echo "================================================================"
echo " Docker Architecture & Container Operations Automation"
echo " Author: Bishwayan Chatterjee (24BCS10200)"
echo "================================================================"

echo ""
echo "[Step 1/5] Building optimized Docker image..."
docker build -t "${IMAGE_TAG}" "${APP_DIR}"

echo "Verifying image size and layer structure:"
docker images "${IMAGE_TAG}"

echo ""
echo "[Step 2/5] Running container with resource constraints..."
docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true

docker run -d \
  --name "${CONTAINER_NAME}" \
  -p 3001:3000 \
  --cpus="0.5" \
  --memory="128m" \
  --restart="unless-stopped" \
  "${IMAGE_TAG}"

echo "Verifying running container:"
docker ps --filter "name=${CONTAINER_NAME}"

echo ""
echo "[Step 3/5] Testing container health & executing in-container commands..."
echo "Waiting 5 seconds for initialization..."
sleep 5

echo "Testing HTTP endpoint via host port:"
curl -s http://localhost:3001/ || true
echo ""
curl -s http://localhost:3001/health || true
echo ""

echo "Executing non-root verification inside container:"
docker exec "${CONTAINER_NAME}" id
docker exec "${CONTAINER_NAME}" whoami

echo "Inspecting resource limits from docker inspect:"
docker inspect "${CONTAINER_NAME}" --format 'Memory Limit: {{.HostConfig.Memory}} bytes, NanoCPUs: {{.HostConfig.NanoCpus}}'

echo ""
echo "[Step 4/5] Testing Multi-Tier Docker Compose Stack..."
cd "${SCRIPT_DIR}"
docker compose up -d

echo "Checking running Compose services:"
docker compose ps

echo "Testing reverse proxy access via Nginx (Port 8080):"
sleep 3
curl -s http://localhost:8080/ || true
echo ""

echo ""
echo "[Step 5/5] Teardown & Resource Cleanup..."
echo "Stopping standalone container..."
docker rm -f "${CONTAINER_NAME}"

echo "Stopping Compose services..."
docker compose down -v

echo ""
echo "================================================================"
echo " Docker fundamentals demonstration completed successfully!"
echo "================================================================"
