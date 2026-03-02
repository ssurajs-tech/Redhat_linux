
# Synchronize Files Between Systems Securely

This guide explains how to use the **rsync** command to efficiently and securely synchronize files and directories across local and remote systems.

***

## Table of Contents
- [Objectives](#objectives)  
- [Introduction to rsync](#introduction-to-rsync)  
- [Dry Run Mode](#dry-run-mode)  
- [Common Options](#common-options)  
- [Example Synchronizations](#example-synchronizations)  
  - [Local to Remote Synchronization](#local-to-remote-synchronization)  
  - [Remote to Local Synchronization](#remote-to-local-synchronization)  
  - [Local Synchronization](#local-synchronization)  
- [Trailing Slash Importance](#trailing-slash-importance)  
- [Additional Notes](#additional-notes)  

***

## Objectives
- Efficiently and securely synchronize the contents of a local file or directory with a remote server copy.

***

## Introduction to rsync
The **rsync** command is another way to copy files from one system to another system securely. It uses an algorithm that minimizes copied data by **synchronizing only the changed portions of files**.  

- Initial sync = same as a normal copy  
- Subsequent syncs = only differences copied ⇒ faster updates  

**Advantages:**
- Secure transfer like `sftp`  
- Faster incremental synchronizations  

***

## Dry Run Mode
You can use the **`-n`** option for a *dry run*, which simulates what `rsync` would do without making changes.

```bash
rsync -avn source/ destination/
```

This ensures you don’t overwrite or delete critical files unexpectedly.  

***

## Common Options
- **`-v` / `--verbose`** → Provides more detailed output for troubleshooting.  
- **`-a` / `--archive`** → Enables archive mode (preserves file attributes).  

### Options enabled with `rsync -a`:
| Option | Description |
|--------|-------------|
| `-r, --recursive` | Synchronize the whole directory tree recursively |
| `-l, --links` | Synchronize symbolic links |
| `-p, --perms` | Preserve permissions |
| `-t, --times` | Preserve timestamps |
| `-g, --group` | Preserve group ownership |
| `-o, --owner` | Preserve file owner |
| `-D, --devices` | Preserve device files |

- Add **`-H`** if you want to preserve *hard links*.  
- Add **`-A -X`** to preserve ACLs & SELinux file contexts.  

***

## Example Synchronizations

### Local to Remote Synchronization
Here the local `/var/log` directory is synced to `/tmp` on `hosta`.

```bash
[root@host ~]# rsync -av /var/log hosta:/tmp
root@hosta's password: password
receiving incremental file list
log/
log/README
log/boot.log
...output omitted...
sent 9,783 bytes  received 290,576 bytes  85,816.86 bytes/sec
total size is 11,585,690  speedup is 38.57
```

***

### Remote to Local Synchronization
This pulls data from `hosta:/var/log` down to the local `/tmp` directory.

```bash
[root@host ~]# rsync -av hosta:/var/log /tmp
root@hosta's password: password
receiving incremental file list
log/boot.log
log/dnf.librepo.log
log/dnf.log
...output omitted...

sent 9,783 bytes  received 290,576 bytes  85,816.86 bytes/sec
total size is 11,585,690  speedup is 38.57
```

***

### Local Synchronization
You can also use `rsync` *on the same host* to copy files locally.

```bash
[user@host ~]$ su -
Password: password
[root@host ~]# rsync -av /var/log /tmp
receiving incremental file list
log/
log/README
log/boot.log
...output omitted...
log/tuned/tuned.log

sent 11,592,423 bytes  received 779 bytes  23,186,404.00 bytes/sec
total size is 11,586,755  speedup is 1.00
[user@host ~]$ ls /tmp
log  ssh-RLjDdarkKiW1
[user@host ~]$
```

***

## Trailing Slash Importance
Correctly specifying a source directory trailing slash is critical.  

- With **slash (`/var/log/`)** → contents copied **inside** the destination  
- Without **slash (`/var/log`)** → the whole directory is created inside destination  

**Example:**

```bash
[root@host ~]# rsync -av /var/log/ /tmp
sending incremental file list
./
README
boot.log
...output omitted...
tuned/tuned.log

sent 11,592,389 bytes  received 778 bytes  23,186,334.00 bytes/sec
total size is 11,586,755  speedup is 1.00
[root@host ~]# ls /tmp
anaconda                  dnf.rpm.log-20190318  private
audit                     dnf.rpm.log-20190324  qemu-ga
boot.log                  dnf.rpm.log-20190331  README
```

***

## Additional Notes
- Use root privileges to preserve ownership when syncing.  
- Great for backups or mirroring environments.  
- Always test with a *dry run* before live operations.  

***

✅ This README demonstrates secure synchronization using **rsync**, covering both local and remote use cases, with real command examples and important notes about directory structures.  

***

