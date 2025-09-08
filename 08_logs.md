# System Logging and Troubleshooting in Red Hat Enterprise Linux

## Goal

Locate and accurately interpret system event logs for troubleshooting purposes.

---

## Objectives

- **Describe** the basic Red Hat Enterprise Linux logging architecture to record events.
- **Interpret** events in the relevant syslog files to troubleshoot problems or to review system status.
- **Find and interpret** entries in the system journal to troubleshoot problems or review system status.
- **Configure** the system journal to preserve the record of events when a server is rebooted.
- **Maintain accurate time synchronization** with Network Time Protocol (NTP) and configure the time zone to ensure correct time stamps for events that are recorded by the system journal and logs.

---

## Sections

- [Describe System Log Architecture (and Quiz)](#describe-system-log-architecture-and-quiz)
- [Review Syslog Files (and Guided Exercise)](#review-syslog-files-and-guided-exercise)
- [Review System Journal Entries (and Guided Exercise)](#review-system-journal-entries-and-guided-exercise)
- [Preserve the System Journal (and Guided Exercise)](#preserve-the-system-journal-and-guided-exercise)
- [Maintain Accurate Time (and Guided Exercise)](#maintain-accurate-time-and-guided-exercise)
- [Lab: Analyze and Store Logs](#lab-analyze-and-store-logs)

---

## Describe System Log Architecture (and Quiz)

### Objectives

Describe the basic Red Hat Enterprise Linux logging architecture to record events.

---

### System Logging Overview

The operating system kernel and other processes record a log of events that happen when the system is running. These logs are used to audit the system and to troubleshoot problems. You can use text utilities such as the `less` and `tail` commands to inspect these logs.

Red Hat Enterprise Linux uses a standard logging system that is based on the **syslog protocol** to log the system messages. Many programs use the logging system to record events and to organize them into log files. The `systemd-journald` and `rsyslog` services handle the syslog messages in Red Hat Enterprise Linux 9.

---

### Logging Architecture Components

- **systemd-journald**  
  The `systemd-journald` service is at the heart of the operating system event logging architecture. It collects event messages from many sources:
  - System kernel
  - Output from the early stages of the boot process
  - Standard output and standard error from daemons
  - Syslog events

  The `systemd-journald` service restructures the logs into a standard format and writes them into a structured, indexed system journal.  
  > **Note:** By default, this journal is stored on a file system that does **not** persist across reboots.

- **rsyslog**  
  The `rsyslog` service reads syslog messages that the `systemd-journald` service receives from the journal when they arrive. The `rsyslog` service then processes the syslog events, and records them to its log files or forwards them to other services according to its own configuration.

  The `rsyslog` service sorts and writes syslog messages to the log files that **do persist across reboots** in the `/var/log` directory. The service also sorts the log messages to specific log files according to the type of program that sent each message and the priority of each syslog message.

---

### Log File Locations

In addition to syslog message files, the `/var/log` directory contains log files from other services on the system. Below is a table of some useful files in the `/var/log` directory.

#### Table: Selected System Log Files

| Log file             | Type of stored messages                                                                                   |
|----------------------|----------------------------------------------------------------------------------------------------------|
| `/var/log/messages`  | Most syslog messages are logged here. Exceptions include messages about authentication and email processing, scheduled job execution, and purely debugging-related messages. |
| `/var/log/secure`    | Syslog messages about security and authentication events.                                                |
| `/var/log/maillog`   | Syslog messages about the mail server.                                                                   |
| `/var/log/cron`      | Syslog messages about scheduled job execution.                                                           |
| `/var/log/boot.log`  | Non-syslog console messages about system startup.                                                        |

---

### More Examples and Explanations

#### Example 1: Viewing the Last 20 Lines of the Main System Log

```bash
sudo tail -n 20 /var/log/messages
```
*This command helps you quickly see the most recent system events, which is useful for troubleshooting.*

#### Example 2: Watching Authentication Events in Real Time

```bash
sudo tail -f /var/log/secure
```
*This is useful for monitoring login attempts, sudo usage, and other security-related events as they happen.*

#### Example 3: Checking Cron Job Execution Logs

```bash
sudo less /var/log/cron
```
*Use this to verify if scheduled jobs ran as expected or to troubleshoot missed cron jobs.*

#### Example 4: Viewing Boot Messages

```bash
cat /var/log/boot.log
```
*This file contains messages from the system startup process, which can help diagnose boot issues.*

#### Example 5: Filtering Log Entries by Date

```bash
sudo grep "2025-09-08" /var/log/messages
```
*Finds all log entries from a specific date, which is helpful when troubleshooting incidents.*

---

### Interview Perspective: Sample Questions & Answers

**Q1: What is the difference between systemd-journald and rsyslog?**  
*A1: `systemd-journald` collects and structures log messages from various sources and stores them in the system journal (which may not persist across reboots by default). `rsyslog` reads syslog messages from journald and writes them to persistent log files in `/var/log`, sorting them by type and priority.*

**Q2: Where would you look for failed login attempts?**  
*A2: In `/var/log/secure`, which contains security and authentication-related messages.*

**Q3: How can you ensure that logs persist across reboots?**  
*A3: By configuring `systemd-journald` to use persistent storage (e.g., by creating `/var/log/journal`), and by using `rsyslog` to write logs to files in `/var/log`.*

**Q4: How do you check if a scheduled cron job ran successfully?**  
*A4: Review `/var/log/cron` for entries related to the job's execution time.*

**Q5: What command would you use to view all mail server logs?**  
*A5: `less /var/log/maillog`*

---

## Next Sections

- [Review Syslog Files (and Guided Exercise)](#review-syslog-files-and-guided-exercise)
- [Review System Journal Entries (and Guided Exercise)](#review-system-journal-entries-and-guided-exercise)
- [Preserve the System Journal (and Guided Exercise)](#preserve-the-system-journal-and-guided-exercise)
- [Maintain Accurate Time (and Guided Exercise)](#maintain-accurate-time-and-guided-exercise)
- [Lab: Analyze and Store Logs](#lab-analyze-and-store-logs)

---

*Continue to the next section for hands-on exercises and practical applications of system logging and troubleshooting in Red Hat Enterprise Linux.*

