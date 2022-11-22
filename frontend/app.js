const { request } = require("http");
const express = require("express");

const BACKEND_URL = process.env.BACKEND_URL || "http://localhost:8000";
const PORT = process.env.PORT || 3000;

const app = express();
app.use(express.static("public"));
app.use(express.json());
app.post("/hello", (req, res) => {
  const payload = JSON.stringify(req.body);
  const outgoing = request(
    BACKEND_URL,
    {
      method: "POST",
      headers: {
        "Content-type": "application/json",
        "Content-length": Buffer.byteLength(payload),
        ...req.headers,
      },
    },
    (resp) => {
      resp.setEncoding("utf8");
      resp.on("data", (chunk) => {
        res.write(chunk);
      });
      resp.on("end", () => {
        res.end();
      });
    }
  );
  outgoing.on("error", (err) => {
    res.status(500).json({ error: err.message });
  });
  outgoing.write(payload);
  outgoing.end();
});

app.listen(PORT);
