# Application Log Archive Script - Complete Guide

A production-ready Bash script for automated log collection, compression, and archiving with retention management.

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Automation with Cron](#automation-with-cron)
- [Advanced Examples](#advanced-examples)
- [Troubleshooting](#troubleshooting)

---

## Features

### Core Functionality

✅ **Multi-Pattern Log Collection** - Collects logs from multiple sources and patterns  
✅ **Compression Support** - gzip, bzip2, or xz compression  
✅ **Automatic Retention** - Removes archives older than specified days  
✅ **Checksum Generation** - MD5 checksums for archive integrity  
✅ **Directory Structure Preservation** - Maintains original log hierarchy  
✅ **Detailed Reporting** - Generates comprehensive archive reports  
✅ **Colored Output** - Easy-to-read console messages  
✅ **Error Handling** - Robust error checking and validation

### Security Features

- Requires appropriate permissions
- Sets secure directory permissions (750)
- Warns when not running as root
- Validates all operations

---

## Quick Start

### Basic Usage

```bash
# Make script executable
chmod +x log_archive.sh

# Run with default settings
sudo ./log_archive.sh

# View help
./log_archive.sh --help
```

### Default Behavior

- **Source**: `/var/log`
- **Destination**: `/var/log_archives`
- **Retention**: 30 days
- **Compression**: gzip

---

## Installation

### Step 1: Download the Script

```bash
# Create directory for scripts
sudo mkdir -p /opt/scripts

# Download or create the script
sudo vi /opt/scripts/log_archive.sh

# Paste the script content and save
```

### Step 2: Set Permissions

```bash
# Make executable
sudo chmod +x /opt/scripts/log_archive.sh

# Set ownership
sudo chown root:root /opt/scripts/log_archive.sh
```

### Step 3: Test the Script

```bash
# Run test with verbose output
sudo /opt/scripts/log_archive.sh
```

### Step 4: Create Archive Directory

The script automatically creates the directory, but you can pre-create it:

```bash
sudo mkdir -p /var/log_archives
sudo chmod 750 /var/log_archives
```

---

## Usage

### Command Line Options

```bash
./log_archive.sh [OPTIONS]

Options:
  -s, --source DIR        Source directory for logs
  -d, --destination DIR   Archive destination directory
  -r, --retention DAYS    Retention period in days
  -c, --compression TYPE  Compression type (gzip/bzip2/xz)
  -h, --help              Display help message
```

### Examples

#### Example 1: Default Execution

```bash
sudo ./log_archive.sh
```

**Output**:
```
════════════════════════════════════════════════════════════════════
           Application Log Archive Script - v1.0
════════════════════════════════════════════════════════════════════

[INFO] Checking system requirements...
[SUCCESS] All requirements satisfied
[INFO] Archive directory already exists: /var/log_archives
[INFO] Collecting logs from /var/log...
[INFO]   ✓ Collected: /var/log/syslog
[INFO]   ✓ Collected: /var/log/auth.log
[SUCCESS] Collected 15 log files (Total size: 2.5M)
[INFO] Creating archive: server01_logs_20260103_143022
[SUCCESS] Archive created: /var/log_archives/server01_logs_20260103_143022.tar.gz
[INFO] Archive size: 512K
[SUCCESS] Checksum saved: /var/log_archives/server01_logs_20260103_143022.tar.gz.md5
[SUCCESS] Log archiving completed successfully!
```

#### Example 2: Custom Source and Destination

```bash
sudo ./log_archive.sh \
  --source /opt/myapp/logs \
  --destination /backup/app_logs
```

#### Example 3: 60-Day Retention with bzip2

```bash
sudo ./log_archive.sh \
  --retention 60 \
  --compression bzip2
```

#### Example 4: Archive Specific Application Logs

```bash
sudo ./log_archive.sh \
  --source /var/log/nginx \
  --destination /backup/nginx_logs \
  --retention 90 \
  --compression xz
```

---

## Configuration

### Customizing Log Patterns

Edit the script to modify which logs are collected:

```bash
# Edit the LOG_PATTERNS array
declare -a LOG_PATTERNS=(
    "apache2/*.log"           # Apache logs
    "nginx/*.log"             # Nginx logs
    "mysql/*.log"             # MySQL logs
    "postgresql/*.log"        # PostgreSQL logs
    "application/*.log"       # Application logs
    "syslog"                  # System log
    "messages"                # System messages
    "auth.log"                # Authentication log
    "myapp/*.log"             # Custom application
    "tomcat/catalina.out"     # Tomcat logs
)
```

### Compression Types

Choose based on your needs:

| Type | Speed | Compression | Best For |
|------|-------|-------------|----------|
| **gzip** | Fast | Good | General use, quick archiving |
| **bzip2** | Medium | Better | Balanced performance |
| **xz** | Slow | Best | Maximum compression, long-term storage |

### Directory Structure

After running, your archive directory will look like:

```
/var/log_archives/
├── server01_logs_20260103_143022.tar.gz
├── server01_logs_20260103_143022.tar.gz.md5
├── server01_logs_20260102_143015.tar.gz
├── server01_logs_20260102_143015.tar.gz.md5
├── archive_report_20260103_143022.txt
└── archive_report_20260102_143015.txt
```

---

## Automation with Cron

### Daily Archiving (Midnight)

```bash
# Edit root's crontab
sudo crontab -e

# Add this line for daily execution at midnight
0 0 * * * /opt/scripts/log_archive.sh >> /var/log/log_archive.log 2>&1
```

### Weekly Archiving (Sunday 2 AM)

```bash
0 2 * * 0 /opt/scripts/log_archive.sh >> /var/log/log_archive.log 2>&1
```

### Hourly Archiving (For High-Volume Logs)

```bash
0 * * * * /opt/scripts/log_archive.sh -s /var/log/highvolume -d /backup/hourly >> /var/log/log_archive.log 2>&1
```

### Monthly with Custom Settings

```bash
0 3 1 * * /opt/scripts/log_archive.sh -r 180 -c xz >> /var/log/log_archive.log 2>&1
```

### Cron Schedule Reference

```
* * * * * command
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sunday = 0 or 7)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

---

## Advanced Examples

### Example 1: Archive Multiple Applications

Create separate scripts for each application:

```bash
# Web server logs
sudo ./log_archive.sh \
  -s /var/log/nginx \
  -d /backup/nginx_archives \
  -r 60

# Database logs
sudo ./log_archive.sh \
  -s /var/log/mysql \
  -d /backup/mysql_archives \
  -r 90

# Application logs
sudo ./log_archive.sh \
  -s /opt/myapp/logs \
  -d /backup/app_archives \
  -r 30
```

### Example 2: Archive to Remote NFS Share

```bash
# Mount NFS share
sudo mount -t nfs backup-server:/exports/logs /mnt/backup

# Run archive to NFS
sudo ./log_archive.sh -d /mnt/backup/server01_logs

# Unmount
sudo umount /mnt/backup
```

### Example 3: Archive and Upload to S3

```bash
#!/bin/bash
# Combined script: archive and upload

# Run archive
/opt/scripts/log_archive.sh

# Upload latest archive to S3
latest_archive=$(ls -t /var/log_archives/*.tar.gz | head -1)
aws s3 cp "$latest_archive" s3://my-bucket/logs/

echo "Archive uploaded to S3: $latest_archive"
```

### Example 4: Email Notification on Completion

```bash
#!/bin/bash
# Archive with email notification

/opt/scripts/log_archive.sh

# Send email notification
latest_report=$(ls -t /var/log_archives/archive_report_*.txt | head -1)
mail -s "Log Archive Completed - $(hostname)" admin@example.com < "$latest_report"
```

### Example 5: Archive with Disk Space Check

```bash
#!/bin/bash
# Check disk space before archiving

MIN_SPACE_GB=10
available_space=$(df /var/log_archives | tail -1 | awk '{print int($4/1024/1024)}')

if [ "$available_space" -lt "$MIN_SPACE_GB" ]; then
    echo "ERROR: Insufficient disk space. Available: ${available_space}GB"
    exit 1
fi

/opt/scripts/log_archive.sh
```

---

## Troubleshooting

### Issue 1: Permission Denied

**Symptom**:
```
[ERROR] Failed to create archive directory
```

**Solution**:
```bash
# Run with sudo
sudo ./log_archive.sh

# Or set proper ownership
sudo chown -R $(whoami):$(whoami) /var/log_archives
```

### Issue 2: No Logs Collected

**Symptom**:
```
[ERROR] No logs collected. Exiting.
```

**Solutions**:

1. **Check source directory exists**:
```bash
ls -la /var/log
```

2. **Verify log patterns**:
```bash
# Test if patterns match files
find /var/log -name "*.log" -type f
```

3. **Check permissions**:
```bash
# Ensure readable
sudo chmod -R +r /var/log/*.log
```

### Issue 3: Disk Space Issues

**Symptom**:
```
tar: Cannot write: No space left on device
```

**Solutions**:

1. **Check available space**:
```bash
df -h /var/log_archives
```

2. **Clean old archives manually**:
```bash
find /var/log_archives -name "*.tar.gz" -mtime +30 -delete
```

3. **Change destination to larger partition**:
```bash
./log_archive.sh -d /large_partition/archives
```

### Issue 4: Compression Command Not Found

**Symptom**:
```
[ERROR] Missing required commands: gzip
```

**Solution**:
```bash
# Install compression tools
# Ubuntu/Debian
sudo apt-get install gzip bzip2 xz-utils

# RHEL/CentOS
sudo yum install gzip bzip2 xz

# Verify installation
which gzip bzip2 xz
```

### Issue 5: Cannot Access System Logs

**Symptom**:
```
[WARNING] Not running as root. Some logs may be inaccessible.
```

**Solution**:
```bash
# Always run as root for system logs
sudo ./log_archive.sh

# Or add user to appropriate groups
sudo usermod -aG adm,syslog $(whoami)
```

---

## Verification and Testing

### Verify Archive Integrity

```bash
# Check MD5 checksum
md5sum -c /var/log_archives/server01_logs_20260103_143022.tar.gz.md5

# Extract and verify contents
tar -tzf /var/log_archives/server01_logs_20260103_143022.tar.gz | less

# Extract to temporary location
mkdir /tmp/test_extract
tar -xzf /var/log_archives/server01_logs_20260103_143022.tar.gz -C /tmp/test_extract
ls -la /tmp/test_extract
```

### Test Restoration

```bash
# Create test restore directory
sudo mkdir -p /tmp/log_restore

# Extract archive
sudo tar -xzf /var/log_archives/server01_logs_20260103_143022.tar.gz -C /tmp/log_restore

# Verify extracted files
ls -laR /tmp/log_restore

# Clean up
sudo rm -rf /tmp/log_restore
```

### Monitor Script Execution

```bash
# Watch live execution
sudo ./log_archive.sh 2>&1 | tee /tmp/archive_run.log

# Review logs
cat /var/log/log_archive.log

# Check for errors
grep ERROR /var/log/log_archive.log
```

---

## Best Practices

### 1. Regular Execution

- Set up automated cron jobs
- Monitor execution logs
- Verify archives periodically

### 2. Retention Management

```bash
# Short-term: 7-30 days (frequent access)
# Medium-term: 30-90 days (occasional access)
# Long-term: 90-365 days (compliance/audit)
```

### 3. Off-Site Backup

- Copy archives to remote storage
- Use cloud storage (S3, Azure Blob)
- Maintain multiple copies

### 4. Security

```bash
# Encrypt sensitive archives
gpg --encrypt --recipient admin@example.com archive.tar.gz

# Set restrictive permissions
chmod 600 /var/log_archives/*.tar.gz
```

### 5. Monitoring

- Set up alerts for failures
- Monitor disk space
- Track archive sizes

---

## Related Commands

```bash
# List archives by size
ls -lhS /var/log_archives/*.tar.gz

# Find archives older than 30 days
find /var/log_archives -name "*.tar.gz" -mtime +30

# Calculate total archive size
du -sh /var/log_archives

# Count number of archives
ls -1 /var/log_archives/*.tar.gz | wc -l

# View latest archive report
cat $(ls -t /var/log_archives/archive_report_*.txt | head -1)
```

---

## Summary

This script provides enterprise-grade log archiving with:

- ✅ Automated collection and compression
- ✅ Configurable retention policies  
- ✅ Integrity verification with checksums
- ✅ Detailed reporting and logging
- ✅ Easy automation via cron
- ✅ Multiple compression options

Perfect for system administrators managing production servers with comprehensive logging requirements.

---

**Version**: 1.0  
**Last Updated**: January 2026  
**License**: Open Source