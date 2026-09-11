#!/usr/bin/env bash
set -e

WORK_DIR="/tmp/linux_fundamentals_demo"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "=== Task 1: Soft Links and Hard Links ==="
echo "Original content created by Bishwayan" > original.txt

ln original.txt hardlink.txt
ln -s original.txt softlink.txt

echo "Listing file details with inode numbers:"
ls -li original.txt hardlink.txt softlink.txt

echo "Appending new line to original file..."
echo "Updated content for verification" >> original.txt

echo "Content via hard link:"
cat hardlink.txt

echo "Content via soft link:"
cat softlink.txt

echo "Deleting original file to test link resilience..."
rm original.txt

echo "Checking hard link after original deletion:"
cat hardlink.txt

echo "Checking soft link status:"
if [ -e softlink.txt ]; then
    cat softlink.txt
else
    echo "Soft link is broken as expected because the target was deleted."
fi

rm -f hardlink.txt softlink.txt

echo "=== Task 2: User Management (useradd vs adduser) ==="
echo "Demonstrating useradd command structure:"
echo "Command: sudo useradd -m -s /bin/bash Bish1"
echo "Command: sudo adduser Bishwayan2"
echo "Preferred Ubuntu method: adduser (interactive Perl wrapper with default home directory, shell, and prompts)"

echo "=== Task 3: Service and System Logs via journalctl ==="
echo "Querying recent kernel logs:"
journalctl -k -n 5 --no-pager || true

echo "Querying system service logs with priority filter:"
journalctl -p err..alert -n 5 --no-pager || true

echo "=== Task 4: Common Linux Verification Commands ==="
uname -a
uptime
df -h
free -m

rm -rf "$WORK_DIR"
echo "Linux fundamental tasks completed successfully."
