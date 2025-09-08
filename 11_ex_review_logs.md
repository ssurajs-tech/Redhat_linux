# Exercise: Review and Redirect Syslog Debug Messages

This exercise demonstrates how to configure the `rsyslog` service in Red Hat Enterprise Linux to write all log messages with the `debug` priority to a dedicated log file. You will also learn how to verify the configuration and understand the technical concepts involved.

---

## Objectives

- Configure `rsyslog` to log all messages with the `debug` priority (or higher) to `/var/log/messages-debug`.
- Understand syslog priorities and facilities.
- Practice generating and verifying debug log messages.

---

## Step 1: Prepare the Lab Environment

On your **workstation** machine, run the following command to set up the lab environment:

```bash
lab start logs-syslog
```
**Explanation:**  
The `lab` command is a utility provided in Red Hat training environments to prepare your system for specific exercises. It ensures all required resources and configurations are in place.

---

## Step 2: Connect to the Target Server

SSH into the `servera` machine as the `student` user, then switch to the `root` user:

```bash
ssh student@servera
sudo -i
```
**Explanation:**  
- `ssh student@servera` connects you to the remote server.
- `sudo -i` gives you a root shell, which is necessary for editing system configuration files.

---

## Step 3: Configure rsyslog for Debug Logging

Create a new configuration file `/etc/rsyslog.d/debug.conf` with the following content:

```conf
*.debug    /var/log/messages-debug
```
**Explanation:**  
- `*` (wildcard) in the facility field means "all facilities" (e.g., kernel, user, daemon, etc.).
- `.debug` means "debug priority or higher" (debug is the lowest, so this includes all priorities).
- `/var/log/messages-debug` is the destination file for these messages.

**Technical Concept:**  
Syslog priorities (from highest to lowest): `emerg`, `alert`, `crit`, `err`, `warning`, `notice`, `info`, `debug`.  
A rule like `*.debug` captures all messages, since `debug` is the lowest priority.

---

## Step 4: Restart the rsyslog Service

Apply your changes by restarting the `rsyslog` service:

```bash
systemctl restart rsyslog
```
**Explanation:**  
This command restarts the logging service so it reads the new configuration.

---

## Step 5: Generate a Debug Log Message

Send a test message with the `user` facility and `debug` priority:

```bash
logger -p user.debug "Debug Message Test"
```
**Explanation:**  
- `logger` is a command-line tool to create syslog messages.
- `-p user.debug` sets the facility to `user` and the priority to `debug`.
- The message `"Debug Message Test"` will be logged according to your new rule.

---

## Step 6: Verify the Log File

Check the last 10 lines of your new debug log file:

```bash
tail /var/log/messages-debug
```
**Explanation:**  
- `tail` displays the last lines of a file.
- You should see your test message, along with other debug-level messages.

**Sample Output:**
```
Feb 13 18:27:58 servera root[25416]: Debug Message Test
```

---

## Step 7: Clean Up

Exit from the server and finish the lab:

```bash
exit    # Exit root shell
exit    # Exit SSH session
lab finish logs-syslog
```
**Explanation:**  
- `exit` closes your root shell and SSH session.
- `lab finish logs-syslog` cleans up the lab environment to avoid conflicts with future exercises.

---

## Technical Concepts Explained

- **Syslog Facility:** Identifies the source of the log message (e.g., `auth`, `cron`, `user`).
- **Syslog Priority:** Indicates the severity of the message (`debug` is the least severe).
- **rsyslog Configuration:** Files in `/etc/rsyslog.d/` are included by default, allowing modular configuration.
- **logger Command:** Useful for testing syslog configurations by generating custom log entries.

---

## Summary Table

| Task                                   | Command/Action                                 |
|-----------------------------------------|------------------------------------------------|
| Prepare lab environment                 | `lab start logs-syslog`                        |
| SSH to servera and become root          | `ssh student@servera` → `sudo -i`              |
| Configure debug logging                 | `echo '*.debug /var/log/messages-debug' > /etc/rsyslog.d/debug.conf` |
| Restart rsyslog                         | `systemctl restart rsyslog`                    |
| Generate debug log message              | `logger -p user.debug "Debug Message Test"`     |
| View debug log file                     | `tail /var/log/messages-debug`                 |
| Clean up lab                            | `lab finish logs-syslog`                       |

---

**Tip:**  
Redirecting specific priorities to dedicated log files helps with targeted troubleshooting and log management.