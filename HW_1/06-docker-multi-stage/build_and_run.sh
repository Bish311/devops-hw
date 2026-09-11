#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

echo "=== Cleaning Up Previous Multi-Stage Containers ==="
docker rm -f multistage-main-container deploy-node-container deploy-python-container deploy-java-container 2>/dev/null || true

echo "=== Building and Deploying Multi-Stage Docker Applications ==="

# 1. Main Multi-Stage Homework App (Port 8080)
echo "Building primary multi-stage app on port 8080..."
docker build -t bishwayan/multistage-main:1.0 ./multi-stage-app
docker run -d --name multistage-main-container -p 8080:8080 bishwayan/multistage-main:1.0

# 2. Deployed Apps (Node.js, Python, Java)
echo "Building deployed Node.js microservice..."
docker build -t bishwayan/deploy-node:1.0 ./deployed-apps/nodejs
docker run -d --name deploy-node-container -p 3002:3000 bishwayan/deploy-node:1.0

echo "Building deployed Python microservice..."
docker build -t bishwayan/deploy-python:1.0 ./deployed-apps/python
docker run -d --name deploy-python-container -p 5002:5000 bishwayan/deploy-python:1.0

echo "Building deployed Java microservice..."
docker build -t bishwayan/deploy-java:1.0 ./deployed-apps/java
docker run -d --name deploy-java-container -p 8002:8000 bishwayan/deploy-java:1.0

sleep 3

echo "=== Testing Multi-Stage Endpoint on Port 8080 ==="
curl -s http://localhost:8080

echo -e "\n=== Testing 3 Deployed Applications ==="
curl -s http://localhost:3002
curl -s http://localhost:5002
curl -s http://localhost:8002

echo -e "\n=== Docker Process Table ==="
docker ps --filter "name=multistage-main-container" --filter "name=deploy-"
