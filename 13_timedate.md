---
title: Maintain Accurate Time on Linux
---

# Maintain Accurate Time

## Objectives

Maintain accurate time synchronization with Network Time Protocol (NTP) and configure the time zone to ensure correct time stamps for events recorded by the system journal and logs.

> **Explanation:**  
> Accurate time is crucial for system logs, troubleshooting, and for services that rely on time-based authentication or scheduling. NTP ensures all systems in a network have the same time.

---

## Table of Contents

- [Administer Local Clocks and Time Zones](#administer-local-clocks-and-time-zones)
- [Listing and Setting Time Zones](#listing-and-setting-time-zones)
- [Changing the System Time](#changing-the-system-time)
- [Enabling/Disabling NTP Synchronization](#enablingdisabling-ntp-synchronization)
- [Configure and Monitor the chronyd Service](#configure-and-monitor-the-chronyd-service)
- [Guided Exercise: Maintain Accurate Time](#guided-exercise-maintain-accurate-time)
- [Analyze and Store Logs](#analyze-and-store-logs)
- [Summary](#summary)

---

## Administer Local Clocks and Time Zones

System time synchronization is critical for log file analysis across multiple systems. Also, some services might require time synchronization to work correctly. Machines use the Network Time Protocol to provide and obtain correct time information over the internet. A machine might get accurate time information from public NTP services, such as the NTP Pool Project. Another option is to sync with a high-quality hardware clock to serve accurate time to local clients.

> **Technical Jargon:**  
> - **NTP (Network Time Protocol):** A protocol for synchronizing the clocks of computer systems over packet-switched, variable-latency data networks.  
> - **NTP Pool Project:** A large cluster of time servers providing reliable easy-to-use NTP service for millions of clients.

---

## Listing and Setting Time Zones

The `timedatectl` command shows an overview of the current time-related system settings:

```shell
timedatectl
```

You can list a database of time zones:

```shell
timedatectl list-timezones
```

Use `timedatectl list-timezones | grep America` to filter for American time zones.

Use the `tzselect` command to identify the correct time zone name:

```shell
tzselect
```

To set the system time zone (as root):

```shell
timedatectl set-timezone America/Phoenix
```

To set the time zone to UTC:

```shell
timedatectl set-timezone UTC
```

---

## Changing the System Time

To change the system's current time:

```shell
timedatectl set-time 9:00:00
```

If you get "Failed to set time: Automatic time synchronization is enabled", disable NTP first:

```shell
timedatectl set-ntp false
```

---

## Enabling/Disabling NTP Synchronization

Enable or disable NTP synchronization:

```shell
timedatectl set-ntp true   # Enable
timedatectl set-ntp false  # Disable
```

> On RHEL 9, this controls the `chronyd` service.

---

## Configure and Monitor the chronyd Service

Edit `/etc/chrony.conf` to specify NTP servers:

```shell
server classroom.example.com iburst
```

Restart the chronyd service:

```shell
systemctl restart chronyd
```

Verify synchronization:

```shell
chronyc sources -v
```

---

## Guided Exercise: Maintain Accurate Time

**Change the time zone and configure NTP:**

1. Use `tzselect` to find the correct time zone.
2. Set the time zone:

    ```shell
    timedatectl set-timezone America/Port-au-Prince
    ```

3. Edit `/etc/chrony.conf` to add:

    ```shell
    server classroom.example.com iburst
    ```

4. Enable NTP:

    ```shell
    timedatectl set-ntp true
    ```

5. Verify with:

    ```shell
    timedatectl
    chronyc sources -v
    ```

---

## Analyze and Store Logs

**Change the time zone and configure log file for authentication failures:**

1. Use `tzselect` and set the time zone:

    ```shell
    sudo timedatectl set-timezone America/Jamaica
    ```

2. View logs from the last 30 minutes:

    ```shell
    journalctl --since "-30min"
    ```

3. Create `/etc/rsyslog.d/auth-errors.conf` with:

    ```
    authpriv.alert  /var/log/auth-errors
    ```

4. Restart rsyslog:

    ```shell
    sudo systemctl restart rsyslog
    ```

5. Test logging:

    ```shell
    logger -p authpriv.alert "Logging test authpriv.alert"
    sudo tail /var/log/auth-errors
    ```

---

## Summary

- Use `timedatectl` and `tzselect` to manage time zones.
- Use `chronyd` and `chronyc` for NTP time synchronization.
- Use `rsyslog` to direct specific log messages to custom files.
- Use `journalctl` to view logs from the systemd journal.