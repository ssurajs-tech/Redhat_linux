01. How to Upgrade from RHEL 7 to RHEL 8

		Red Hat has announced the release of Red Hat Enterprise Linux 8.0, which comes with GNOME 3.28 as the default desktop environment and runs on Wayland.
		If you’re looking for a fresh RHEL 8 installation, head over to our article: Installation of RHEL 8 with Screenshots

		Requirements - In in-place upgrade to RHEL 8 is presently supported only on systems meeting the following requirements:

		RHEL 7.6 installed
		The Server variant 7 and 8
		The Intel 64 architecture
		At least 100MB of free space available on the boot partition (mounted at /boot).

	1.	Preparing an RHEL 7 For The Upgrade
		1. Make sure you are using RHEL 7.6 version, if you’re using RHEL version older than RHEL 7.6, you need to update your RHEL system to RHEL 7.6 version 
		using following yum command.

		# yum update
		Update RHEL 7 System

		Note: Make sure your RHEL 7 system has been successfully registered using the Red Hat Subscription Manager to enable system repositories and perform a full
		system update.

	2. Make sure your RHEL 7 system has the Red Hat Enterprise Linux Server subscription attached. If not, run the following commands to automatically assign the 
	   subscription to the system and verify the subscription.

		# subscription-manager attach --auto
		# subscription-manager list --installed

	3. Now set the RHEL 7.6 version as a beginning point for the upgrade using the following command.

		# subscription-manager release --set 7.6

	4. If you have used yum-plugin-versionlock plug-in to lock packages to a specific version, make sure to remove the lock by running the following command.

		# yum versionlock clear

	5. Update all software packages to the latest version and reboot the system.

		# yum update
		# reboot


	6. Once system booted, make sure to enable the Extras repository for software package dependencies.

		# subscription-manager repos --enable rhel-7-server-extras-rpms

	7. Install the Leapp utility.

		# yum install leapp

	8. Now download additional required data files, which is required by the Leapp utility for a successful upgrade from RHEL 7 to RHEL 8 and place them in the 
	  /etc/leapp/files/ directory.

		# cd /etc/leapp/files/ 
		# wget https://access.redhat.com/sites/default/files/attachments/leapp-data3.tar.gz
		# tar -xf leapp-data3.tar.gz 
		# rm leapp-data3.tar.gz

	9. Make sure to take a full RHEL 7.6 system backup, before performing the upgrade using this article: backup and restore RHEL system with the dump/restore commands.

	   If the upgrade fails, you should able to get your system to the pre-upgrade state if you follow the standard backup instructions provides in the above article.

	   Upgrading from RHEL 7 TO RHEL 8

	10. Now start the RHEL 7 system upgrade process using the following command.

		# leapp upgrade

	    Once you run the upgrade process, the Leapp utility gathers data about your system, tests the upgradability, and creates a pre-upgrade report in the 
	    /var/log/leapp/leapp-report.txt file.
	    
	    If the system is upgradable, Leapp downloads required data and create an RPM transaction for the upgrade.
	    
	    If the system is not upgradeable, Leapp closes the upgrade operation and creates a record explaining the issue and a solution in the /var/log/leapp/leapp-report.txt file.

	11. Once upgrades finish, manually reboot the system.

		# reboot
	
	
		At this stage, the system boots into an RHEL 8-based initial RAM disk image, initramfs. Leapp upgrades all software packages and automatically reboots to the 
		RHEL 8 system.

	12. Now Log in to the RHEL 8 system and change the SELinux mode to enforcing.

		# setenforce 1

	13. Enable the firewall.

		# systemctl start firewalld
		# systemctl enable firewalld
		For more information, see how to configure firewall using firewalld.
	
		Verifying RHEL 8 Upgrade

	14. After the upgrade completes, verify that the current OS version is Red Hat Enterprise Linux 8.

		# cat /etc/redhat-release
	
		Red Hat Enterprise Linux release 8.0 (Ootpa)

	15. Check the OS kernel version of Red Hat Enterprise Linux 8.

		# uname -r
	
	16. Verify that the correct Red Hat Enterprise Linux 8 is installed.

		# subscription-manager list --installed
		Check RHEL Installed Subscription
		Check RHEL Installed Subscription
		17. Optionally, set the hostname in Red Hat Enterprise Linux 8 using hostnamectl command.
	
		# hostnamectl set-hostname tecmint-rhel8
		# hostnamectl

	18. Finally, verify that network services are functional by connecting to a Red Hat Enterprise Linux 8 server using SSH.

		# ssh root@192.168.0.101
		# hostnamectl


