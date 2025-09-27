
***

# Secure File Transfer with `sftp`

This exercise demonstrates how to securely transfer files between systems using **SSH** and **SFTP**. Specifically, you will copy files from a remote host to a directory on the local machine while following a step-by-step process.  

***

## Table of Contents
- [Objective](#objective)  
- [Preparation](#preparation)  
- [Step 1: SSH into servera](#step-1-ssh-into-servera)  
- [Step 2: Create Local Backup Directory](#step-2-create-local-backup-directory)  
- [Step 3: Start an SFTP Session](#step-3-start-an-sftp-session)  
- [Step 4: Set the Local Directory](#step-4-set-the-local-directory)  
- [Step 5: Copy Remote Files](#step-5-copy-remote-files)  
- [Step 6: Verify Files Copied](#step-6-verify-files-copied)  
- [Step 7: Exit Back to Workstation](#step-7-exit-back-to-workstation)  
- [Step 8: Finish the Lab](#step-8-finish-the-lab)  

***

## Objective
- Copy files from a remote host to a directory on the local machine.  

***

## Preparation
As the `student` user on the `workstation` machine, prepare your system for this exercise.

```bash
[student@workstation ~]$ lab start archive-transfer
```

This command prepares your environment and ensures all required resources are available.  

***

## Step 1: SSH into `servera`

```bash
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$
```

***

## Step 2: Create Local Backup Directory

On `servera`, create a directory that will store the files fetched from `serverb`.

```bash
[student@servera ~]$ mkdir ~/serverbackup
```

***

## Step 3: Start an SFTP Session  
Use the `sftp` command to connect to `serverb` as the `root` user. Use `redhat` as the password when prompted.

```bash
[student@servera ~]$ sftp root@serverb
root@serverb's password: redhat
Connected to serverb.
sftp>
```

***

## Step 4: Set the Local Directory  
Point the SFTP session to the local backup directory created earlier.

```bash
sftp> lcd /home/student/serverbackup/
sftp> lpwd
Local working directory: /home/student/serverbackup
```

***

## Step 5: Copy Remote Files
Recursively fetch the `/etc/ssh` directory from `serverb`.

```bash
sftp> get -r /etc/ssh
Fetching /etc/ssh/ to ssh
Retrieving /etc/ssh
Retrieving /etc/ssh/sshd_config.d
50-redhat.conf                                    100%  719   881.5KB/s   00:00
Retrieving /etc/ssh/ssh_config.d
50-redhat.conf                                    100%  581   347.4KB/s   00:00
01-training.conf                                  100%   36    25.8KB/s   00:00
moduli                                            100%  565KB  71.9MB/s   00:00
ssh_config                                        100% 1921     1.1MB/s   00:00
ssh_host_rsa_key                                  100% 2602     7.2MB/s   00:00
ssh_host_rsa_key.pub                              100%  565     1.6MB/s   00:00
ssh_host_ecdsa_key                                100%  505     1.6MB/s   00:00
ssh_host_ecdsa_key.pub                            100%  173   528.6KB/s   00:00
ssh_host_ed25519_key                              100%  399     1.0MB/s   00:00
ssh_host_ed25519_key.pub                          100%   93   275.8KB/s   00:00
sshd_config                                       100% 3730    10.3MB/s   00:00
```

***

## Step 6: Verify Files Copied
Exit the `sftp` session and confirm the directory structure.

```bash
sftp> exit
[student@servera ~]$ ls -lR ~/serverbackup
```

### Output
```
/home/student/serverbackup:
total 4
drwxr-xr-x. 4 student student 4096 Mar 21 12:01 ssh

/home/student/serverbackup/ssh:
total 600
-rw-r--r--. 1 student student 578094 Mar 21 12:01 moduli
-rw-r--r--. 1 student student   1921 Mar 21 12:01 ssh_config
drwxr-xr-x. 2 student student     52 Mar 21 12:01 ssh_config.d
-rw-------. 1 student student   3730 Mar 21 12:01 sshd_config
drwx------. 2 student student     28 Mar 21 12:01 sshd_config.d
-rw-r-----. 1 student student    505 Mar 21 12:01 ssh_host_ecdsa_key
-rw-r--r--. 1 student student    173 Mar 21 12:01 ssh_host_ecdsa_key.pub
-rw-r-----. 1 student student    399 Mar 21 12:01 ssh_host_ed25519_key
-rw-r--r--. 1 student student     93 Mar 21 12:01 ssh_host_ed25519_key.pub
-rw-r-----. 1 student student   2602 Mar 21 12:01 ssh_host_rsa_key
-rw-r--r--. 1 student student    565 Mar 21 12:01 ssh_host_rsa_key.pub

/home/student/serverbackup/ssh/ssh_config.d:
total 8
-rw-r--r--. 1 student student  36 Mar 21 12:01 01-training.conf
-rw-r--r--. 1 student student 581 Mar 21 12:01 50-redhat.conf

/home/student/serverbackup/ssh/sshd_config.d:
total 4
-rw-------. 1 student student 719 Mar 21 12:01 50-redhat.conf
```

***

## Step 7: Exit Back to Workstation  

```bash
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation]$
```

***

## Step 8: Finish the Lab
Finally, clean up the resources used during the exercise.

```bash
[student@workstation ~]$ lab finish archive-transfer
```

***

✅ This exercise successfully demonstrated how to:  
- Connect to a remote system using SSH.  
- Transfer files securely between systems with SFTP.  
- Verify the file integrity and structure after copying.  
