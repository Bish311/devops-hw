from http.server import HTTPServer, BaseHTTPRequestHandler
import sys

HOST: str = "0.0.0.0"
PORT: int = 5000
HTML_RESPONSE: bytes = (
    b"<!DOCTYPE html><html><body>"
    b"<h1>Hello World from Python!</h1>"
    b"</body></html>"
)


class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self) -> None:
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(HTML_RESPONSE)))
        self.end_headers()
        self.wfile.write(HTML_RESPONSE)


def run_server() -> None:
    server = HTTPServer((HOST, PORT), SimpleHandler)
    sys.stdout.write(f"Python server running on port {PORT}\n")
    sys.stdout.flush()
    server.serve_forever()


if __name__ == "__main__":
    run_server()