02. How to remove files older than 7 days by creating the cron jobs to run every night ?

	crontab -e
	 0 2 * * * /bin/bash find /var/log/messages -type f -mtime +7 -exce rm -rf {} \;
	crontab -l 

03. Shows all the lines excepts any lines starting with chracter # in a file ?
	cat 1 | grep -v ^#

04. which files contains deafults valus when creating the a user with useradd command  ?

	cat /bin/bash/useraddc
	cat /etc/logindef

05. What is soft and hard links in RHEL Linux ?


	## ✅ Soft Link (Symbolic Link)
	
	A soft link is like a shortcut or pointer to another file.
	It contains the path of the target file.
	
	### Characteristics
	
	* Can link to directories and files.
	* If the original file is deleted, the soft link becomes broken.
	* Has a different inode number than the original file.
	* Can cross filesystem boundaries.
	* Size of the symlink is the length of the path it stores.
	* Created with:
	
	```bash
	ln -s <target> <linkname>
	```
	
	### Example
	
	```bash
	ln -s /opt/data/file1 /tmp/link1
	```
	
	---
	
	## ✅ Hard Link
	
	A hard link is a mirror reference to the same file (same inode).
	It points directly to the data on disk, not the file name.
	
	### Characteristics
	
	* Cannot link to directories (for safety).
	* If the original file is deleted, the hard link still works as data continues to exist.
	* Has the same inode number as the original file.
	* Cannot cross filesystem partitions.
	* Created with:
	
	```bash
	ln <target> <linkname>
	```
	
	### Example
	
	```bash
	ln /opt/data/file1 /tmp/hardlink1
	```
	
	---
	
	## 🔍 Quick Comparison Table
	
	| Feature                    | Soft Link (Symbolic) | Hard Link                    |
	| -------------------------- | -------------------- | ---------------------------- |
	| Points to                  | File name (path)     | Inode (actual data)          |
	| Inode                      | Different            | Same                         |
	| Works across filesystems   | Yes                  | No                           |
	| Broken if original deleted | Yes                  | No                           |
	| Can link to directories    | Yes                  | No                           |
	| Size                       | Small (path string)  | Same as file ( shares data ) |
	
	---
	
	## 🧠 Simple Real-Life Analogy
	
	* Soft link = Shortcut icon to a file
	* Hard link = Another name for the same file
	
	---
	
	If you want, I can also provide:
	✔ Examples with `ls -li` output
	✔ Real interview-style answer
	✔ Practical use cases in DevOps/Linux admin roles


06. what is losf how do you troubleshoot using this tool?

Here is a clean and interview-ready explanation for:

## 06. What is `lsof` and how do you troubleshoot using this tool?
	
	## ✅ What is `lsof`?
	
	`lsof` stands for List Open Files.
	In Linux/Unix, everything is a file (regular files, directories, sockets, pipes, devices).
	`lsof` shows which files are opened by which processes.
	
	It is one of the most powerful troubleshooting tools for understanding:
	
	* File-handle issues
	* Port usage
	* Process-to-file mapping
	* Network connections
	* Deleting files still holding space
	* NFS hangs
	* Application “in use” errors
	
	---
	
	## ✅ Common Troubleshooting Scenarios with `lsof`
	
	### 1. Check which process is using a port
	
	Useful when a service fails to start due to *port already in use*.
	
	```bash
	lsof -i :8080
	```
	
	Shows the PID and program using port 8080.
	
	---
	
	### 2. Find all open network connections
	
	```bash
	lsof -i
	```
	
	To see TCP only:
	
	```bash
	lsof -i tcp
	```
	
	---
	
	### 3. Identify processes using a file
	
	Useful when you get errors like:
	
	> "Device or resource busy"
	
	```bash
	lsof /path/to/file
	```
	
	---
	
	### 4. Check deleted files still occupying space
	
	Sometimes log files are deleted but the process still holds them → disk still full.
	
	```bash
	lsof | grep deleted
	```
	
	Fix by restarting the process.
	
	---
	
	### 5. Check which files are opened by a process
	
	```bash
	lsof -p <PID>
	```
	
	Useful for:
	
	* Debugging “too many open files”
	* Checking config or log file usage
	
	---
	
	### 6. Find users accessing an NFS mount
	
	```bash
	lsof /mnt/nfs
	```
	
	---
	
	### 7. Identify all open files on a filesystem
	
	```bash
	lsof /var
	```
	
	Great for knowing what processes are active on a mountpoint.
	
	---
	
	## ✔️ One-Line Interview-Ready Answer
	
	> lsof is a tool that lists all open files and their associated processes. It is used for troubleshooting issues like ports already in use, processes holding 
	  deleted files, disk space not freeing up, NFS hangs, “resource busy” errors, and identifying open network connections. Commands like `lsof -i :PORT`, `lsof | 
	  grep deleted`, and `lsof -p PID` help quickly identify the root cause.
	
	---



