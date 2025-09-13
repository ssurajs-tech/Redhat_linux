Access Linux File Systems
Identify File Systems and Devices
Quiz: Identify File Systems and Devices
Mount and Unmount File Systems
Guided Exercise: Mount and Unmount File Systems
Locate Files on the System
Guided Exercise: Locate Files on the System
Lab: Access Linux File Systems
Summary
Abstract


Goal	
Access, inspect, and use existing file systems on storage that is attached to a Linux server.

Objectives	
Identify a directory in the file-system hierarchy and the device where it is stored.

Access the contents of file systems by adding and removing file systems in the file-system hierarchy.

Search for files on mounted file systems with the find and locate commands.

Sections	
Identify File Systems and Devices (and Quiz)

Mount and Unmount File Systems (and Guided Exercise)

Locate Files on the System (and Guided Exercise)

Lab	
Access Linux File Systems


Identify File Systems and Devices
Objectives
Identify a directory in the file-system hierarchy and the device where it is stored.

Storage Management Concepts
Red Hat Enterprise Linux (RHEL) uses the Extents File System (XFS) as the default local file system. RHEL supports the Extended File System (ext4) file system for managing local files. Starting with RHEL 9, the Extensible File Allocation Table (exFAT) file system is supported for removable media use. In an enterprise server cluster, shared disks use the Global File System 2 (GFS2) file system to manage concurrent multi-node access.

File Systems and Mount Points
Access the contents of a file system by mounting it on an empty directory. This directory is called a mount point. When the directory is mounted, use the ls command to list its contents. Many file systems are automatically mounted when the system boots.

A mount point differs slightly from a Microsoft Windows drive letter, where each file system is a separate entity. Mount points enable multiple file system devices to be available in a single tree structure. This mount point is similar to NTFS mounted folders in Microsoft Windows.

File Systems, Storage, and Block Devices
A block device is a file that provides low-level access to storage devices. A block device must be optionally partitioned, and a file system that was created before the device can be mounted.

The /dev directory stores block device files, which RHEL creates automatically for all devices. In RHEL 9, the first detected SATA, SAS, SCSI, or USB hard drive is called the /dev/sda device; the second is the /dev/sdb device; and so on. These names represent the entire hard drive.

Table 13.1. Block Device Naming

Type of device	Device naming pattern
SATA/SAS/USB-attached storage (SCSI driver)	/dev/sda, /dev/sdb, /dev/sdc, …​
virtio-blk paravirtualized storage (VMs)	/dev/vda, /dev/vdb, /dev/vdc,…​
virtio-scsi paravirtualized storage (VMs)	/dev/sda, /dev/sdb, /dev/sdc, …​
NVMe-attached storage (SSDs)	/dev/nvme0, /dev/nvme1, …​
SD/MMC/eMMC storage (SD cards)	/dev/mmcblk0, /dev/mmcblk1, …​

Disk Partitions
Usually, the entire storage device is not created into one file system. To create a partition, divide the storage devices into smaller chunks.

With partitions, you can compartmentalize a disk: the various partitions might be formatted with different file systems or be used for other purposes. For example, one partition might contain user home directories, whereas another partition might contain system data and logs. Even when the home directory partition is loaded with data, the system partition might still have available space.

Partitions are block devices in their own right. For example, on the first SATA-attached storage, the first partition is the /dev/sda1 disk. The second partition of the same storage is the /dev/sda2 disk. The third partition on the third SATA-attached storage device is the /dev/sdc3 disk, and so on. Paravirtualized storage devices have a similar naming system. For example, the first partition on the first storage device is the /dev/vda1 disk. The second partition of the second storage device is the /dev/vdb2 disk, and so on.

An NVMe-attached SSD device names its partitions differently from a SATA-attached device. For NVMe storage devices, the nvmeX part of the name refers to the device; the nY part refers to the namespace; and the pZ part refers to the partition. For example, the first partition for the first namespace on the first disk is the /dev/nvme0n1p1 partition. The third partition for the first namespace on the second disk is the /dev/nvme1n1p3 partition, and so on.

