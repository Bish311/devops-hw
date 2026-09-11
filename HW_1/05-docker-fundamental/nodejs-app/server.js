const express = require("express");

const app = express();
const PORT = 3000;

app.get("/", (req, res) => {
  res.send("<!DOCTYPE html><html><body><h1>Hello World from Node.js!</h1></body></html>");
});

app.listen(PORT, "0.0.0.0", () => {
  process.stdout.write(`Node.js server running on port ${PORT}\n`);
});
