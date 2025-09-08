# Loops and Conditional Constructs in Scripts

## Objectives
- Run repetitive tasks with for loops.
- Inspect and use exit codes from commands and scripts.
- Test values, strings and file attributes with test operators.
- Create conditional structures with if / elif / else.

## Table of contents
- For loops
- Exit codes
- Test operators (numbers, strings, files)
- Conditional structures (if / else / elif)
- Runnable examples (scripts)
- Short exercises & answers
- Quick cheat-sheet

---

## For loops
Use for loops to iterate over lists, brace expansions, command substitution or sequences.

Syntax:
````bash
# for VARIABLE in LIST; do COMMANDS; done
for ITEM in a b c; do
  echo "$ITEM"
done
````

Examples:
````bash
# list users
for USER in $(cat /etc/passwd | cut -d: -f1); do
  echo "Found user: $USER"
done

# brace expansion
for FILE in /tmp/file{1..3}; do
  touch "$FILE"
done

# command substitution
for PID in $(pgrep bash); do
  echo "Bash process ID: $PID"
done

# sequence
for NUM in $(seq 1 5); do
  echo "Number: $NUM"
done
````

## Exit codes
Every command and script returns an exit code when it finishes. This code indicates success (0) or failure (non-zero). Use the `echo $?` command to inspect the exit code of the last run command.

Examples:
````bash
# successful command
ls /tmp
echo $?  # prints 0

# failed command
ls /nonexistent
echo $?  # prints non-zero value
````

## Test operators (numbers, strings, files)
Test operators check values, strings, and file attributes. They are often used in conditional structures.

- Numeric: `-eq`, `-ne`, `-gt`, `-lt`, `-ge`, `-le`
- String: `=`, `!=`, `-z`, `-n`
- File: `-f`, `-d`, `-r`, `-w`, `-x`, `-s`

Examples:
````bash
# numeric tests
NUM=5
if [ "$NUM" -gt 0 ]; then
  echo "Positive number"
fi

# string tests
STR="hello"
if [ -n "$STR" ]; then
  echo "String is not empty"
fi

# file tests
FILE="/etc/passwd"
if [ -f "$FILE" ]; then
  echo "File exists"
fi
````

## Conditional structures (if / else / elif)
Conditional structures control the flow of script execution. The `if` construct tests conditions and executes code blocks accordingly.

Syntax:
````bash
if CONDITION; then
  # commands if CONDITION is true
elif ANOTHER_CONDITION; then
  # commands if ANOTHER_CONDITION is true
else
  # commands if no conditions are true
fi
````

Examples:
````bash
# check if a service is active
SERVICE="httpd"
if systemctl is-active --quiet $SERVICE; then
  echo "$SERVICE is running"
else
  echo "$SERVICE is not running"
fi

# multiple conditions
NUM=10
if [ "$NUM" -lt 10 ]; then
  echo "Less than 10"
elif [ "$NUM" -eq 10 ]; then
  echo "Equal to 10"
else
  echo "Greater than 10"
fi
````

## Runnable examples (scripts)
Here are some complete scripts that you can run and test:

````bash
#!/bin/bash
# script to backup home directory
tar -czf /tmp/home_backup.tar.gz /home/$USER

# check if backup was successful
if [ $? -eq 0 ]; then
  echo "Backup succeeded"
else
  echo "Backup failed"
fi
````

````bash
#!/bin/bash
# script to monitor disk space
THRESHOLD=90
USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

if [ "$USAGE" -gt "$THRESHOLD" ]; then
  echo "Disk usage is above threshold: $USAGE%"
  # take action, e.g., send alert or clean up
else
  echo "Disk usage is normal: $USAGE%"
fi
````

## Short exercises & answers
1. **Exercise**: Write a script that prints numbers 1 to 10 using a loop.
   **Answer**:
   ````bash
   for NUM in $(seq 1 10); do
     echo "$NUM"
   done
   ````

2. **Exercise**: Create a script that checks if a directory exists, and if not, creates it.
   **Answer**:
   ````bash
   DIR="/tmp/mydir"
   if [ ! -d "$DIR" ]; then
     mkdir "$DIR"
     echo "Directory $DIR created"
   else
     echo "Directory $DIR already exists"
   fi
   ````

## Quick cheat-sheet
- **For loop**: `for ITEM in list; do commands; done`
- **If statement**: `if condition; then commands; fi`
- **If-else statement**: `if condition; then commands; else other_commands; fi`
- **If-elif-else statement**: `if condition; then commands; elif other_condition; then other_commands; else final_commands; fi`
- **Test operators**: `[ expression ]` or `[[ expression ]]`