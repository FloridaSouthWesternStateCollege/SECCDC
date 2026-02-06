#!/bin/bash
# CCDC Linux Triage & Hardening Script
# Usage: sudo ./secure_linux.sh

echo "[*] Starting CCDC Hardening..."

# 1. Backup the user list (Crucial if you break something)
cp /etc/passwd /etc/passwd.bak
cp /etc/shadow /etc/shadow.bak
echo "[+] Password files backed up to .bak"

# 2. Lock the Root Account from SSH (Forces Red Team to find another way)
if grep -q "PermitRootLogin" /etc/ssh/sshd_config; then
    sed -i 's/PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
else
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config
fi
echo "[+] SSH Root Login Disabled."

# 3. Find World-Writable Files (Common hiding spot for malware)
echo "[*] Searching for world-writable files (saving to suspicious_files.txt)..."
find / -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print > suspicious_files.txt

# 4. Check for "0" UID users (Users that secretly have root powers)
echo "[*] Checking for non-root users with UID 0 (RED ALERT if you see any)..."
awk -F: '($3 == "0") {print}' /etc/passwd

# 5. Restart SSH to apply changes
service sshd restart
echo "[+] SSH Restarted. Hardening Complete."