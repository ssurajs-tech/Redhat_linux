# 🐧 Linux & RHEL Admin — Interview Notes

> A quick-reference guide covering RHEL upgrades, troubleshooting, scripting, and common interview questions.

---

## Table of Contents

1. [Upgrade RHEL 7 to RHEL 8](#01-upgrade-rhel-7-to-rhel-8)
2. [Remove Files Older Than 7 Days via Cron](#02-remove-files-older-than-7-days-via-cron)
3. [Show Lines Not Starting With #](#03-show-lines-not-starting-with-)
4. [Default Files for useradd](#04-default-files-for-useradd)
5. [Soft vs Hard Links](#05-soft-vs-hard-links)
6. [What is lsof and How to Use It](#06-what-is-lsof-and-how-to-use-it)
7. [Create User with Home Dir, UID, GID, Shell](#07-create-user-with-home-dir-uid-gid-shell)
8. [Basic Linux Commands](#08-basic-linux-commands)
9. [Restore Lost .pem File and Access EC2](#09-restore-lost-pem-file-and-access-ec2)
10. [/var is 90% Full — What Do You Do?](#10-var-is-90-full--what-do-you-do)
11. [Linux Server Slow Due to High CPU](#11-linux-server-slow-due-to-high-cpu)
12. [Nginx Returns Connection Refused](#12-nginx-returns-connection-refused)
13. [SSH Stopped Working — Troubleshoot](#13-ssh-stopped-working--troubleshoot)
14. [Find Files Older Than 7 Days in /var/log](#14-find-files-older-than-7-days-in-varlog)
15. [Find and Remove Log Files Older Than 30 Days](#15-find-and-remove-log-files-older-than-30-days)
16. [Automate Log Compression & Deletion with Cron](#16-automate-log-compression--deletion-with-cron)
17. [Create System Users from a CSV File](#17-create-system-users-from-a-csv-file)
18. [Service Health Monitoring Script](#18-service-health-monitoring-script)
19. [Find and Remove Files Over 100 MB](#19-find-and-remove-files-over-100-mb)
20. [Get List of Users Who Logged in Today](#20-get-list-of-users-who-logged-in-today)
21. [Website Does Not Load — How to Investigate](#21-website-does-not-load--how-to-investigate)
22. [Remove First and Last Line of a File](#22-remove-first-and-last-line-of-a-file)
23. [Types of Variables in Linux / Bash](#23-types-of-variables-in-linux--bash)
24. [Difference Between kill and kill -9](#24-difference-between-kill-and-kill--9)

---

## 01. Upgrade RHEL 7 to RHEL 8

**Requirements:** RHEL 7.6 installed · Server variant · Intel 64 architecture · 100 MB+ free on `/boot`

### Step 1 — Prepare the System

```bash
yum update
subscription-manager attach --auto
subscription-manager list --installed
subscription-manager release --set 7.6
yum versionlock clear
yum update && reboot
```

### Step 2 — Enable Extras & Install Leapp

```bash
subscription-manager repos --enable rhel-7-server-extras-rpms
yum install leapp
```

### Step 3 — Download Leapp Data Files

```bash
cd /etc/leapp/files/
wget https://access.redhat.com/sites/default/files/attachments/leapp-data3.tar.gz
tar -xf leapp-data3.tar.gz
rm leapp-data3.tar.gz
```

> ⚠️ **Take a full system backup before proceeding.** If the upgrade fails, you need a restore point.

### Step 4 — Run the Upgrade

```bash
leapp upgrade
reboot
```

Leapp tests upgradability and writes a report to `/var/log/leapp/leapp-report.txt`. After reboot, the RHEL 8 initramfs takes over automatically.

### Step 5 — Post-Upgrade Verification

```bash
setenforce 1
systemctl start firewalld && systemctl enable firewalld
cat /etc/redhat-release         # Red Hat Enterprise Linux release 8.0 (Ootpa)
uname -r
subscription-manager list --installed
hostnamectl set-hostname my-rhel8-host
```

---

## 02. Remove Files Older Than 7 Days via Cron

```bash
crontab -e
```

Add the following entry:

```
# Run every night at 2:00 AM
0 2 * * * find /var/log/messages -type f -mtime +7 -exec rm -f {} \;
```

```bash
crontab -l    # verify the entry was saved
```

> `-mtime +7` = files modified more than 7 days ago. Use `-exec rm -f` (not `-rf`) for individual files.

---

## 03. Show Lines Not Starting With `#`

```bash
grep -v '^#' file.txt
```

`grep -v` inverts the match — it prints every line that does **not** match the pattern `^#`.

---

## 04. Default Files for `useradd`

Two files control defaults when creating a user with `useradd`:

```bash
cat /etc/default/useradd    # default shell, home dir base, expiry, etc.
cat /etc/login.defs         # UID/GID ranges, password aging, umask
```

> ⚠️ Common mistake: `/bin/bash/useraddc` and `/etc/logindef` are **incorrect** paths.

---

## 05. Soft vs Hard Links

### Soft Link (Symbolic Link)

A shortcut or pointer to another file — stores the **path** of the target.

```bash
ln -s /opt/data/file1 /tmp/link1
```

### Hard Link

Points directly to the same **inode** (actual disk data) as the original file.

```bash
ln /opt/data/file1 /tmp/hardlink1
```

### Comparison

| Feature | Soft Link | Hard Link |
|---|---|---|
| Points to | File path (name) | Inode (actual data) |
| Inode | Different | Same |
| Works across filesystems | ✅ Yes | ❌ No |
| Broken if original deleted | ✅ Yes | ❌ No |
| Can link to directories | ✅ Yes | ❌ No |

> 💡 **Analogy:** Soft link = desktop shortcut. Hard link = another name for the same file.

---

## 06. What is `lsof` and How to Use It

`lsof` = **List Open Files**. In Linux, everything is a file — regular files, sockets, pipes, devices. `lsof` shows which process has which file open.

### Common Commands

```bash
# Which process is using a port?
lsof -i :8080

# All open network connections
lsof -i
lsof -i tcp

# Which process is using a specific file?
lsof /path/to/file

# Find deleted files still holding disk space
lsof | grep deleted

# All files opened by a specific process
lsof -p <PID>

# All open files on a filesystem or mount
lsof /var
lsof /mnt/nfs
```

> 💡 If `lsof | grep deleted` shows files, disk space won't free up until you restart the process holding them.

---

## 07. Create User with Home Dir, UID, GID, Shell

```bash
# Create user
useradd -m -d /home/username -s /bin/bash -u 9000 -g groupname username

# Delete user (including home directory)
userdel -r username
```

| Flag | Meaning |
|---|---|
| `-m` | Create home directory |
| `-d /home/username` | Specify home dir path |
| `-s /bin/bash` | Set login shell |
| `-u 9000` | Set UID |
| `-g groupname` | Set primary group |

---

## 08. Basic Linux Commands

| Command | Purpose |
|---|---|
| `ls` | List directory contents |
| `pwd` | Print working directory |
| `cd` | Change directory |
| `chown user:group file` | Change file ownership |
| `chgrp group file` | Change group ownership |
| `chmod 755 file` | Change file permissions |
| `cp / mv / rm` | Copy / move / remove |
| `find / grep / awk / sed` | Search and text processing |
| `df -h / du -sh` | Disk usage |
| `top / ps / kill` | Process management |

---

## 09. Restore Lost `.pem` File and Access EC2

> ❌ You **cannot** re-download the `.pem` key from AWS or recover the original private key.

### Option 1 — EC2 Instance Connect (Easiest)

If the instance is Amazon Linux 2 / Ubuntu with EC2 Instance Connect enabled:
EC2 Console → Select Instance → **Connect** → **EC2 Instance Connect** → Connect. No `.pem` needed.

### Option 2 — Replace Key via Volume Method ✅ (Best for Most Cases)

```bash
# 1. Stop the instance, detach root volume (/dev/xvda)
# 2. Attach it as secondary volume to a helper instance (/dev/xvdf)

# 3. On the helper instance:
sudo mkdir /mnt/temp
sudo mount /dev/xvdf1 /mnt/temp
cd /mnt/temp/home/ec2-user/.ssh

# 4. Replace with your new public key:
echo "ssh-rsa AAAA....your-new-public-key" > authorized_keys

# 5. Unmount, reattach, restart original instance
sudo umount /mnt/temp
```

### Option 3 — SSM Session Manager

Requires: SSM Agent installed + `AmazonSSMManagedInstanceCore` IAM role.
AWS Console → Systems Manager → Session Manager → Start Session.

### Option 4 — Launch from AMI

If you have an earlier AMI, launch a new instance with the correct key pair during creation.

---

## 10. `/var` is 90% Full — What Do You Do?

### Investigate

```bash
du -sh /var/* | sort -h
du -sh /var/log/*
journalctl --disk-usage
ls -lh /var/tmp
```

### Cleanup

```bash
logrotate -f /etc/logrotate.conf      # rotate logs
journalctl --vacuum-size=500M         # clear journal logs
yum clean all                         # remove yum cache
find /var/log -type f -name "*.log" -size +100M
rm -rf /var/tmp/*
```

### Validate

```bash
df -h /var    # target: below 70%
```

### Permanent Fixes

- Extend `/var` partition using LVM
- Move logs to a separate EBS volume
- Tune log rotation policies (`/etc/logrotate.d/`)
- Reduce debug log verbosity
- Set monitoring alerts at 70% / 80%

---

## 11. Linux Server Slow Due to High CPU

### 1. Identify the Problem Process

```bash
top
uptime                                          # check load avg vs vCPU count
top -o %CPU
ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head
```

### 2. CPU Breakdown

```bash
mpstat -P ALL 1 5     # %usr, %sys, %iowait, %steal
iostat -xm 5          # if I/O wait is high
iotop
```

### 3. Thread-Level Analysis

```bash
top -H -p <PID>       # threads inside a process
jstack <PID>          # Java thread dump
py-spy top            # Python profiler
```

### 4. Quick Fixes

```bash
systemctl restart <service>    # restart misbehaving service
kill -9 <PID>                  # last resort — kill rogue process
cat /var/log/cron              # check for runaway cron jobs
```

### Root Cause → Fix

| Root Cause | Fix |
|---|---|
| Single process spike | Restart or kill the service |
| High I/O wait | Add SSD, tune DB queries, move jobs off peak |
| CPU steal > 20% | Migrate VM, increase vCPU, escalate to cloud team |
| Application bug | Capture thread dump, raise to Dev with CPU graphs |
| Cron job conflict | Audit crontabs, stagger schedules |
| Undersized instance | Scale up (e.g., m5.large → m5.xlarge) |

---

## 12. Nginx Returns Connection Refused

```bash
# 1. Is Nginx running?
systemctl status nginx
systemctl start nginx && systemctl enable nginx

# 2. Is it listening on the right port?
ss -tulnp | grep nginx

# 3. Test config and reload
nginx -t
systemctl reload nginx

# 4. Check backend (if reverse proxy)
systemctl status myapp
curl http://localhost:3000

# 5. Firewall
firewall-cmd --list-all
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload

# 6. SELinux (RHEL-specific)
sestatus
setsebool -P httpd_can_network_connect on

# 7. Logs
tail -f /var/log/nginx/error.log
journalctl -u nginx -f
```

| Cause | Fix |
|---|---|
| Nginx is down | Start/restart service |
| Wrong listen port | Fix `listen` directive in config |
| Backend app down | Start backend service |
| Firewall blocking | Open ports 80/443 |
| SELinux blocking | Enable `httpd_can_network_connect` |
| Port conflict (Apache) | `systemctl stop httpd` |

---

## 13. SSH Stopped Working — Troubleshoot

| Issue | Fix |
|---|---|
| SSH service stopped | `systemctl start sshd` |
| SSH config corrupted | Fix config, test with `sshd -t` |
| Firewall blocking port 22 | Open port 22 in firewalld |
| Security group changed | Re-add inbound SSH rule |
| Wrong key or username | Verify username and `.pem` path |
| Disk 100% full | Clean logs, increase volume size |
| High CPU | Restart service, kill rogue process |
| IP changed | Connect using updated IP/DNS |

---

## 14. Find Files Older Than 7 Days in `/var/log`

```bash
# List files older than 7 days
find /var/log -type f -mtime +7

# Detailed output (size, permissions, etc.)
find /var/log -type f -mtime +7 -ls

# Compress files older than 7 days
find /var/log -type f -mtime +7 -exec gzip {} \;

# Delete files older than 30 days
find /var/log -type f -mtime +30 -delete
```

> `-mtime +7` = modified more than 7 days ago. `-type f` = files only (not directories).

---

## 15. Find and Remove Log Files Older Than 30 Days

```bash
# Safe: list first, then delete
find /var/log -type f -mtime +30

# Delete all files older than 30 days
find /var/log -type f -mtime +30 -exec rm -f {} \;

# Delete only compressed (.gz) logs older than 30 days
find /var/log -name "*.gz" -mtime +30 -delete
```

---

## 16. Automate Log Compression & Deletion with Cron

### 1. Create the Script

```bash
#!/bin/bash

LOG_DIR="/var/log/myapp"

# Compress logs older than 7 days (skip already compressed)
find $LOG_DIR -type f -mtime +7 ! -name "*.gz" -exec gzip {} \;

# Delete logs older than 30 days
find $LOG_DIR -type f -mtime +30 -exec rm -f {} \;
```

```bash
chmod +x /usr/local/bin/myapp_logrotate.sh
```

### 2. Schedule with Cron

```bash
crontab -e
```

```
# Run daily at 2:00 AM
0 2 * * * /usr/local/bin/myapp_logrotate.sh
```

---

## 17. Create System Users from a CSV File

### 1. Copy CSV to the VM

```bash
scp users.csv root@192.168.1.10:/tmp/
```

### 2. Sample CSV (`users.csv`)

```
username,password,group
john,Pass@123,developers
alice,Pass@123,qa
mike,Pass@123,admins
```

### 3. Shell Script (`create_users.sh`)

```bash
#!/bin/bash

INPUT="/tmp/users.csv"

tail -n +2 "$INPUT" | while IFS=',' read -r username password group
do
  # Create group if it doesn't exist
  if ! getent group "$group" >/dev/null; then
    groupadd "$group"
  fi

  # Create user with home directory
  useradd -m -g "$group" "$username"

  # Set password
  echo "$username:$password" | chpasswd

  echo "Created user: $username in group: $group"
done
```

```bash
chmod +x create_users.sh
./create_users.sh
```

---

## 18. Service Health Monitoring Script

```bash
#!/bin/bash

services=("nginx" "sshd" "docker")

for service in "${services[@]}"; do
  if systemctl is-active --quiet "$service"; then
    echo "✅ $service is active"
  else
    echo "⚠️  $service is down — attempting restart..."
    systemctl restart "$service"

    if systemctl is-active --quiet "$service"; then
      echo "✅ $service restarted successfully"
    else
      echo "❌ $service failed to start — check logs:"
      echo "   journalctl -u $service --no-pager | tail -20"
    fi
  fi
done
```

---

## 19. Find and Remove Files Over 100 MB

```bash
# List files over 100 MB (review before deleting)
find /var/log -type f -size +100M -exec ls -ltrh {} \;

# Delete interactively (asks confirmation per file)
find /var/log -type f -size +100M -exec rm -i {} \;

# Delete non-interactively
find /var/log -type f -size +100M -exec rm -f {} \;
```

> ⚠️ Always list files first before deleting. Use `-i` (interactive) for safety in production.

---

## 20. Get List of Users Who Logged in Today

```bash
# Show full login history with timestamps
last -F

# Filter for today's date
last -F | grep "$(date '+%a %b %e')"
```

> `last` reads from `/var/log/wtmp`. Use `lastb` for **failed** login attempts.

---

## 21. Website Does Not Load — How to Investigate

1. Check if the web server is running: `systemctl status nginx` or `systemctl status httpd`
2. Check error logs: `tail -f /var/log/nginx/error.log`
3. Verify the web root (`index.html` / `index.php`) exists and has correct permissions
4. Test the backend: `curl http://localhost:<port>`
5. Confirm the port is listening: `ss -tulnp | grep 80`
6. Check firewall rules: `firewall-cmd --list-all`
7. Check DNS resolution: `nslookup yourdomain.com`
8. Check SELinux: `sestatus` and audit logs: `ausearch -m avc -ts today`

---

## 22. Remove First and Last Line of a File

### Method 1 — `sed` (Fastest)

```bash
# Print without modifying the file
sed '1d;$d' input.txt

# Edit the file in place
sed -i '1d;$d' input.txt
```

### Method 2 — `tail` + `head` (Readable)

```bash
tail -n +2 input.txt | head -n -1 > output.txt
```

### Method 3 — `awk`

```bash
awk 'NR!=1 { a[NR]=$0 } END { for(i=2;i<NR;i++) print a[i] }' input.txt
```

| Method | Best For |
|---|---|
| `sed` | Small & large files — simplest and fastest |
| `tail + head` | Readable one-liner logic |
| `awk` | Complex text processing pipelines |

---

## 23. Types of Variables in Linux / Bash

| Type | Scope | Example |
|---|---|---|
| Local | Current shell only | `name="John"` |
| Environment | Shell + child processes | `export PATH=$PATH:/opt` |
| Shell / Special | Built-in bash variables | `$HOME`, `$PWD`, `$SHELL` |
| Read-only | Cannot be changed | `readonly PI=3.14` |
| Array | Indexed list | `arr=("a" "b" "c")` |

### Special Bash Variables

| Variable | Meaning |
|---|---|
| `$?` | Exit status of last command |
| `$0` | Script name |
| `$1`–`$9` | Positional arguments |
| `$#` | Number of arguments |
| `$@` | All arguments as separate words |
| `$$` | PID of current script |
| `$!` | PID of last background command |

---

## 24. Difference Between `kill` and `kill -9`

| | `kill` (SIGTERM) | `kill -9` (SIGKILL) |
|---|---|---|
| Signal number | 15 | 9 |
| Behavior | Asks process to shut down gracefully | Forces immediate termination |
| Cleanup | ✅ Process can save state, close files | ❌ No cleanup — data may be lost |
| Can be caught/ignored | ✅ Yes | ❌ No — kernel enforces it |
| When to use | Default / preferred | Last resort — hung/frozen process |

```bash
kill <PID>      # SIGTERM — graceful shutdown
kill -9 <PID>   # SIGKILL — force kill (last resort)
```

> ⚠️ Always try `kill` first and wait a few seconds before escalating to `kill -9`.

---

*Linux & RHEL Admin Interview Notes · 24 Topics · RHEL 7/8 · Bash Scripting · Troubleshooting*