#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="${SCRIPT_DIR}/network_diagnostics.log"

{
  echo "=== Networking Verification Script ==="
  echo "Timestamp: $(date)"

  echo -e "\n--- 1. Network Interfaces & IP Addresses (ip a / ipconfig) ---"
  ip a 2>/dev/null || ifconfig 2>/dev/null || ipconfig || true

  echo -e "\n--- 2. Routing Table (ip route / route print) ---"
  ip route 2>/dev/null || route print 2>/dev/null || true

  echo -e "\n--- 3. DNS Resolution (nslookup / dig) ---"
  nslookup example.com 2>/dev/null || dig example.com +short 2>/dev/null || true

  echo -e "\n--- 4. Reachability Test (ping 3 packets) ---"
  ping -c 3 1.1.1.1 2>/dev/null || ping -n 3 1.1.1.1 2>/dev/null || true

  echo -e "\n--- 5. Active Listening Ports (ss / netstat) ---"
  (ss -tuln 2>/dev/null || netstat -an 2>/dev/null || true) | head -n 30

  echo -e "\n--- 6. HTTP Connectivity Check (curl -I) ---"
  curl -I -s --max-time 5 http://example.com || true

  echo -e "\nDiagnostics completed. Output preserved in $OUTPUT_FILE"
} | tee "$OUTPUT_FILE"
