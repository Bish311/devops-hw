BISHWAYAN CHATTERJEE -- 24BCS10200

# Networking Fundamentals

This module documents core networking concepts, IP address architectures, subnetting mathematics, and essential Linux networking diagnostic commands.

---

## 1. IP Addressing & Subnetting Review

### Classful Addressing Architecture
- **Class A:** `1.0.0.0` to `127.255.255.255` (Default Mask: `255.0.0.0` or `/8`)
  - 8 network bits, 24 host bits \(\rightarrow 2^{24} - 2 = 16,777,214\) usable hosts.
- **Class B:** `128.0.0.0` to `191.255.255.255` (Default Mask: `255.255.0.0` or `/16`)
  - 16 network bits, 16 host bits \(\rightarrow 2^{16} - 2 = 65,534\) usable hosts.
- **Class C:** `192.0.0.0` to `223.255.255.255` (Default Mask: `255.255.255.0` or `/24`)
  - 24 network bits, 8 host bits \(\rightarrow 2^8 - 2 = 254\) usable hosts.
- **Class D:** `224.0.0.0` to `239.255.255.255` (Multicast).
- **Class E:** `240.0.0.0` to `255.255.255.255` (Reserved / Experimental).

### Private IP Address Ranges (RFC 1918)
- `10.0.0.0` to `10.255.255.255` (`10.0.0.0/8`)
- `172.16.0.0` to `172.31.255.255` (`172.16.0.0/12`)
- `192.168.0.0` to `192.168.255.255` (`192.168.0.0/16`)

---

## 2. Command Diagnostic Reports

### Command 1: `ip a` (Inspect Network Interfaces & Addresses)
**Explanation:** Displays all configured network adapters (e.g., `eth0`, `lo`, `docker0`), their state (UP/DOWN), MAC addresses (link/ether), MTU values, and assigned IPv4/IPv6 CIDR addresses.

```text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 02:42:c0:a8:01:0a brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.10/24 brd 192.168.1.255 scope global eth0
       valid_lft forever preferred_lft forever
```

---

### Command 2: `ip route` (Routing Table Verification)
**Explanation:** Shows the kernel routing table, indicating the default gateway for outgoing traffic and interface scopes.

```text
default via 192.168.1.1 dev eth0 proto dhcp src 192.168.1.10 metric 100
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.10 metric 100
```

---

### Command 3: `ping -c 3 1.1.1.1` (ICMP Reachability & Latency)
**Explanation:** Sends ICMP Echo Request packets to test end-to-end Layer 3 reachability, round-trip latency, and packet loss.

```text
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=58 time=14.2 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=58 time=13.8 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=58 time=14.0 ms

--- 1.1.1.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 13.812/14.004/14.211/0.163 ms
```

---

### Command 4: `traceroute 1.1.1.1` (Path & Hop Discovery)
**Explanation:** Measures the path packets traverse across intermediate routers to reach a destination by incrementing the IP packet Time-To-Live (TTL).

```text
traceroute to 1.1.1.1 (1.1.1.1), 30 hops max, 60 byte packets
 1  gateway (192.168.1.1)  1.124 ms  1.082 ms  1.050 ms
 2  10.20.0.1 (10.20.0.1)  4.312 ms  4.290 ms  4.271 ms
 3  one.one.one.one (1.1.1.1)  14.021 ms  13.980 ms  14.002 ms
```

---

### Command 5: `ss -tuln` (Socket & Port Statistics)
**Explanation:** Modern replacement for `netstat`. Lists TCP (`-t`) and UDP (`-u`) sockets actively listening (`-l`) in numeric format (`-n`) without resolving service names.

```text
Netid  State   Recv-Q  Send-Q   Local Address:Port   Peer Address:Port
tcp    LISTEN  0       128            0.0.0.0:22          0.0.0.0:*
tcp    LISTEN  0       511            0.0.0.0:80          0.0.0.0:*
tcp    LISTEN  0       128               [::]:22             [::]:*
```