07. What is comand for creating user with home directory, UID,GID and shell ?
	useradd -m -d /home/username -s /bin/bash -u 9000 username
	userdel -r username

08. List basic commands of Linux ?
	ls, pwd, cd, chown, chgrp, chown, 

09. How to restore lost .pem file from os and how can u access the instance ?

	---

	# ✅ 1. Recover Access Using EC2 Instance Connect (If Supported)
	
		If your instance is Amazon Linux 2 / Ubuntu and has EC2 Instance Connect enabled, you can SSH without the .pem file.
		
		### 👉 Steps:
		
		1. Go to EC2 Console → Instances → Select your instance
		2. Click Connect
		3. Select EC2 Instance Connect
		4. Enter username:
		
		* `ec2-user` (Amazon Linux)
		* `ubuntu` (Ubuntu)
		5. Click Connect
		
		This bypasses the .pem key completely.
	
	---
	
	# ✅ 2. Replace the Lost Key Pair (BEST METHOD FOR MOST CASES)
	
		AWS allows you to replace a lost key by modifying the instance's filesystem.
		
		### 👉 Steps:
		
		### A. Stop the Instance (DO NOT TERMINATE)
		
		1. Stop the EC2 instance
		2. Detach its root volume (e.g., `/dev/xvda`)
		
		### B. Attach Root Volume to Another EC2 Instance
		
		3. Attach it as a secondary volume to a working EC2 instance
		Example: attach as `/dev/xvdf`
		
		### C. Modify the `authorized_keys` File
		
		4. Log into the helper instance
		5. Mount the volume:
		
		```bash
		sudo mkdir /mnt/temp
		sudo mount /dev/xvdf1 /mnt/temp
		```
		
		6. Go to SSH folder:
		
		```bash
		cd /mnt/temp/home/ec2-user/.ssh
		```
		
		7. Replace the old key with your NEW public key:
		
		```bash
		echo "ssh-rsa AAAA....your-new-public-key" > authorized_keys
		```
		
		8. Save & unmount:
		
		```bash
		sudo umount /mnt/temp
		```
		
		### D. Reattach Volume Back to Original Instance
		
		9. Detach from helper instance
		10. Reattach to original instance
		11. Start instance
		
		Now you can SSH using your new private key.
	
	---
	
	# ✅ 3. Use Systems Manager Session Manager (If SSM Agent is Installed)
	
		Requirements:
		✔ SSM Agent installed
		✔ Instance has IAM role with `AmazonSSMManagedInstanceCore`
		✔ Instance in subnet with Internet/NAT or VPC Endpoint
		
		### 👉 Steps:
		
		1. Go to AWS Console → Systems Manager → Session Manager
		2. Select your instance
		3. Start session (no .pem needed!)
		
		You get shell access instantly.
	
	---
	
	# ✅ 4. Use AMI Backup (If You Made One Earlier)
	
		If you have an earlier AMI:
		
		1. Launch new instance from AMI
		2. Use the correct key pair during creation
		3. Access normally
		
		---
		
		# ❌ What You CANNOT Do
		
		* You cannot download a .pem file again from AWS
		* You cannot recover the original private key
		* Without root volume access, you cannot re-add a new key
		
	---
	
	# 🟢 Recommended Strategy
	
	If your OS is Linux (Amazon Linux/Ubuntu), follow this:
	
	### Best Option: Replace Key Pair Using Volume Method (#2)
	
	Most common & guaranteed method.
	
	---
	
	If you want, I can provide:
	✔ Step-by-step commands for each OS (Amazon Linux / RHEL / Ubuntu)
	✔ A secure script to inject a new key automatically
	✔ Troubleshooting if instance doesn’t boot after re-attaching volume
	
