#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

echo "=== Cleaning Up Previous Containers ==="
docker rm -f nodejs-app-container python-app-container java-app-container apache-app-container react-app-container nginx-app-container 2>/dev/null || true

echo "=== Building and Running Docker Fundamental Applications ==="

# 1. Node.js App
echo "Building nodejs-app..."
docker build -t bishwayan/nodejs-app:1.0 ./nodejs-app
docker run -d --name nodejs-app-container -p 3001:3000 bishwayan/nodejs-app:1.0

# 2. Python App
echo "Building python-app..."
docker build -t bishwayan/python-app:1.0 ./python-app
docker run -d --name python-app-container -p 5001:5000 bishwayan/python-app:1.0

# 3. Java App
echo "Building java-app..."
docker build -t bishwayan/java-app:1.0 ./java-app
docker run -d --name java-app-container -p 8001:8000 bishwayan/java-app:1.0

# 4. Apache App
echo "Building Apache-app..."
docker build -t bishwayan/apache-app:1.0 ./Apache-app
docker run -d --name apache-app-container -p 8081:80 bishwayan/apache-app:1.0

# 5. React App
echo "Building React-app..."
docker build -t bishwayan/react-app:1.0 ./React-app
docker run -d --name react-app-container -p 8082:80 bishwayan/react-app:1.0

# 6. Nginx App
echo "Building nginx-app..."
docker build -t bishwayan/nginx-app:1.0 ./nginx-app
docker run -d --name nginx-app-container -p 8083:80 bishwayan/nginx-app:1.0

echo "Waiting for servers to initialize..."
sleep 3

echo "=== Verifying Endpoints via curl ==="
echo "Node.js (3001):" && curl -s http://localhost:3001 | grep -o "Hello World[^<]*"
echo "Python  (5001):" && curl -s http://localhost:5001 | grep -o "Hello World[^<]*"
echo "Java    (8001):" && curl -s http://localhost:8001 | grep -o "Hello World[^<]*"
echo "Apache  (8081):" && curl -s http://localhost:8081 | grep -o "Hello World[^<]*"
echo "React   (8082):" && curl -s http://localhost:8082 | grep -o "Hello World[^<]*"
echo "Nginx   (8083):" && curl -s http://localhost:8083 | grep -o "Hello World[^<]*"

echo "Listing running containers:"
docker ps --filter "name=app-container"
