Review System Journal Entries
Objectives
Find and interpret entries in the system journal to troubleshoot problems or review system status.

Find Events on the System Journal
<!-- The systemd-journald service collects and manages logs in a binary format, making it easy to search and filter logs. -->

The systemd-journald service stores logging data in a structured, indexed binary file called a journal. This data includes extra information about the log event. For example, for syslog events, this information includes the priority of the original message and the facility, which is a value that the syslog service assigns to track the process that originated a message.

Important
In Red Hat Enterprise Linux, the memory-based /run/log directory holds the system journal by default. The contents of the /run/log directory are lost when the system is shut down. You can change the journald directory to a persistent location, which is discussed later in this chapter.

<!-- Example: To make logs persistent, edit /etc/systemd/journald.conf and set Storage=persistent, then restart systemd-journald. -->

To retrieve log messages from the journal, use the journalctl command. You can use the journalctl command to view all messages in the journal, or to search for specific events based on options and criteria. If you run the command as root, then you have full access to the journal. Although regular users can also use the journalctl command, the system restricts them from seeing certain messages.

<!-- Example: View all logs as root -->
<!--
sudo journalctl
-->

[root@host ~]# journalctl
...output omitted...
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Listening on PipeWire Multimedia System Socket.
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Starting Create User's Volatile Files and Directories...
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Listening on D-Bus User Message Bus Socket.
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Reached target Sockets.
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Finished Create User's Volatile Files and Directories.
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Reached target Basic System.
Mar 15 04:42:16 host.lab.example.com systemd[1]: Started User Manager for UID 0.
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Reached target Main User Target.
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Startup finished in 90ms.
Mar 15 04:42:16 host.lab.example.com systemd[1]: Started Session 6 of User root.
Mar 15 04:42:16 host.lab.example.com sshd[2110]: pam_unix(sshd:session): session opened for user root(uid=0) by (uid=0)
Mar 15 04:42:17 host.lab.example.com systemd[1]: Starting Hostname Service...
Mar 15 04:42:17 host.lab.example.com systemd[1]: Started Hostname Service.
lines 1951-2000/2000 (END) q

<!-- journalctl output is paged by default; press q to quit. -->

The journalctl command highlights important log messages; messages with the notice or warning priority are in bold text, whereas messages with the error priority or higher are in red text.

The key to successful use of the journal for troubleshooting and auditing is to limit journal searches to show only relevant output.

By default, the journalctl command -n option shows the last 10 log entries. You can adjust the number of log entries with an optional argument that specifies how many log entries to display. For example, to review the last five log entries, you can run the following journalctl command:

<!-- Example: Show last 5 log entries -->
<!--
journalctl -n 5
-->

[root@host ~]# journalctl -n 5
Mar 15 04:42:17 host.lab.example.com systemd[1]: Started Hostname Service.
Mar 15 04:42:47 host.lab.example.com systemd[1]: systemd-hostnamed.service: Deactivated successfully.
Mar 15 04:47:33 host.lab.example.com systemd[2127]: Created slice User Background Tasks Slice.
Mar 15 04:47:33 host.lab.example.com systemd[2127]: Starting Cleanup of User's Temporary Files and Directories...
Mar 15 04:47:33 host.lab.example.com systemd[2127]: Finished Cleanup of User's Temporary Files and Directories.

Similar to the tail command, the journalctl command -f option outputs the last 10 lines of the system journal and continues to output new journal entries when the journal appends them. To exit the journalctl command -f option, use the Ctrl+C key combination.

<!-- Example: Follow new log entries in real time -->
<!--
journalctl -f
-->

