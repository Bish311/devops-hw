const http = require("http");

const PORT = 3000;
const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  res.end("<h1>Node.js Microservice Active</h1>");
});

server.listen(PORT, "0.0.0.0", () => {
  process.stdout.write(`Node.js microservice listening on port ${PORT}\n`);
});
