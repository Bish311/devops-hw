const express = require("express");

const app = express();
const PORT = 8080;

app.get("/", (req, res) => {
  res.send("<h1>Hello World from Docker multi-stage build</h1>");
});

app.listen(PORT, "0.0.0.0", () => {
  process.stdout.write(`Multi-stage application running on port ${PORT}\n`);
});