SD or MMC cards can sometimes have a similar naming system to the SATA devices (/dev/sdN). In some cases, SD or MMC cards might have names such as /dev/mmcblk0p1, where the mmcblkX part of the name refers to the storage device, and the pY part of the name refers to the partition number on that device.

An extended listing of the /dev/sda1 device file on the host machine reveals the b file type, which stands for a block device:

[user@host ~]$ ls -l /dev/sda1
brw-rw----. 1 root disk 8, 1 Feb 22 08:00 /dev/sda1
Logical Volumes
Another way of organizing disks and partitions is with Logical Volume Management (LVM). With LVM, it is possible to aggregate block devices into a volume group. Disk space in the volume group is separated into logical volumes, which are the functional equivalent of a partition on a physical disk.

The LVM system assigns names to volume groups and logical volumes on their creation. LVM creates a directory in the /dev directory that matches the group name, and creates a symbolic link within that new directory with the same name as the logical volume. That logical volume file is then available to be mounted. For example, when a myvg volume group and the mylv logical volume are present, the full path to the logical volume is the /dev/myvg/mylv file.

Note
The previously mentioned logical volume device name establishes a symbolic link to the device file that accesses it, which might vary between boots. Another form of logical volume device name, which is linked from files in the /dev/mapper directory, is often used for symbolic links to the device file.

Examine File Systems
Use the df command to display an overview of local and remote file-system devices, which includes the total disk space, used disk space, free disk space, and the percentage of the entire disk space.

The following example displays the file systems and mount points on the host machine:

[user@host ~]$ df
Filesystem     1K-blocks    Used Available Use% Mounted on
devtmpfs          912584       0    912584   0% /dev
tmpfs             936516       0    936516   0% /dev/shm
tmpfs             936516   16812    919704   2% /run
tmpfs             936516       0    936516   0% /sys/fs/cgroup
/dev/vda3        8377344 1411332   6966012  17% /
/dev/vda1        1038336  169896    868440  17% /boot
tmpfs             187300       0    187300   0% /run/user/1000
The partitioning shows that two physical file systems are mounted on the / and /boot directories that commonly exist on virtual machines. The tmpfs and devtmpfs devices are file systems in system memory. All files that are written to the tmpfs or devtmpfs file system disappear after a system reboot.

The df command -h or -H options are human-readable options to improve the readability of the output sizes. The -h option reports in KiB (210), MiB (220), or GiB (230), whereas the -H option reports in SI units: KB (103), MB (106), or GB (109). Hard drive manufacturers usually use SI units when advertising their products.

View the file systems on the host machine with all units converted to human-readable format:

[user@host ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        892M     0  892M   0% /dev
tmpfs           915M     0  915M   0% /dev/shm
tmpfs           915M   17M  899M   2% /run
tmpfs           915M     0  915M   0% /sys/fs/cgroup
/dev/vda3       8.0G  1.4G  6.7G  17% /
/dev/vda1      1014M  166M  849M  17% /boot
tmpfs           183M     0  183M   0% /run/user/1000
Use the du command for more detailed information about a specific directory tree space. The du command -h and -H options convert the output to a human-readable format. The du command shows the size of all files in the current directory tree recursively.

View the disk usage report for the /usr/share directory on the host machine:

[root@host ~]# du /usr/share
...output omitted...
176 /usr/share/smartmontools
184 /usr/share/nano
8 /usr/share/cmake/bash-completion
8 /usr/share/cmake
356676  /usr/share
View the disk usage report in human-readable format for the /usr/share directory:

[root@host ~]# du -h /usr/share
...output omitted...
176K  /usr/share/smartmontools
184K  /usr/share/nano
8.0K  /usr/share/cmake/bash-completion
8.0K  /usr/share/cmake
369M  /usr/share