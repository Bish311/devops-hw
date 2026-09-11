from http.server import HTTPServer, BaseHTTPRequestHandler
import sys

HOST: str = "0.0.0.0"
PORT: int = 5000
BODY: bytes = (
    b"<!DOCTYPE html><html><body>"
    b"<h1>Python Microservice Active</h1>"
    b"</body></html>"
)


class Handler(BaseHTTPRequestHandler):
    def do_GET(self) -> None:
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(BODY)))
        self.end_headers()
        self.wfile.write(BODY)


def main() -> None:
    server = HTTPServer((HOST, PORT), Handler)
    sys.stdout.write(f"Python microservice listening on port {PORT}\n")
    sys.stdout.flush()
    server.serve_forever()


if __name__ == "__main__":
    main()