10. /var is almost 90% full so what will be your next step ?

	# ✅ What will you do next as per ITIL framework?
	
		When `/var` is 90% full, it is treated as a Capacity Management + Incident/Problem Management scenario.
		Below is the correct ITIL-aligned workflow:
	
	---
	
	# 🟦 1. Identify & Acknowledge the Issue (Monitoring Alert)
	
		* Monitoring tool (CloudWatch, Prometheus, Nagios, ELK) sends alert for `/var` usage > 90%.
		* Acknowledge the alert and create an Incident ticket.
		
		Goal: Prevent service outage (because `/var` contains logs, spool, crash dumps, yum cache, etc.).
		
	---
	
	# 🟧 2. Initial Investigation & Impact Analysis
	
		Check what is consuming `/var`:
		
		```bash
		du -sh /var/* | sort -h
		du -sh /var/log/*
		journalctl --disk-usage
		ls -lh /var/tmp
		```
		
		Identify:
		
		* Log files
		* Application logs
		* Package cache
		* Spool directories
		* Journal logs
		* DB/cache files
		
		Document findings in the incident ticket.
	
	---
	
	# 🟥 3. Create a Change Request (CR)
	
		Since this affects multiple environments, raise a Standard Change or Normal Change depending on impact.
		
		### CR must include:
		
		* Description of the issue (`/var` space > 90%)
		* Root cause: logs/cache growing rapidly
		* Risk assessment
		* Impact: possible service downtime if not fixed
		* Rollback plan
		* Implementation plan for each environment
		
		Submit CR for CAB approval (for Prod).
	
	---
	
	# 🟩 4. Cleanup Activity (Implementation Plan)
	
		Once CR is approved, schedule maintenance window.
		
		### Cleanup steps (controlled & safe):
		
		#### ✔ Rotate and compress logs
		
		```bash
		logrotate -f /etc/logrotate.conf
		```
		
		#### ✔ Clear journal logs
		
		```bash
		journalctl --vacuum-size=500M
		```
		
		#### ✔ Remove yum cache
		
		```bash
		yum clean all
		```
		
		#### ✔ Clean old log files
		
		```bash
		find /var/log -type f -name "*.log" -size +100M
		```
		
		#### ✔ Clear temporary files
		
		```bash
		rm -rf /var/tmp/*
		```
		
		#### ✔ Application-specific cleanup
		
		If applications store data under `/var`, clean per app team approval.
		
		All steps must be documented in CR execution notes.
	
	---
	
	# 🟪 5. Validate the Fix
	
		After cleanup:
		
		```bash
		df -h /var
		```
		
		Ensure usage falls below 70% (safe threshold).
		
		Verify:
		
		* Application services are running fine
		* No orphan processes
		* No missing or deleted critical files
		
		Attach screenshots/logs to the CR.
	
	---
	
	# 🟫 6. Closure of Change Request & Incident
	
		* Update CR with results
		* Close the incident
		* Add documentation for future knowledge (KEDB)
		
	---
	
	# 🟨 7. Raise a Problem Record (If recurring)
	
		If `/var` fills frequently → deeper investigation needed.
		
		### Permanent Fix Options:
		
		* Increase `/var` partition (LVM)
		* Move logs to separate EBS volume
		* Adjust log rotation policies
		* Reduce debugging log levels
		* Add monitoring thresholds
		* Coordinate with Dev/Infra team to fix root cause
		
		Document in Problem Management.
		
	---

