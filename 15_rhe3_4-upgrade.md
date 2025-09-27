
# RHEL 7 to RHEL 8 Upgrade Guide

This document describes how to upgrade Red Hat Enterprise Linux 7 (RHEL 7) to RHEL 8 using the Leapp utility.

## Prerequisites

- Registered RHEL 7.9 system with a valid Red Hat subscription.
- Full backup of important data.
- Review of deprecated and removed features in RHEL 8.
- Root access.

## Upgrade Steps

### 1. Register and Update System

```
subscription-manager repos --enable rhel-7-server-rpms
subscription-manager repos --enable rhel-7-server-extras-rpms
yum update -y
reboot
```

### 2. Install Leapp

```
yum install leapp leapp-repository -y
```

### 3. Run Pre-upgrade Check

```
leapp preupgrade
# Review /var/log/leapp/leapp-report.txt for issues
```

### 4. Resolve Any Reported Issues

- Follow recommendations in the preupgrade report before proceeding.

### 5. Run the Upgrade

```
leapp upgrade --target 8.10
reboot
```

### 6. Post-upgrade Steps

- Verify application functionality.
- Update custom configurations.
- Remove or upgrade deprecated packages.

## Major Changes Besides Kernel

- **Kernel:** 3.10 (RHEL 7) → 4.18 (RHEL 8)
- **Package Manager:** YUM → DNF
- **AppStreams:** Multiple software versions supported.
- **Firewall:** iptables → nftables
- **Default Python:** 2.7 (RHEL 7) → 3.x (RHEL 8)