[root@host ~]# journalctl -f
Mar 15 04:47:33 host.lab.example.com systemd[2127]: Finished Cleanup of User's Temporary Files and Directories.
Mar 15 05:01:01 host.lab.example.com CROND[2197]: (root) CMD (run-parts /etc/cron.hourly)
Mar 15 05:01:01 host.lab.example.com run-parts[2200]: (/etc/cron.hourly) starting 0anacron
Mar 15 05:01:01 host.lab.example.com anacron[2208]: Anacron started on 2022-03-15
Mar 15 05:01:01 host.lab.example.com anacron[2208]: Will run job `cron.daily' in 29 min.
Mar 15 05:01:01 host.lab.example.com anacron[2208]: Will run job `cron.weekly' in 49 min.
Mar 15 05:01:01 host.lab.example.com anacron[2208]: Will run job `cron.monthly' in 69 min.
Mar 15 05:01:01 host.lab.example.com anacron[2208]: Jobs will be executed sequentially
Mar 15 05:01:01 host.lab.example.com run-parts[2210]: (/etc/cron.hourly) finished 0anacron
Mar 15 05:01:01 host.lab.example.com CROND[2196]: (root) CMDEND (run-parts /etc/cron.hourly)
​^C
[root@host ~]#

To help to troubleshoot problems, you can filter the output of the journal by the priority of the journal entries. The journalctl command -p option shows the journal entries with a specified priority level (by name or by number) or higher. The journalctl command processes the debug, info, notice, warning, err, crit, alert, and emerg priority levels, in ascending priority order.

As an example, run the following journalctl command to list journal entries with the err priority or higher:

<!-- Example: Show only error and higher priority logs -->
<!--
journalctl -p err
-->

[root@host ~]# journalctl -p err
Mar 15 04:22:00 host.lab.example.com pipewire-pulse[1640]: pw.conf: execvp error 'pactl': No such file or direct
Mar 15 04:22:17 host.lab.example.com kernel: Detected CPU family 6 model 13 stepping 3
Mar 15 04:22:17 host.lab.example.com kernel: Warning: Intel Processor - this hardware has not undergone testing by Red Hat and might not be certif>
Mar 15 04:22:20 host.lab.example.com smartd[669]: DEVICESCAN failed: glob(3) aborted matching pattern /dev/discs/disc*
Mar 15 04:22:20 host.lab.example.com smartd[669]: In the system's table of devices NO devices found to scan

You can show messages for a specified systemd unit by using the journalctl command -u option and the unit name.

<!-- Example: Show logs for sshd service -->
<!--
journalctl -u sshd.service
-->

[root@host ~]# journalctl -u sshd.service
May 15 04:30:18 host.lab.example.com systemd[1]: Starting OpenSSH server daemon...
May 15 04:30:18 host.lab.example.com sshd[1142]: Server listening on 0.0.0.0 port 22.
May 15 04:30:18 host.lab.example.com sshd[1142]: Server listening on :: port 22.
May 15 04:30:18 host.lab.example.com systemd[1]: Started OpenSSH server daemon.
May 15 04:32:03 host.lab.example.com sshd[1796]: Accepted publickey for user1 from 172.25.250.254 port 43876 ssh2: RSA SHA256:1UGy...>
May 15 04:32:03 host.lab.example.com sshd[1796]: pam_unix(sshd:session): session opened for user user1(uid=1000) by (uid=0)
May 15 04:32:26 host.lab.example.com sshd[1866]: Accepted publickey for user2 from ::1 port 36088 ssh2: RSA SHA256:M8ik...
May 15 04:32:26 host.lab.example.com sshd[1866]: pam_unix(sshd:session): session opened for user user2(uid=1001) by (uid=0)
lines 1-8/8 (END) q

When looking for specific events, you can limit the output to a specific time frame. To limit the output to a specific time range, the journalctl command has the --since option and the --until option. Both options take a time argument in the "YYYY-MM-DD hh:mm:ss" format (the double quotation marks are required to preserve the space in the option).

The journalctl command assumes that the day starts at 00:00:00 when you omit the time argument. The command assumes the current day when you omit the day argument. Both options take yesterday, today, and tomorrow as valid arguments in addition to the date and time field.

As an example, run the following journalctl command to list all journal entries from today's records:

<!-- Example: Show today's logs -->
<!--
journalctl --since today
-->

[root@host ~]# journalctl --since today
...output omitted...
Mar 15 05:04:20 host.lab.example.com systemd[1]: Started Session 8 of User student.
Mar 15 05:04:20 host.lab.example.com sshd[2255]: pam_unix(sshd:session): session opened for user student(uid=1000) by (uid=0)
Mar 15 05:04:20 host.lab.example.com systemd[1]: Starting Hostname Service...
Mar 15 05:04:20 host.lab.example.com systemd[1]: Started Hostname Service.
Mar 15 05:04:50 host.lab.example.com systemd[1]: systemd-hostnamed.service: Deactivated successfully.
Mar 15 05:06:33 host.lab.example.com systemd[2261]: Starting Mark boot as successful...
Mar 15 05:06:33 host.lab.example.com systemd[2261]: Finished Mark boot as successful.
lines 1996-2043/2043 (END) q

Run the following journalctl command to list all journal entries from 2022-03-11 20:30:00 to 2022-03-14 10:00:00:

<!-- Example: Show logs between two dates -->
<!--
journalctl --since "2022-03-11 20:30" --until "2022-03-14 10:00"
-->

[root@host ~]# journalctl --since "2022-03-11 20:30" --until "2022-03-14 10:00"
...output omitted...

You can also specify all entries since a relative time to the present. For example, to specify all entries in the last hour, you can use the following command:

<!-- Example: Show logs from the last hour -->
<!--
journalctl --since "-1 hour"
-->

[root@host ~]# journalctl --since "-1 hour"
...output omitted...

Note
You can use other, more sophisticated time specifications with the --since and --until options. For some examples, see the systemd.time(7) man page.

In addition to the visible content of the journal, you can view additional log entries if you turn on the verbose output. You can use any displayed extra field to filter the output of a journal query. The verbose output is useful to reduce the output of complex searches for certain events in the journal.

<!-- Example: Show verbose output -->
<!--
journalctl -o verbose
-->

[root@host ~]# journalctl -o verbose
Tue 2022-03-15 05:10:32.625470 EDT [s=e7623387430b4c14b2c71917db58e0ee;i...]
    _BOOT_ID=beaadd6e5c5448e393ce716cd76229d4
    _MACHINE_ID=4ec03abd2f7b40118b1b357f479b3112
    PRIORITY=6
    SYSLOG_FACILITY=3
    SYSLOG_IDENTIFIER=systemd
    _UID=0
    _GID=0
    _TRANSPORT=journal
    _CAP_EFFECTIVE=1ffffffffff
    TID=1
    CODE_FILE=src/core/job.c
    CODE_LINE=744
    CODE_FUNC=job_emit_done_message
    JOB_RESULT=done
    _PID=1
    _COMM=systemd
    _EXE=/usr/lib/systemd/systemd
    _SYSTEMD_CGROUP=/init.scope
    _SYSTEMD_UNIT=init.scope
    _SYSTEMD_SLICE=-.slice
    JOB_TYPE=stop
    MESSAGE_ID=9d1aaa27d60140bd96365438aad20286
    _HOSTNAME=host.lab.example.com
    _CMDLINE=/usr/lib/systemd/systemd --switched-root --system --deserialize 31
    _SELINUX_CONTEXT=system_u:system_r:init_t:s0
    UNIT=user-1000.slice
    MESSAGE=Removed slice User Slice of UID 1000.
    INVOCATION_ID=0e5efc1b4a6d41198f0cf02116ca8aa8
    JOB_ID=3220
    _SOURCE_REALTIME_TIMESTAMP=1647335432625470
lines 46560-46607/46607 (END) q

The following list shows some fields of the system journal that you can use to search for relevant lines to a particular process or event:

_COMM is the command name.

_EXE is the path to the executable file for the process.

_PID is the PID of the process.

_UID is the UID of the user that runs the process.

_SYSTEMD_UNIT is the systemd unit that started the process.

<!-- Example: Filter by multiple fields -->
<!--
journalctl _SYSTEMD_UNIT=sshd.service _PID=2110
-->

You can combine multiple system journal fields to form a granular search query with the journalctl command. For example, the following journalctl command shows all related journal entries to the sshd.service systemd unit from a process with PID 2110.

[root@host ~]# journalctl _SYSTEMD_UNIT=sshd.service _PID=2110
Mar 15 04:42:16 host.lab.example.com sshd[2110]: Accepted publickey for root from 172.25.250.254 port 46224 ssh2: RSA SHA256:1UGybTe52L2jzEJa1HLVKn9QUCKrTv3ZzxnMJol1Fro
Mar 15 04:42:16 host.lab.example.com sshd[2110]: pam_unix(sshd:session): session opened for user root(uid=0) by (uid=0)