
# Access Linux File Systems

This repository provides study material, exercises, and lab tasks to help understand and practice accessing, inspecting, and managing file systems in **Linux (RHEL-based systems)**.

***

## Goal
Access, inspect, and use existing file systems on storage that is attached to a Linux server.

***

## Objectives
- Identify directories in the file-system hierarchy and the devices where they are stored.  
- Access the contents of file systems by mounting and unmounting devices.  
- Search for files on mounted file systems using the `find` and `locate` commands.  

***

## Topics Covered

### Identify File Systems and Devices
- Understand storage management concepts.  
- Learn about **file systems**: XFS (default for RHEL), ext4, exFAT, GFS2.  
- Explore **mount points** and how they work compared to Windows drive letters.  
- Learn about **block devices** and their naming conventions under `/dev`.  
- Differentiate **disk partitions** on SATA, NVMe, virtio, and MMC storage.  
- Introduction to **Logical Volume Management (LVM)**.  

### Mount and Unmount File Systems
- Mounting: attaching a file system to an empty directory.  
- Unmounting: detaching it safely.  
- Guided exercises for mounting/unmounting devices.  

### Locate Files on the System
- Using `df` and `du` for file system storage reports.  
- Using `find` to locate files by name, path, size, or permissions.  
- Using `locate` with indexed file search for quick lookups.  

### Lab Exercises
- Practice identifying file systems and devices.  
- Mount and unmount partitions and logical volumes.  
- Search specific files across mounted file systems.  
- Explore disk usage with real examples.  

***

## Key Commands

### View Mounted File Systems
```bash
df -h
```

### Check Directory Disk Usage
```bash
du -h /path/to/directory
```

### Mount a File System
```bash
mount /dev/sdXn /mnt/mountpoint
```

### Unmount a File System
```bash
umount /mnt/mountpoint
```

### Locate Files
```bash
find / -name filename
locate filename
```

***

## Repository Structure
```
├── notes/             # Learning notes and reference material
├── exercises/         # Guided hands-on tasks
├── lab/               # Lab tasks for practice
├── quiz/              # Quiz questions for practice
└── README.md          # Project documentation
```

***

## Prerequisites
- Linux system (RHEL 8/9 or compatible).  
- Basic knowledge of Linux commands (`ls`, `cd`, `cat`).  
- Root or sudo privileges for mounting/unmounting.  

***

## Summary
By completing this module, you will be able to:  
- Identify and inspect Linux file systems.  
- Mount and unmount storage devices.  
- Search and locate files across file systems.  
- Better understand file system hierarchy, block devices, and LVM.  

***

## Abstract
This repository provides an educational resource to learn Linux file system concepts. It includes guided exercises, lab tasks, and quizzes designed to help system administrators and learners gain practical skills in storage and file system management.  

