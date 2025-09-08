# Improve Command-line Productivity with Bash Scripting

This guide will help you create a Bash script that collects and filters relevant information from multiple remote hosts, demonstrating essential command-line and scripting skills.

---

## Objectives

- Create a Bash script and redirect its output to a file.
- Use loops to simplify your code.
- Filter relevant content using `grep` and regular expressions.

---

## Prerequisites

- Access to a Linux workstation as the `student` user.
- SSH key-based authentication set up for `servera` and `serverb`.
- The `lab` command available for environment preparation and grading.

---

## Step 1: Prepare Your Environment

Run the following command to set up your environment:

```bash
lab start console-review
```

---

## Step 2: Create the Script Directory

Ensure the script directory exists:

```bash
mkdir -p ~/bin
```

---

## Step 3: Create the Bash Script

Open the script file for editing:

```bash
vim ~/bin/bash-lab
```

Insert the following initial content:

```bash
#!/usr/bin/bash
```

Make the script executable:

```bash
chmod a+x ~/bin/bash-lab
```

---

## Step 4: Script Requirements

Your script must:

- Connect to `servera` and `serverb` via SSH as `student`.
- For each server, collect and filter the following information:
    1. **Fully qualified hostname** (`hostname -f`)
    2. **CPU information** (lines starting with `CPU` from `lscpu`)
    3. **SELinux config** (non-empty, non-comment lines from `/etc/selinux/config`)
    4. **Failed SSH logins** (all "Failed password" entries from `/var/log/secure`)
- Separate each section in the output file with a line of hash signs (`#####`).
- Save the output to `/home/student/output-servera` and `/home/student/output-serverb`.

---

## Step 5: Example Script

Here is a sample script that meets the requirements:

```bash
#!/usr/bin/bash
USR='student'
OUT='/home/student/output'

for SRV in servera serverb; do
  ssh ${USR}@${SRV} "hostname -f" > ${OUT}-${SRV}
  echo "#####" >> ${OUT}-${SRV}
  ssh ${USR}@${SRV} "lscpu | grep '^CPU'" >> ${OUT}-${SRV}
  echo "#####" >> ${OUT}-${SRV}
  ssh ${USR}@${SRV} "grep -v '^$' /etc/selinux/config | grep -v '^#'" >> ${OUT}-${SRV}
  echo "#####" >> ${OUT}-${SRV}
  ssh ${USR}@${SRV} "sudo grep 'Failed password' /var/log/secure" >> ${OUT}-${SRV}
  echo "#####" >> ${OUT}-${SRV}
done
```

---

## Step 6: Run and Verify

Execute your script:

```bash
~/bin/bash-lab
```

Check the output files:

```bash
cat /home/student/output-servera
cat /home/student/output-serverb
```

Sample output:

```
servera.lab.example.com
#####
CPU op-mode(s):                  32-bit, 64-bit
CPU(s):                          2
CPU family:                      6
#####
SELINUX=enforcing
SELINUXTYPE=targeted
#####
Apr  1 05:42:07 servera sshd[1275]: Failed password for invalid user operator1 from 172.25.250.9 port 42460 ssh2
Apr  1 05:42:09 servera sshd[1277]: Failed password for invalid user sysadmin1 from 172.25.250.9 port 42462 ssh2
Apr  1 05:42:11 servera sshd[1279]: Failed password for invalid user manager1 from 172.25.250.9 port 42464 ssh2
#####
```

---

## Step 7: Grade Your Work

Run the grading command:

```bash
lab grade console-review
```

Fix any issues and rerun until successful.

---

## Step 8: Finish the Lab

When done, clean up your environment:

```bash
cd ~
lab finish console-review
```

---

## Notes

- You can use `sudo` without a password on the remote hosts.
- Use loops and command pipelines to keep your script efficient and readable.
- The number of hash signs (`#`) used as separators is arbitrary.

---

**Happy scripting!**