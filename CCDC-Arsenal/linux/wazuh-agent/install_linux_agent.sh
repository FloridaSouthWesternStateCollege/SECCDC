#!/bin/bash
# Usage: sudo ./install_linux_agent.sh <MANAGER_IP>
MANAGER_IP=$1

if [ -z "$MANAGER_IP" ]; then
    echo "Error: You must provide the Manager IP."
    echo "Usage: ./install_linux_agent.sh 10.x.x.x"
    exit 1
fi

echo "[*] Detecting Linux OS..."
if [ -f /etc/debian_version ]; then
    echo "[+] Debian/Ubuntu detected. Installing .deb..."
    dpkg -i wazuh-ubuntu.deb
elif [ -f /etc/redhat-release ]; then
    echo "[+] CentOS/RHEL detected. Installing .rpm..."
    rpm -ivh wazuh-centos.rpm
else
    echo "[-] Unknown OS. Install manually."
    exit 1
fi

# Point to Manager and Start
echo "[*] Configuring Manager IP to $MANAGER_IP..."
sed -i "s/MANAGER_IP/$MANAGER_IP/g" /var/ossec/etc/ossec.conf
systemctl enable wazuh-agent
systemctl start wazuh-agent
echo "[+] Wazuh Agent Started!"