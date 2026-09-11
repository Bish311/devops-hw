#!/usr/bin/env bash
set -e

current_date=$(date)
host_name=$(hostname)
user_name=$(whoami)

echo "=========================================="
echo "         SYSTEM INFORMATION SCRIPT         "
echo "=========================================="
echo "Current Date & Time : $current_date"
echo "Hostname            : $host_name"
echo "Active User         : $user_name"
echo "=========================================="

echo ""
echo "--- Disk Usage ---"
df -h

echo ""
echo "--- Running Processes (Top 10) ---"
ps aux | head -n 11

echo ""
echo "--- User Details & Report Directory Setup ---"
read -p "Enter your name: " student_name
read -p "Enter your enrollment number: " enrollment_id
read -p "Enter a brief note or comment: " user_comment

report_dir="system_reports"
report_file="${report_dir}/process_snapshot.log"

mkdir -p "$report_dir"
touch "$report_file"

ps aux > "$report_file"

echo ""
echo "=========================================="
echo "Report generated successfully."
echo "Student Name  : $student_name"
echo "Enrollment ID : $enrollment_id"
echo "Comment       : $user_comment"
echo "Process log   : $report_file"
echo "Total lines captured in log: $(wc -l < "$report_file")"
echo "=========================================="
