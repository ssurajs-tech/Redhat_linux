# Schedule Future Tasks in Red Hat Enterprise Linux

## Table of Contents

- [Abstract](#abstract)
- [Goals & Objectives](#goals--objectives)
- [1. Schedule a Deferred User Job](#1-schedule-a-deferred-user-job)
  - [What Are Deferred User Tasks?](#what-are-deferred-user-tasks)
  - [How to Schedule Deferred Tasks](#how-to-schedule-deferred-tasks)
  - [Inspecting and Managing Deferred Jobs](#inspecting-and-managing-deferred-jobs)
  - [Removing Scheduled Jobs](#removing-scheduled-jobs)
  - [Interview Examples](#deferred-job-interview-examples)
- [2. Schedule Recurring User Jobs](#2-schedule-recurring-user-jobs)
  - [What Are Recurring User Jobs?](#what-are-recurring-user-jobs)
  - [Crontab Command Usage](#crontab-command-usage)
  - [Crontab File Format](#crontab-file-format)
  - [Examples of Recurring Jobs](#examples-of-recurring-jobs)
  - [Interview Examples](#recurring-job-interview-examples)
- [3. Schedule Recurring System Jobs](#3-schedule-recurring-system-jobs)
  - [System-Wide Crontab](#system-wide-crontab)
  - [Anacron for Periodic Jobs](#anacron-for-periodic-jobs)
  - [Systemd Timers](#systemd-timers)
  - [Interview Examples](#system-job-interview-examples)
- [4. Manage Temporary Files](#4-manage-temporary-files)
  - [systemd-tmpfiles](#systemd-tmpfiles)
  - [Configuration File Precedence](#configuration-file-precedence)
  - [Interview Examples](#tmpfiles-interview-examples)
- [Quiz: Schedule Future Tasks](#quiz-schedule-future-tasks)
- [Summary](#summary)

---

## Abstract

This guide covers how to schedule and manage future and recurring tasks on Red Hat Enterprise Linux using tools like `at`, `cron`, `anacron`, and `systemd` timers. It also explains how to manage temporary files using `systemd-tmpfiles`.

---

## Goals & Objectives

- **Schedule tasks** to execute at a specific time and date.
- **Set up commands** to run once in the future.
- **Schedule recurring commands** using user and system crontab files.
- **Configure and manage systemd timers** for recurring and deferred jobs.
- **Manage temporary files** using systemd-tmpfiles.

---

## 1. Schedule a Deferred User Job

### What Are Deferred User Tasks?

Deferred tasks are jobs scheduled to run **once at a specific time in the future**. Examples include:

- Scheduling a maintenance script to run at midnight.
- Setting a safety job to revert firewall changes after 10 minutes.

**Tool:**  
The `at` command (provided by the `atd` daemon) is used for deferred tasks.

### How to Schedule Deferred Tasks

**Syntax:**
```bash
at TIMESPEC
# Then type your commands, end with Ctrl+D
```
Or, to schedule from a script:
```bash
at now +5min < myscript
```

**Examples:**
```bash
# Schedule a script to run at 2:00 PM today or tomorrow
at 14:00 < myscript

# Schedule a command to run in 10 minutes
echo "echo Hello World > /tmp/hello.txt" | at now +10min
```

**Time formats accepted:**
- `now +5min`
- `teatime tomorrow` (teatime = 16:00)
- `noon +4 days`
- `5pm august 3 2021`

### Inspecting and Managing Deferred Jobs

- **List jobs:**  
  ```bash
  atq
  ```
- **View job details:**  
  ```bash
  at -c JOBNUMBER
  ```
- **Remove a job:**  
  ```bash
  atrm JOBNUMBER
  ```

**Example:**
```bash
# List jobs
atq

# View job 2's commands
at -c 2

# Remove job 2
atrm 2
```

### Removing Scheduled Jobs

The `atrm JOBNUMBER` command removes a scheduled job. Remove the scheduled job when you no longer need it, for example, when a remote firewall configuration succeeded, and you do not need to reset it.

### Deferred Job Interview Examples

**Q: How would you schedule a backup script to run at 3 AM tomorrow?**  
A:
```bash
echo "/home/user/backup.sh" | at 3am tomorrow
```

**Q: How do you check which deferred jobs are scheduled for your user?**  
A:
```bash
atq
```

---

## 2. Schedule Recurring User Jobs

### What Are Recurring User Jobs?

Recurring jobs are tasks that run **repeatedly on a schedule**.  
**Tool:**  
The `crond` daemon reads user crontab files.

### Crontab Command Usage

- **List jobs:**  
  ```bash
  crontab -l
  ```
- **Edit jobs:**  
  ```bash
  crontab -e
  ```
- **Remove all jobs:**  
  ```bash
  crontab -r
  ```
- **Replace jobs from file:**  
  ```bash
  crontab filename
  ```

### Crontab File Format

Each line in a crontab file:
```
MIN HOUR DOM MON DOW COMMAND
```
- **MIN:** Minute (0-59)
- **HOUR:** Hour (0-23)
- **DOM:** Day of month (1-31)
- **MON:** Month (1-12 or Jan-Dec)
- **DOW:** Day of week (0-7 or Sun-Sat, 0/7=Sunday)
- **COMMAND:** The command to run

**Special syntax:**
- `*` = every value
- `x-y` = range
- `x,y` = list
- `*/x` = every x units

**Example:**
```bash
# Run backup at 9:00 AM on Feb 3 every year
0 9 3 2 * /usr/local/bin/yearly_backup

# Every 5 minutes between 9:00 and 16:59 on Fridays in July
*/5 9-16 * Jul 5 echo "Chime"
```

### Examples of Recurring Jobs

- **Every weekday at 11:58 PM:**
  ```bash
  58 23 * * 1-5 /usr/local/bin/daily_report
  ```
- **Send mail every weekday at 9 AM:**
  ```bash
  0 9 * * 1-5 mutt -s "Checking in" developer@example.com % Hi there, just checking in.
  ```

### Recurring Job Interview Examples

**Q: How do you schedule a script to run every Monday at 2 AM?**  
A:
```bash
0 2 * * 1 /path/to/script.sh
```

**Q: What does this crontab entry do?**
```bash
*/10 * * * * /usr/bin/cleanup.sh
```
A: Runs `/usr/bin/cleanup.sh` every 10 minutes.

---

## 3. Schedule Recurring System Jobs

### System-Wide Crontab

System jobs are managed in `/etc/crontab` or files in `/etc/cron.d/`.  
**Format:**  
```
MIN HOUR DOM MON DOW USER COMMAND
```

**Example:**
```bash
0 1 * * 0 root /usr/local/bin/weekly_maintenance.sh
```

**Hourly, daily, weekly, monthly jobs:**  
Place executable scripts in:
- `/etc/cron.hourly/`
- `/etc/cron.daily/`
- `/etc/cron.weekly/`
- `/etc/cron.monthly/`

### Anacron for Periodic Jobs

`anacron` ensures jobs run even if the system was off at the scheduled time.  
**Config file:** `/etc/anacrontab`  
**Fields:**  
```
Period  Delay  Job-identifier  Command
```
**Example:**
```
1   5   cron.daily   run-parts /etc/cron.daily
```

### Systemd Timers

Systemd timers can trigger services at specific times or intervals.

**Example timer unit:**
```ini
[Unit]
Description=Run system activity accounting tool every 2 minutes

[Timer]
OnCalendar=*:00/2

[Install]
WantedBy=sysstat.service
```

**Commands:**
```bash
systemctl daemon-reload
systemctl enable --now sysstat-collect.timer
```

### System Job Interview Examples

**Q: How do you schedule a system-wide job to run as root every Sunday at 1 AM?**  
A:
```bash
0 1 * * 0 root /usr/local/bin/weekly_maintenance.sh
```
(Place in `/etc/crontab` or `/etc/cron.d/custom`)

**Q: How do you ensure a daily job runs even if the system was off at the scheduled time?**  
A: Use `anacron` and configure `/etc/anacrontab`.

---

## 4. Manage Temporary Files

### systemd-tmpfiles

`systemd-tmpfiles` manages creation and cleanup of temporary files and directories.

**Configuration files:**
- `/usr/lib/tmpfiles.d/*.conf` (vendor)
- `/etc/tmpfiles.d/*.conf` (admin override)
- `/run/tmpfiles.d/*.conf` (runtime)

**Example config:**
```
q /tmp 1777 root root 5d
```
- `q`: create directory if missing
- `/tmp`: path
- `1777`: permissions
- `root root`: owner/group
- `5d`: clean files not accessed in 5 days

**Manual cleanup:**
```bash
systemd-tmpfiles --clean /etc/tmpfiles.d/tmp.conf
```

### Configuration File Precedence

- `/etc/tmpfiles.d/` overrides `/run/tmpfiles.d/` and `/usr/lib/tmpfiles.d/`
- Use `/etc/tmpfiles.d/` for custom or override settings

### Tmpfiles Interview Examples

**Q: How do you configure `/tmp` to be cleaned of files older than 3 days?**  
A:
1. Copy the default config:
   ```bash
   cp /usr/lib/tmpfiles.d/tmp.conf /etc/tmpfiles.d/tmp.conf
   ```
2. Edit `/etc/tmpfiles.d/tmp.conf`:
   ```
   q /tmp 1777 root root 3d
   ```
3. Test:
   ```bash
   systemd-tmpfiles --clean /etc/tmpfiles.d/tmp.conf
   ```

**Q: How do you ensure a custom directory `/run/myapp` is created with 0700 permissions and cleaned every hour?**  
A:
```
d /run/myapp 0700 root root 1h
```
(Place in `/etc/tmpfiles.d/myapp.conf`)

---

## Quiz: Schedule Future Tasks

**1. Which command displays all the user jobs that you scheduled to run as deferred jobs?**  
A. `atq`

**2. Which command removes the deferred user job with the job number 5?**  
B. `atrm 5`

**3. Which command displays all the scheduled recurring user jobs for the currently logged-in user?**  
B. `crontab -l`

**4. Which job format executes the `/usr/local/bin/daily_backup` command hourly from 9 AM to 6 PM on all days from Monday through Friday?**  
D. `00 09-18 * * Mon-Fri /usr/local/bin/daily_backup`

**5. Which directory contains the shell scripts to run daily?**  
C. `/etc/cron.daily`

**6. Which configuration file defines the settings for the system jobs that run daily, weekly, and monthly?**  
B. `/etc/anacrontab`

**7. Which systemd unit regularly triggers the cleanup of temporary files?**  
A. `systemd-tmpfiles-clean.timer`

---

## Summary

- **Deferred jobs** run once in the future (`at`).
- **Recurring user jobs** run on a schedule (`cron`).
- **Recurring system jobs** are managed via system crontab, cron directories, or systemd timers.
- **Temporary files** are managed and cleaned using `systemd-tmpfiles`.

---

**For more interview questions and hands-on labs, see the [Red Hat documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/).**


