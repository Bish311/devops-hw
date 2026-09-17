const express = require('express');
const app = express();

const PORT = process.env.PORT || 3000;
const ENVIRONMENT = process.env.NODE_ENV || 'production';
const AUTHOR = 'Bishwayan';

app.use(express.json());

let requestCount = 0;

app.get('/', (req, res) => {
  requestCount++;
  res.json({
    status: 'online',
    message: `Hello from containerized service engineered by ${AUTHOR}!`,
    environment: ENVIRONMENT,
    timestamp: new Date().toISOString(),
    totalRequests: requestCount
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    uptimeSeconds: Math.floor(process.uptime()),
    memoryUsageMB: Math.round(process.memoryUsage().rss / (1024 * 1024))
  });
});

app.get('/info', (req, res) => {
  res.json({
    service: 'bish-docker-service',
    author: AUTHOR,
    studentId: '24BCS10200',
    nodeVersion: process.version,
    pid: process.pid
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`[${new Date().toISOString()}] Bishwayan microservice listening on port ${PORT}`);
});