11. Linux server is slow due to CPU utilization how will u fix it ?

	Below is a structured, real-world, interview-ready answer for:
	“Linux server is slow due to high CPU utilization — how do you find RCA and troubleshoot?”
	
	---
	
	# ✅ 1. Confirm the Issue (Monitoring/Alert)
	
		When CPU usage is high, first verify using monitoring tools:
		
		* CloudWatch / Prometheus / Dynatrace / Nagios / Grafana
		* Collect CPU graphs over time (spikes vs constant high usage)
		
		Then log in and validate:
		
		```bash
		top
		uptime
		```
		
		Check load average vs number of vCPUs.
		
	---
	
	# ✅ 2. Identify the Process Consuming CPU
	
		### Check real-time usage:
		
		```bash
		top -o %CPU
		```
		
		### Or:
		
		```bash
		ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head
		```
		
		This shows:
		
		* Which PID
		* Which user
		* Which application is causing load
		
	---
	
	# ✅ 3. Categorize the Cause
	
		High CPU is generally caused by:
		
		### ✔ Application issue
		
		* Infinite loops
		* High traffic
		* Misbehaving code
		* Java/Python threads stuck
		
		### ✔ System-level issue
		
		* Too many processes
		* Kernel threads
		* Malware (rare)
		* Zombie processes
		
		### ✔ Environmental issue
		
		* Insufficient CPU
		* Sudden traffic surge
		* Cron jobs
		* Misconfigured services
	
	---
	
	# ✅ 4. Deep Dive (RCA)
	
		### A. CPU Steal (Virtualization issue)
		
		Check if CPU steal is high → hypervisor contention:
		
		```bash
		top (look for %st)
		```
		
		If `%st > 20%`, problem is at the VM/Cloud level → escalate to Cloud/VMware team.
		
		---
		
		### B. High system CPU (kernel or I/O wait)
		
		Check CPU breakdown:
		
		```bash
		mpstat -P ALL 1 5
		```
		
		* %usr → user processes
		* %sys → kernel issues
		* %iowait → storage bottleneck
		* %steal → hypervisor
	
	---
	
	### C. Check threads inside the process
	
		Example for Java or Tomcat:
		
		```bash
		top -H -p <PID>
		```
		
		Find the hottest thread.
		
		---
		
		### D. Get stack trace (advanced RCA)
		
		For Java:
		
		```bash
		jstack <PID>
		```
		
		For Python:
		
		```bash
		py-spy top
		```
		
		For C/C++:
		
		```bash
		pstack <PID>
		```
	
	---
	
	# ✅ 5. Quick Troubleshooting Solutions
	
		### ✔ If a single process is spiking CPU
		
		Restart service (only if allowed):
		
		```bash
		systemctl restart <service>
		```
		
		### ✔ Kill the specific process
		
		```bash
		kill -9 <PID>
		```
		
		(Be cautious — use only for safe-to-kill processes.)
		
		---
		
		### ✔ If due to log rotation or cron jobs
		
		Check recent jobs:
		
		```bash
		cat /var/log/cron
		```
	
	---
	
	### ✔ If high I/O wait
	
	Check disk:
	
	```bash
	iostat -xm 5
	iotop
	```
	
	Fix:
	
	* Move heavy jobs off peak time
	* Add faster disk (SSD)
	* Tune DB queries
	
	---
	
	### ✔ If CPU Steal is high
	
	* Migrate instance to another host
	* Increase vCPU
	* Contact cloud/VMware support
	
	---
	
	### ✔ If application bug
	
	* Check logs:
	`/var/log/messages`
	App logs
	* Analyze stack trace
	* Raise to Dev team with thread dump & CPU graphs
	
	---
	
	# 💡 Permanent Fix (Problem Management / RCA Document)
	
	RCA should include:
	
	### 1. What happened?
	
	CPU spiked to 95% on <date>.
	
	### 2. Why it happened?
	
	Example root causes:
	
	* Java thread stuck in infinite loop
	* High incoming traffic
	* DB query causing CPU load
	* Background tasks running unexpectedly
	* Cron job running multiple times
	* Instance type undersized
	
	### 3. What fixed it?
	
	* Restarted application
	* Killed rogue process
	* Optimized SQL query
	* Scheduled cron jobs
	* Increased instance type (m5.large → m5.xlarge)
	* Deployed application patch
	
	### 4. Preventive action
	
	* Added monitoring alerts
	* Set CPU limits
	* Code fix by development
	* Reconfigured cron
	* Auto-scaling enabled
	
	---
	
	# ⭐ Perfect Interview Answer (Short Version)
	
	Here is what you can say:
	
	When Linux server is slow due to high CPU, I first validate via top/uptime. Then I identify the exact process causing load using ps -eo pid,cmd,%cpu. Next, I 
	analyze whether it’s user CPU, system CPU, or I/O wait using mpstat. Based on that, I check application logs, cron jobs, and thread-level usage using top -H. 
	For Java apps, I capture jstack to find hot threads. Once root cause is identified, I take corrective action—restart service, kill runaway process, tune queries, 
	or scale CPU. If CPU steal is high, I escalate to VM/Cloud team. Finally, I document RCA and put preventive measures like log rotation, cron tuning, or autoscaling.