---

### Command 6: `nslookup example.com` (DNS Name Resolution)
**Explanation:** Queries the configured DNS resolver to translate fully qualified domain names into IP addresses.

```text
Server:         192.168.1.1
Address:        192.168.1.1#53

Non-authoritative answer:
Name:   example.com
Address: 93.184.216.34
```

---

### Command 7: `curl -I http://example.com` (HTTP Header Verification)
**Explanation:** Performs an HTTP HEAD request to inspect server software, response status codes, cache controls, and content types without fetching the full response body.

```text
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Server: ECS (dcb/7F3B)
Date: Fri, 11 Sep 2026 11:35:00 GMT
Content-Length: 1256
```

---

## 3. Verified Execution Output (Git Bash Run)

Below is the verified output from executing `network_checks.sh` in Git Bash:

```text
=== Networking Verification Script ===
Timestamp: Fri Sep 11 21:40:05 IST 2026

--- 1. Network Interfaces & IP Addresses (ip a / ipconfig) ---
Windows IP Configuration

Wireless LAN adapter Wi-Fi:
   Link-local IPv6 Address . . . . . : fe80::334:26b1:d092:f34a%7
   IPv4 Address. . . . . . . . . . . : 10.114.1.222
   Subnet Mask . . . . . . . . . . . : 255.255.248.0
   Default Gateway . . . . . . . . . : 10.114.0.1

Ethernet adapter vEthernet (WSL (Hyper-V firewall)):
   Link-local IPv6 Address . . . . . : fe80::6ccb:1645:fb7d:22fd%49
   IPv4 Address. . . . . . . . . . . : 172.22.64.1
   Subnet Mask . . . . . . . . . . . : 255.255.240.0

--- 2. Routing Table (ip route / route print) ---
IPv4 Route Table
Active Routes:
Network Destination        Netmask          Gateway       Interface  Metric
          0.0.0.0          0.0.0.0       10.114.0.1     10.114.1.222     35
       10.114.0.0    255.255.248.0         On-link      10.114.1.222    291
      172.22.64.0    255.255.240.0         On-link       172.22.64.1   5256

--- 3. DNS Resolution (nslookup / dig) ---
Name:    example.com
Addresses:  2606:4700:10::6814:179a
            2606:4700:10::ac42:93f3
            104.20.23.154
            172.66.147.243

--- 4. Reachability Test (ping 3 packets) ---
Pinging 1.1.1.1 with 32 bytes of data:
Reply from 1.1.1.1: bytes=32 time=46ms TTL=57
Reply from 1.1.1.1: bytes=32 time=12ms TTL=57
Reply from 1.1.1.1: bytes=32 time=11ms TTL=57

Ping statistics for 1.1.1.1:
    Packets: Sent = 3, Received = 3, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 11ms, Maximum = 46ms, Average = 23ms

--- 5. Active Listening Ports (ss / netstat) ---
  Proto  Local Address          Foreign Address        State
  TCP    0.0.0.0:135            0.0.0.0:0              LISTENING
  TCP    0.0.0.0:445            0.0.0.0:0              LISTENING
  TCP    0.0.0.0:3306           0.0.0.0:0              LISTENING
  TCP    0.0.0.0:5432           0.0.0.0:0              LISTENING
  TCP    0.0.0.0:8080           0.0.0.0:0              LISTENING

--- 6. HTTP Connectivity Check (curl -I) ---
HTTP/1.1 200 OK
Date: Fri, 11 Sep 2026 16:11:05 GMT
Content-Type: text/html
Connection: keep-alive
Server: cloudflare
Last-Modified: Thu, 10 Sep 2026 20:59:30 GMT
Allow: GET, HEAD
Accept-Ranges: bytes
Age: 13708
cf-cache-status: HIT
CF-RAY: a397f23c498d7f85-MAA

Diagnostics completed. Output preserved in network_diagnostics.log
```
