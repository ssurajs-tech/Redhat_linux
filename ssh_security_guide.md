# SSH Configuration and Security Guide

A comprehensive guide to configuring and securing SSH (Secure Shell) access on Linux systems using key-based authentication.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Key Concepts](#key-concepts)
- [Step-by-Step Implementation](#step-by-step-implementation)
- [Security Best Practices](#security-best-practices)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)

---

## Overview

This guide demonstrates how to implement three critical SSH security measures:

1. **SSH Key-Based Authentication** - Replace password authentication with cryptographic keys
2. **Disable Root Login** - Prevent direct root access over SSH
3. **Disable Password Authentication** - Force all users to use SSH keys

### Learning Objectives

By following this guide, you will:
- Generate and deploy SSH key pairs
- Configure the OpenSSH server for enhanced security
- Understand the difference between public and private keys
- Test and verify secure SSH configurations

---

## Prerequisites

### Environment Setup

- **Source Server**: `servera` (where you'll generate keys)
- **Target Server**: `serverb` (where you'll configure SSH security)
- **User Account**: `production1` on both servers
- **Administrative Access**: Root password (`redhat` in this example)

### Required Tools

- OpenSSH client (`ssh`, `ssh-keygen`, `ssh-copy-id`)
- OpenSSH server (`sshd`)
- Text editor (`vi`, `vim`, or `nano`)
- Administrative privileges

---

## Key Concepts

### What is SSH Key Authentication?

SSH keys provide a more secure authentication method than passwords:

- **Private Key**: Kept secret on your local machine (like a physical key)
- **Public Key**: Copied to remote servers (like a lock)
- **Authentication**: The server verifies you possess the matching private key

### Why Disable Root Login?

Direct root login over SSH poses security risks:
- Attackers know the username (`root`) exists on all systems
- Brute-force attacks only need to guess the password
- No audit trail of who performed administrative actions

**Best Practice**: Log in as a regular user, then escalate privileges with `sudo` or `su`

### Why Disable Password Authentication?

Password-based authentication is vulnerable to:
- Brute-force attacks
- Dictionary attacks
- Password reuse across systems
- Keylogging and shoulder surfing

SSH keys eliminate these vulnerabilities through cryptographic authentication.

---

## Step-by-Step Implementation

### Phase 1: Generate SSH Keys

#### 1.1 Switch to the Target User

```bash
[student@servera ~]$ su - production1
Password: redhat
[production1@servera ~]$
```

**Explanation**: Switch to the user account that needs SSH key authentication.

#### 1.2 Generate SSH Key Pair

```bash
[production1@servera ~]$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/production1/.ssh/id_rsa): [Press Enter]
Created directory '/home/production1/.ssh'.
Enter passphrase (empty for no passphrase): [Press Enter]
Enter same passphrase again: [Press Enter]
Your identification has been saved in /home/production1/.ssh/id_rsa.
Your public key has been saved in /home/production1/.ssh/id_rsa.pub.
```

**Key Points**:
- Default location: `~/.ssh/id_rsa` (private) and `~/.ssh/id_rsa.pub` (public)
- Passphrase: Optional additional security layer (left empty in this example)
- Key type: RSA 3072-bit (default in modern systems)

**Files Created**:
```
~/.ssh/id_rsa       # Private key (NEVER share this)
~/.ssh/id_rsa.pub   # Public key (safe to share)
```

---

### Phase 2: Deploy Public Key to Remote Server

#### 2.1 Copy Public Key to Target Server

```bash
[production1@servera ~]$ ssh-copy-id production1@serverb
```

**What happens**:
1. Reads your public key from `~/.ssh/id_rsa.pub`
2. Connects to `serverb` (requires password this first time)
3. Appends your public key to `~/.ssh/authorized_keys` on `serverb`
4. Sets correct permissions on remote files

**Interactive Prompts**:
```bash
The authenticity of host 'serverb (172.25.250.11)' can't be established.
ED25519 key fingerprint is SHA256:h/hEJa/anxp6AP7BmB5azIPVbPNqieh0oKi4KWOTK80.
Are you sure you want to continue connecting (yes/no)? yes

production1@serverb's password: redhat
Number of key(s) added: 1
```

#### 2.2 Verify Key-Based Login

```bash
[production1@servera ~]$ ssh production1@serverb
[production1@serverb ~]$
```

**Success**: You should log in without entering a password!

---

### Phase 3: Disable Root SSH Login

#### 3.1 Access Root Account on Target Server

```bash
[production1@serverb ~]$ su -
Password: redhat
[root@serverb ~]#
```

#### 3.2 Edit SSH Configuration

```bash
[root@serverb ~]# vi /etc/ssh/sshd_config
```

**Find and modify this line**:
```
# Before
#PermitRootLogin yes

# After
PermitRootLogin no
```

**Important**: 
- Edit the **active uncommented line**, not commented examples
- Lines starting with `#` are comments or defaults

#### 3.3 Reload SSH Service

```bash
[root@serverb ~]# systemctl reload sshd.service
```

**Why `reload` instead of `restart`?**
- `reload`: Applies configuration changes without disconnecting existing sessions
- `restart`: Would disconnect all current SSH connections

#### 3.4 Test Root Login Prevention

From another terminal:

```bash
[production1@servera ~]$ ssh root@serverb
root@serverb's password: redhat
Permission denied, please try again.
root@serverb: Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password).
```

**Expected Result**: Root login should fail even with correct password

---

### Phase 4: Disable Password Authentication

#### 4.1 Edit SSH Configuration Again

```bash
[root@serverb ~]# vi /etc/ssh/sshd_config
```

**Find and modify**:
```
# Before
#PasswordAuthentication yes

# After
PasswordAuthentication no
```

#### 4.2 Reload SSH Service

```bash
[root@serverb ~]# systemctl reload sshd
```

#### 4.3 Verify Public Key Authentication is Enabled

```bash
[root@serverb ~]# grep PubkeyAuthentication /etc/ssh/sshd_config
#PubkeyAuthentication yes
```

**Note**: The `#` indicates this is the default value. Public key authentication is enabled by default.

#### 4.4 Test Password Authentication Prevention

Try logging in as a user **without** SSH keys configured:

```bash
[production1@servera ~]$ ssh production2@serverb
production2@serverb: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
```

**Expected Result**: Connection fails because `production2` has no SSH keys

#### 4.5 Verify Key-Based Login Still Works

```bash
[production1@servera ~]$ ssh production1@serverb
[production1@serverb ~]$
```

**Expected Result**: `production1` can still log in using SSH keys

---

## Security Best Practices

### SSH Configuration Hardening

Add these additional settings to `/etc/ssh/sshd_config`:

```bash
# Limit authentication attempts
MaxAuthTries 3

# Disconnect idle sessions
ClientAliveInterval 300
ClientAliveCountMax 2

# Disable empty passwords
PermitEmptyPasswords no

# Use only strong ciphers
Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com

# Limit users who can SSH
AllowUsers production1 production2

# Change default port (security through obscurity)
Port 2222
```

### File Permissions

Correct permissions are critical for SSH security:

```bash
# On client (servera)
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

# On server (serverb)
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### Using SSH Key Passphrases

For production systems, consider adding a passphrase to your SSH key:

```bash
ssh-keygen -p -f ~/.ssh/id_rsa
```

**Benefits**:
- Additional security if private key is stolen
- Can use `ssh-agent` to cache passphrase during session

### Key Management

- **Rotate keys regularly**: Generate new keys periodically
- **Use different keys**: Separate keys for different purposes/servers
- **Audit authorized_keys**: Regularly review `~/.ssh/authorized_keys`
- **Remove old keys**: Delete unused public keys from servers

---

## Troubleshooting

### Common Issues and Solutions

#### Issue: "Permission denied (publickey)"

**Possible Causes**:
1. Public key not copied to server
2. Incorrect file permissions
3. Wrong username

**Solutions**:
```bash
# Re-copy public key
ssh-copy-id user@server

# Check permissions
ls -la ~/.ssh/

# Verify authorized_keys on server
ssh user@server "cat ~/.ssh/authorized_keys"
```

#### Issue: "Host key verification failed"

**Cause**: Server's host key changed (security warning!)

**Solution** (if legitimate):
```bash
ssh-keygen -R serverb
```

#### Issue: Still prompted for password after key setup

**Debugging steps**:
```bash
# Connect with verbose output
ssh -v user@server

# Check SSH daemon logs on server
sudo tail -f /var/log/secure

# Verify sshd_config syntax
sudo sshd -t
```

### Testing Authentication Methods

Force specific authentication methods:

```bash
# Test only public key authentication
ssh -o PubkeyAuthentication=yes -o PasswordAuthentication=no user@server

# Test only password authentication
ssh -o PubkeyAuthentication=no -o PasswordAuthentication=yes user@server
```

---

## Additional Resources

### Official Documentation

- [OpenSSH Manual Pages](https://www.openssh.com/manual.html)
- [SSH.com Guide](https://www.ssh.com/academy/ssh)
- Red Hat: [Using SSH Key-Based Authentication](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_using-secure-communications-between-two-systems-with-openssh_configuring-basic-system-settings)

### Related Topics

- **SSH Agent**: Cache passphrases for convenience
- **SSH Tunneling**: Port forwarding and proxying
- **SSHFS**: Mount remote filesystems over SSH
- **Fail2ban**: Automatic IP blocking after failed attempts
- **Two-Factor Authentication**: Add TOTP to SSH

### Quick Reference Commands

```bash
# Generate SSH key
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Copy public key to server
ssh-copy-id user@server

# Connect to server
ssh user@server

# Copy files securely
scp file.txt user@server:/path/
rsync -avz -e ssh /local/path/ user@server:/remote/path/

# Test SSH configuration
sudo sshd -t

# Reload SSH service
sudo systemctl reload sshd
```

---

## Summary

You've successfully implemented three critical SSH security measures:

✅ **SSH Key Authentication**: Cryptographic keys replace passwords  
✅ **Disabled Root Login**: Prevents direct root access attacks  
✅ **Disabled Password Auth**: Forces all users to use SSH keys

These configurations significantly improve your server's security posture by eliminating password-based vulnerabilities and reducing the attack surface for remote access.

---

**License**: This guide is provided for educational purposes.  
**Last Updated**: January 2026