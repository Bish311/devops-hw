BISHWAYAN CHATTERJEE -- 24BCS10200

# Shell Scripting: System Information Automation

This module contains an automated bash script (`system_info.sh`) designed to gather system diagnostics, accept user inputs, manage directory structures, and redirect running process output to a persistent log file.

---

## Script Features & Mandated Commands

The script strictly utilizes the required DevOps primitives:
- `date` & Variables: Captures and stores current timestamp into `$current_date`.
- `hostname` & `whoami`: Resolves system identification.
- `df -h`: Displays mounted filesystem disk usage in human-readable format.
- `ps aux`: Enumerates running system processes.
- `read -p`: Interactively prompts the operator for name, enrollment number, and comments.
- `mkdir -p`: Creates the output report directory (`system_reports`).
- `touch`: Initializes the target log file (`process_snapshot.log`).
- `>` redirection: Diverts stdout of `ps aux` to write cleanly into the target log file.

---

## How to Execute

```bash
# Ensure execution permissions are granted
chmod +x system_info.sh

# Run the script
./system_info.sh
```

---

## Verified Execution Output

```text
==========================================
         SYSTEM INFORMATION SCRIPT         
==========================================
Current Date & Time : Fri Sep 11 12:07:58 PM UTC 2026
Hostname            : Check
Active User         : runner5
==========================================

--- Disk Usage ---
Filesystem        Size  Used Avail Use% Mounted on
overlay            29G   19G   11G  64% /
tmpfs              64M     0   64M   0% /dev
shm                64M     0   64M   0% /dev/shm
tmpfs             512M  4.0K  512M   1% /tmp
tmpfs              30M  4.0K   30M   1% /home
/dev/root          29G   19G   11G  64% /script
10.160.0.30:/nix   28G   28G     0 100% /nix

--- Running Processes (Top 10) ---
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   2692  1372 pts/0    Ss+  11:23   0:00 /script/cinit
root          51  0.0  0.0   7668  3876 pts/2    Ss+  11:24   0:00 /bin/bash --noediting
runner5      259  0.0  0.0      0     0 ?        Z    11:26   0:00 [tinit] <defunct>
runner5      260  0.0  0.0      0     0 ?        Zs   11:26   0:00 [a.out] <defunct>
runner5      437  0.0  0.0      0     0 ?        Z    11:29   0:00 [tinit] <defunct>
runner5      438  0.0  0.0      0     0 ?        Zs   11:29   0:00 [a.out] <defunct>
runner5      910  0.0  0.0      0     0 ?        Z    11:34   0:00 [tinit] <defunct>
runner5      911  0.0  0.0      0     0 ?        Zs   11:34   0:00 [a.out] <defunct>
root        1506  0.0  0.0      0     0 ?        Z    11:49   0:00 [Xvfb] <defunct>
runner5     1524  0.0  0.0      0     0 ?        Z    11:50   0:00 [.health] <defunct>

--- User Details & Report Directory Setup ---
Enter your name: Bish
Enter your enrollment number: Bx001
Enter a brief note or comment: VIBES

==========================================
Report generated successfully.
Student Name  : Bish
Enrollment ID : Bx001
Comment       : VIBES
Process log   : system_reports/process_snapshot.log
Total lines captured in log: 20
==========================================
```