12.	## ❓ Question:
	
	Your application is deployed on Nginx, but when accessed from a browser or curl, it returns “Connection refused”.
	How will you troubleshoot and fix this issue?
	
	---
	
	## ✅ Answer:
	
	To fix Connection Refused on Nginx, follow a systematic troubleshooting approach:
	
	---
	
	### 1. Check if Nginx is running
	
	```
	systemctl status nginx
	```
	
	If it is stopped:
	
	```
	systemctl start nginx
	systemctl enable nginx
	```
	
	---
	
	### 2. Verify that Nginx is listening on the correct port (usually 80/443)
	
	```
	ss -tulnp | grep nginx
	```
	
	If Nginx is not listening on port 80/443, fix the server block:
	
	```
	nano /etc/nginx/nginx.conf
	```
	
	Or:
	
	```
	/etc/nginx/conf.d/app.conf
	```
	
	Ensure:
	
	```
	listen 80;
	```
	
	Reload Nginx:
	
	```
	nginx -t
	systemctl reload nginx
	```
	
	---
	
	### 3. Verify backend application (if Nginx is reverse proxying)
	
	If proxy_pass is used, check backend app:
	
	```
	systemctl status myapp
	ss -tulnp | grep <app-port>
	```
	
	Example (backend on port 3000):
	
	```
	curl http://localhost:3000
	```
	
	If backend is down → restart it.
	
	---
	
	### 4. Check firewall rules
	
	```
	firewall-cmd --list-all
	```
	
	Open the ports:
	
	```
	firewall-cmd --permanent --add-port=80/tcp
	firewall-cmd --permanent --add-port=443/tcp
	firewall-cmd --reload
	```
	
	---
	
	### 5. Check SELinux (common issue in RHEL)
	
	Verify status:
	
	```
	sestatus
	```
	
	If enforcing, allow Nginx:
	
	```
	setsebool -P httpd_can_network_connect on
	```
	
	---
	
	### 6. Verify logs for errors
	
	Nginx logs:
	
	```
	tail -f /var/log/nginx/error.log
	```
	
	System logs:
	
	```
	journalctl -u nginx -f
	```
	
	---
	
	## 📌 Common causes of “Connection Refused”
	
	| Cause                                 | Fix                                 |
	| ------------------------------------- | ----------------------------------- |
	| Nginx is down                         | Start/restart service               |
	| Wrong listen port                     | Fix `listen` directive              |
	| Backend app down                      | Start backend service               |
	| Firewall blocking                     | Open ports 80/443                   |
	| SELinux blocking outbound connections | Enable `httpd_can_network_connect`  |
	| Port conflict (Apache running)        | Stop Apache: `systemctl stop httpd` |

13. SSH to an instance stopped working ? how will u troubleshoot the issue ?

📌 Common Root Causes
Issue						Fix
SSH service stopped			Start sshd
SSH config corrupted		Fix & test sshd -t
Firewall blocking 22		Allow SSH
Security group changed		Re-add inbound rule
Wrong key/user				Correct username/key
Disk 100%					Clean logs
High CPU					Restart service, stop process
IP changed					Use updated IP

