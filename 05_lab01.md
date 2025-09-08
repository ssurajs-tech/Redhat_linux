<!-- filepath: c:\Users\Suraj\Documents\GitHub\Redhat_linux\lab01.md -->
Guided Exercise: Loops and Conditional Constructs in Scripts
Use loops to efficiently print the hostname from multiple servers.

Outcomes


Create a for loop to iterate through a list of items from the command line and in a shell script.


As the student user on the workstation machine, use the lab command to prepare your system for this exercise.

This command prepares your environment and ensures that all required resources are available.

[student@workstation ~]$ lab start console-commands
Instructions

Use the ssh and hostname commands to print the hostname of the servera and serverb machines to standard output.

[student@workstation ~]$ ssh student@servera hostname
servera.lab.example.com
[student@workstation ~]$ ssh student@serverb hostname
serverb.lab.example.com
Create a for loop to execute the hostname command on the servera and serverb machines.

[student@workstation ~]$ for HOST in servera serverb
do
ssh student@${HOST} hostname
done
servera.lab.example.com
serverb.lab.example.com
Create a shell script in the /home/student/bin directory to execute the same for loop. Ensure that the script is included in the PATH environment variable.

Create the /home/student/bin directory to store the shell script, if the directory does not exist.

[student@workstation ~]$ mkdir ~/bin
Verify that the bin subdirectory of your home directory is in your PATH environment variable.

[student@workstation ~]$ echo $PATH
/home/student/.local/bin:/home/student/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/home/student/.venv/labs/bin
Create a shell script called printhostname.sh in the /home/student/bin directory to perform the for loop, and add the following content in the file.

[student@workstation ~]$ vim ~/bin/printhostname.sh
#!/usr/bin/bash
#Execute for loop to print server hostname.
for HOST in servera serverb
do
  ssh student@${HOST} hostname
done
exit 0
Give the created script executable permission.

[student@workstation ~]$ chmod +x ~/bin/printhostname.sh
Run the script from your home directory.

[student@workstation ~]$ printhostname.sh
servera.lab.example.com
serverb.lab.example.com
Verify that the exit code of your script is 0.

[student@workstation ~]$ echo $?
0
Finish

On the workstation machine, change to the student user home directory and use the lab command to complete this exercise. This step is important to ensure that resources from previous exercises do not impact upcoming exercises.

[student@workstation ~]$ lab finish console-commands