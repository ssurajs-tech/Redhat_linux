

# Access Linux File Systems

This repository provides learning resources, exercises, and lab materials for working with Linux file systems, devices, partitions, and mount points. The goal is to understand how Linux organizes and accesses storage, and how administrators can manage and troubleshoot file system usage.

***

## Table of Contents
- [Goal](#goal)  
- [Objectives](#objectives)  
- [Sections](#sections)  
- [Identify File Systems and Devices](#identify-file-systems-and-devices)  
- [Storage Management Concepts](#storage-management-concepts)  
- [File Systems and Mount Points](#file-systems-and-mount-points)  
- [File Systems, Storage, and Block Devices](#file-systems-storage-and-block-devices)  
- [Disk Partitions](#disk-partitions)  
- [Logical Volumes](#logical-volumes)  
- [Examine File Systems](#examine-file-systems)  
- [Useful Commands](#useful-commands)  

***

## Goal
Access, inspect, and use existing file systems on storage that is attached to a Linux server.

***

## Objectives
- Identify a directory in the file-system hierarchy and the device where it is stored.  
- Access the contents of file systems by adding and removing file systems in the file-system hierarchy.  
- Search for files on mounted file systems with the `find` and `locate` commands.  

***

## Sections
- Identify File Systems and Devices (and Quiz)  
- Mount and Unmount File Systems (and Guided Exercise)  
- Locate Files on the System (and Guided Exercise)  
- Lab: Access Linux File Systems  

***

## Identify File Systems and Devices

### Objectives
Identify a directory in the file-system hierarchy and the device where it is stored.

***

## Storage Management Concepts
Red Hat Enterprise Linux (RHEL) uses the **Extents File System (XFS)** as the default local file system. RHEL supports the **Extended File System (ext4)** file system for managing local files. Starting with RHEL 9, the **Extensible File Allocation Table (exFAT)** file system is supported for removable media use. In an enterprise server cluster, shared disks use the **Global File System 2 (GFS2)** file system to manage concurrent multi-node access.

***

## File Systems and Mount Points
Access the contents of a file system by mounting it on an empty directory. This directory is called a **mount point**. When the directory is mounted, use the `ls` command to list its contents. Many file systems are automatically mounted when the system boots.

A mount point differs slightly from a Microsoft Windows drive letter, where each file system is a separate entity. Mount points enable multiple file system devices to be available in a single tree structure. This mount point is similar to NTFS mounted folders in Microsoft Windows.

***

## File Systems, Storage, and Block Devices
A **block device** is a file that provides low-level access to storage devices.  
A block device must be optionally partitioned, and a file system must be created before the device can be mounted.

The `/dev` directory stores block device files, which RHEL creates automatically for all devices. In RHEL 9:  

- The first detected SATA, SAS, SCSI, or USB hard drive is called `/dev/sda`, the second `/dev/sdb`, and so on.  
- These names represent the entire hard drive.  

### Block Device Naming  
| Type of device | Device naming pattern |
|----------------|------------------------|
| SATA/SAS/USB-attached storage (SCSI driver) | `/dev/sda, /dev/sdb, /dev/sdc, …` |
| virtio-blk paravirtualized storage (VMs) | `/dev/vda, /dev/vdb, /dev/vdc, …` |
| virtio-scsi paravirtualized storage (VMs) | `/dev/sda, /dev/sdb, /dev/sdc, …` |
| NVMe-attached storage (SSDs) | `/dev/nvme0, /dev/nvme1, …` |
| SD/MMC/eMMC storage (SD cards) | `/dev/mmcblk0, /dev/mmcblk1, …` |

***

## Disk Partitions
Usually, the entire storage device is not created into one file system. To create a partition, divide the storage devices into smaller chunks.

- With partitions, you can compartmentalize a disk:  
  - one partition for user home directories  
  - another for system data and logs  

- Example partition names:  
  - `/dev/sda1` → first partition on first SATA drive  
  - `/dev/sdc3` → third partition on third SATA drive  
  - `/dev/vda1` → first partition on first virtual device  
  - `/dev/nvme0n1p1` → first partition of the first namespace on the first NVMe disk  

An extended listing of `/dev/sda1` reveals it as a block device (`b` file type):

```bash
[user@host ~]$ ls -l /dev/sda1
brw-rw----. 1 root disk 8, 1 Feb 22 08:00 /dev/sda1
```

***

## Logical Volumes
Another way of organizing disks and partitions is with **Logical Volume Management (LVM)**.  

- Aggregate block devices into a **volume group (VG)**.  
- Create **logical volumes (LVs)** that act like partitions.  

Example:  

```bash
/dev/myvg/mylv
```

This path is symbolic to the actual mapped device under `/dev/mapper`.  

***

## Examine File Systems
To display an overview of mounted file systems, use `df`.

### Example:
```bash
[user@host ~]$ df
Filesystem     1K-blocks    Used Available Use% Mounted on
devtmpfs          912584       0    912584   0% /dev
tmpfs             936516       0    936516   0% /dev/shm
tmpfs             936516   16812    919704   2% /run
tmpfs             936516       0    936516   0% /sys/fs/cgroup
/dev/vda3        8377344 1411332   6966012  17% /
/dev/vda1        1038336  169896    868440  17% /boot
tmpfs             187300       0    187300   0% /run/user/1000
```

### Human-readable format:
```bash
[user@host ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        892M     0  892M   0% /dev
tmpfs           915M     0  915M   0% /dev/shm
tmpfs           915M   17M  899M   2% /run
tmpfs           915M     0  915M   0% /sys/fs/cgroup
/dev/vda3       8.0G  1.4G  6.7G  17% /
/dev/vda1      1014M  166M  849M  17% /boot
tmpfs           183M     0  183M   0% /run/user/1000
```

### Disk Usage with `du`
```bash
[root@host ~]# du /usr/share
176  /usr/share/smartmontools
184  /usr/share/nano
8    /usr/share/cmake/bash-completion
8    /usr/share/cmake
356676  /usr/share
```

Human-readable:
```bash
[root@host ~]# du -h /usr/share
176K  /usr/share/smartmontools
184K  /usr/share/nano
8.0K  /usr/share/cmake/bash-completion
8.0K  /usr/share/cmake
369M  /usr/share
```

***

## Useful Commands
- Check mounted file systems:  
  ```bash
  df -h
  ```
- Check space used by a directory:  
  ```bash
  du -h /usr/share
  ```
- Mount a partition:  
  ```bash
  mount /dev/sda1 /mnt
  ```
- Unmount:  
  ```bash
  umount /mnt
  ```

***

## Additional Information
- Temporary filesystems like **tmpfs** and **devtmpfs** store data in memory and are cleared after reboot.  
- **Hard drive sizes** differ in SI units (used by vendors) vs binary units (used by Linux).  
- **Mount points** allow multiple file systems to be merged into a unified directory tree structure.  