14. Find the list of files older than 7 days in /var/log folder ?

	To list files older than 7 days in the /var/log directory, use the `find` command:
	
	### Command
	
	```bash
	find /var/log -type f -mtime +7
	```
	
	### Explanation
	
	* /var/log → folder to search
	* -type f → search only files
	* -mtime +7 → files modified more than 7 days ago
	
	---
	
	### If you want detailed output (size, permissions, etc.):
	
	```bash
	find /var/log -type f -mtime +7 -ls
	```
	
	---
	
	### If you want to compress or delete such files (just examples):
	
	Compress older than 7 days:
	
	```bash
	find /var/log -type f -mtime +7 -exec gzip {} \;
	```
	
	Delete older than 30 days:
	
	```bash
	find /var/log -type f -mtime +30 -delete
	```
		
15. Find and remove the log files older that 30 days ?

	To **find and remove log files older than 30 days**, use this command:
	
	### **Command**
	
	```bash
	find /var/log -type f -mtime +30 -exec rm -f {} \;
	```
	
	### **Explanation**
	
	* **/var/log** → directory to scan
	* **-type f** → only files
	* **-mtime +30** → files older than 30 days
	* **-exec rm -f {} ;** → remove each file found
	
	---
	
	### **Safer option: first list, then delete**
	
	**List files older than 30 days:**
	
	```bash
	find /var/log -type f -mtime +30
	```
	
	If output looks correct → run the delete command.
	
	---
	
	### **If you want to delete compressed logs only (.gz):**
	
	```bash
	find /var/log -name "*.gz" -mtime +30 -delete
```



16. ## ❓ Question:

Your application writes logs to `/var/log/myapp`.
You must meet the following requirements:
* Compress logs older than 7 days
* Delete logs older than 30 days
* Automate this using a daily cron job

	### 1. Create a shell script to manage log rotation
	
		Create a script `/usr/local/bin/myapp_logrotate.sh`:
		
		```bash
		#!/bin/bash
		
		LOG_DIR="/var/log/myapp"
		
		# Compress logs older than 7 days
		find $LOG_DIR -type f -mtime +7 ! -name "*.gz" -exec gzip {} \;
		
		# Delete logs older than 30 days
		find $LOG_DIR -type f -mtime +30 -exec rm -f {} \;
		```
		
		Make it executable:
		
		```
		chmod +x /usr/local/bin/myapp_logrotate.sh
		```
		
	---
	
	### 2. Add a daily cron job
	
		Open cron:
		
		```
		crontab -e
		```
		
		Add this entry:
		
		```
		0 2 * * * /usr/local/bin/myapp_logrotate.sh
		```
		
		Explanation:
		
		* Runs at 2:00 AM every day
		* Automatically compresses 7+ day logs
		* Removes 30+ day logs
		
	---
	
	### 📌 Why this works
	
	* `find … -mtime +7` identifies files older than 7 days
	* `gzip` compresses logs
	* `rm -f` deletes older logs
	* Cron ensures automation
		
17. You are given a CSV file containing a list of users with fields such as username, password, and group.
	You need to copy this CSV file to a Linux virtual machine and create system users based on the CSV entries.
	Explain how you would perform this task and provide a sample script.

	---
	
	### ✅ Answer:
	
	Step 1: Copy the CSV file to the virtual machine
	
	If the CSV file is on your local system, you can use scp:
	
	```
	scp users.csv user@VM-IP:/tmp/
	```
	
	Example:
	
	```
	scp users.csv root@192.168.1.10:/tmp/
	```
	
	---
	
	Step 2: Prepare a sample CSV file
	
	Example: `users.csv`
	
	```
	username,password,group
	john,Pass@123,developers
	alice,Pass@123,qa
	mike,Pass@123,admins
	```
	
	---
	
	Step 3: Create a shell script to read CSV and create users
	
	Create a script `create_users.sh`:
	
	```bash
	#!/bin/bash
	
	INPUT="/tmp/users.csv"
	
	# Skip header and process each line
	tail -n +2 "$INPUT" | while IFS=',' read -r username password group
	do
		# Create group if it does not exist
		if ! getent group "$group" >/dev/null; then
			groupadd "$group"
		fi
	
		# Create user and assign group
		useradd -m -g "$group" "$username"
	
		# Set password
		echo "$username:$password" | chpasswd
	
		echo "Created user: $username in group: $group"
	done
	```
	
	---
	
	Step 4: Run the script
	
	```
	chmod +x create_users.sh
	./create_users.sh
	```
	
	---
	
	### 📌 Explanation
	
	* `tail -n +2` → skips header row in CSV
	* `IFS=','` → separates fields by comma
	* `groupadd` is used only if group doesn’t already exist
	* `useradd -m` creates home directory
	* `chpasswd` assigns the password securely

