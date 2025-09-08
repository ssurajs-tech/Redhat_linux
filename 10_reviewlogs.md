# Review Syslog Files in Red Hat Enterprise Linux

## Objectives

- Understand how syslog works in RHEL.
- Interpret events in relevant syslog files to troubleshoot problems or review system status.
- Analyze syslog configuration and log rotation.
- Practice with real-world examples and commands.

---

## 1. Introduction: What is Syslog?

Syslog is a standard protocol used by Linux and Unix systems to record system events, application logs, and security information. It provides a centralized way to collect, filter, and store log messages from the kernel and user-space programs.

**Why is syslog important?**
- Troubleshooting: Quickly identify issues by reviewing logs.
- Auditing: Track security events and system changes.
- Monitoring: Detect abnormal activity or failures.

---

## 2. Syslog Facilities and Priorities

Syslog messages are categorized by **facility** (the subsystem that produced the message) and **priority** (the severity of the message).

### Syslog Facilities

| Code | Facility   | Description                        |
|------|-----------|------------------------------------|
| 0    | kern      | Kernel messages                    |
| 1    | user      | User-level messages                |
| 2    | mail      | Mail system messages               |
| 3    | daemon    | System daemon messages             |
| 4    | auth      | Authentication/security messages   |
| 5    | syslog    | Internal syslog messages           |
| 6    | lpr       | Printer messages                   |
| 7    | news      | Network news messages              |
| 8    | uucp      | UUCP protocol messages             |
| 9    | cron      | Scheduled job (cron) messages      |
| 10   | authpriv  | Non-system authorization messages  |
| 11   | ftp       | FTP protocol messages              |
| 16-23| local0-7  | Custom local messages              |

### Syslog Priorities

| Code | Priority | Description                        |
|------|----------|------------------------------------|
| 0    | emerg    | System is unusable                 |
| 1    | alert    | Immediate action required          |
| 2    | crit     | Critical condition                 |
| 3    | err      | Error condition                    |
| 4    | warning  | Warning condition                  |
| 5    | notice   | Normal but significant event       |
| 6    | info     | Informational event                |
| 7    | debug    | Debugging-level message            |

**Diagram: Syslog Message Structure**

```
+----------------+----------------+-------------------+
|   Facility     |   Priority     |    Message        |
+----------------+----------------+-------------------+
|   authpriv     |     err        | Failed password   |
|   cron         |     info       | Job started       |
+----------------+----------------+-------------------+
```

---

## 3. Syslog Configuration and Rules

Syslog configuration files (e.g., `/etc/rsyslog.conf`, `/etc/rsyslog.d/*.conf`) define **rules** that determine where messages are stored.

**Rule Syntax:**
```
FACILITY.PRIORITY    DESTINATION
```
- `*` is a wildcard for all facilities or priorities.
- Multiple facilities or priorities can be separated by `;`.

**Example Rules:**
```conf
*.info;mail.none;authpriv.none;cron.none    /var/log/messages
authpriv.*                                  /var/log/secure
mail.*                                      -/var/log/maillog
cron.*                                      /var/log/cron
*.emerg                                     :omusrmsg:*
local7.*                                    /var/log/boot.log
```

**Explanation:**
- The first rule logs all messages of info level or higher, except mail, authpriv, and cron, to `/var/log/messages`.
- `authpriv.*` logs all authentication messages to `/var/log/secure`.
- `mail.*` logs all mail messages to `/var/log/maillog`.
- `*.emerg` sends emergency messages to all logged-in users' terminals.

**Tip:**  
The `none` keyword can be used to exclude certain facilities from a destination.

---

## 4. Log File Locations

| Log File                | Description                                      |
|-------------------------|--------------------------------------------------|
| `/var/log/messages`     | Most syslog messages (except auth, mail, cron)   |
| `/var/log/secure`       | Security/authentication events                   |
| `/var/log/maillog`      | Mail server messages                             |
| `/var/log/cron`         | Scheduled job execution                          |
| `/var/log/boot.log`     | Boot and startup messages                        |

---

## 5. Log File Rotation

Log files can grow large over time. The `logrotate` utility automatically rotates, compresses, and removes old log files to save disk space.

**How it works:**
- When a log file reaches a certain size or age, it is renamed (e.g., `/var/log/messages` → `/var/log/messages-YYYYMMDD`).
- A new log file is created.
- Old log files are compressed and eventually deleted.

**Configuration:**  
See `/etc/logrotate.conf` and `/etc/logrotate.d/` for rotation policies.

---

## 6. Analyzing Syslog Entries

A typical syslog entry looks like this:
```
Mar 20 20:11:48 localhost sshd[1433]: Failed password for student from 172.25.0.10 port 59344 ssh2
```
**Breakdown:**
- `Mar 20 20:11:48` — Timestamp
- `localhost` — Hostname
- `sshd[1433]` — Program name and PID
- `Failed password for student ...` — Message

**How to interpret:**
- Look for keywords like `Failed password`, `error`, `warning`, etc.
- Check the timestamp to correlate with reported issues.
- Identify the source program (e.g., `sshd`, `cron`, `systemd`).

---

## 7. Practical Examples

### Monitor Log Events in Real Time

```bash
sudo tail -f /var/log/secure
```
*Watch authentication events as they happen.*

### Search for Specific Events

```bash
sudo grep "Failed password" /var/log/secure
```
*Find all failed SSH login attempts.*

### Send a Test Syslog Message

```bash
logger -p local7.notice "Log entry created on host"
```
*Send a custom message to syslog for testing.*

### View Rotated Logs

```bash
ls /var/log/messages*
```
*See current and archived system logs.*

---

## 8. Troubleshooting and Best Practices

- **Check log permissions:** Some logs (like `/var/log/secure`) are readable only by root.
- **Use `less` or `grep` for large files:**  
  `sudo less /var/log/messages`  
  `sudo grep "error" /var/log/messages`
- **Automate log monitoring:** Use tools like `logwatch`, `fail2ban`, or custom scripts.
- **Rotate logs regularly:** Prevent disk space issues by ensuring `logrotate` is active.

---

## 9. Summary Table

| Task                                | Command Example                                 |
|--------------------------------------|-------------------------------------------------|
| View last 20 lines of messages       | `sudo tail -n 20 /var/log/messages`             |
| Monitor secure log in real time      | `sudo tail -f /var/log/secure`                  |
| Search for failed logins             | `sudo grep "Failed password" /var/log/secure`   |
| Send a test syslog message           | `logger -p local7.notice "Test message"`        |
| List rotated log files               | `ls /var/log/messages*`                         |

---

## 10. Further Reading

- [System Logging and Troubleshooting in Red Hat Enterprise Linux](08_logs.md)
- [rsyslog.conf(5) man page](https://man7.org/linux/man-pages/man5/rsyslog.conf.5.html)
- [Red Hat Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/)

---

**Tip:**  
Regularly review your system logs to catch issues early and maintain a secure, stable environment.