---



18. Service helath monitoring for the server using scripts 

	services=("nginx" "sshd" "docker")

	for i in ${services[@]}; do echi @i; done 

	#i/bin/bash 

	services=("nginx" "sshd" "docker")

	for i in ${services[@]}; 
	do 
		if [ systemctl is-active --quite $i; then
			echo "service is active";
		else
			echo "restart start the service "
			systemctl restart $i;
			systemctl start $i;
			
			if [ systemctl is-active --quite $i; then
				echo "service is active";
			else
				echo "service is failed to start so check logs"
			fi	
		fi;
	done 
	
	
19. Find and remove file over a 100 MB

	find /var/log -type f -size +100MB -exec rm -i {} \;
	find /var/log -type f -size +100MB -exec ls -ltrh {} \;	
	
20. Get list of users who logged in today ?

	last -F
	last -F | grep "$date +%b %e"
	last -F | grep "$date "
	
21. Website does not load how will u investigate ?

	1. web server is running or not - systemctl status web_server
	2. look at the log file /var/log/file
	3. html and index.yml
	4. Website is not accessible issue is with the backend whether it is in a proper location or not. 
	5. Check the port number as well 
	

22. How to remove first and last line of the file ?

	To remove the first and last line of a file in RHEL (Red Hat Enterprise Linux), you can use several command-line tools like `sed`, `awk`, or `head/tail`.
	
	# ✅ Method 1: Using `sed` (recommended)
	
		### Remove first line → `1d`
		
		### Remove last line → `$d`
		
		```
		sed '1d;$d' input.txt > output.txt
		```
		
		Explanation:
		
		* `1d` → deletes the first line
		* `$d` → deletes the last line
		* Output is redirected to a new file `output.txt`
		
		If you want to edit the file in place:
		
		```
		sed -i '1d;$d' input.txt
		```
	
	---
	
	# ✅ Method 2: Using `awk`
	
		```
		awk 'NR > 1 { buf[NR-1] = $0 } 
			END { for (i = 2; i < NR; i++) print buf[i] }' input.txt > output.txt
		```
		
		Simpler version (if file is not huge):
		
		```
		awk 'NR!=1 { a[NR]=$0 } END { for(i=2;i<NR;i++) print a[i] }' input.txt
		```
	
	---
	
	# ✅ Method 3: Using `tail` + `head`
	
		### Remove the first line using `tail`
		
		### Remove the last line using `head`
		
		```
		tail -n +2 input.txt | head -n -1 > output.txt
		```
		
		Explanation:
		
		* `tail -n +2` → prints starting from line 2 (skips first line)
		* `head -n -1` → prints all except last line
	
	---
	
	# 📌 Which method should you use?
	
		| Method        | Best For                              |
		| ------------- | ------------------------------------- |
		| `sed`         | Small & large files, simple & fastest |
		| `awk`         | When doing complex processing         |
		| `tail + head` | Quick one-liner for readable logic    |
	
	---
	
	Q. If you want, I can also show you how to remove:
		
		* First N lines
		* Last N lines
		* Only last line
		* Only first line
		* Multiple lines at specific positions
	
23. What are the differnence types of variable in the linux ?

	In Linux we have local variables, environment variables, shell variables, read-only/constant variables, and array variables.
	Along with them, Bash provides special variables like $?, $0, $1-$9, $#, $@, $$, $! used for argument handling, process IDs, and script status.

24. Difference between kill and kill -9 

	kill sends SIGTERM which allows a process to shut down gracefully, whereas kill -9 sends SIGKILL which immediately terminates the process without cleanup.
	kill is safe and preferred; kill -9 should be the last option when the process is hung or unresponsive.
