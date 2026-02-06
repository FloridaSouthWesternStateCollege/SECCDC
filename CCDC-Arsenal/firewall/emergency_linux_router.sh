#!/bin/bash
# CCDC EMERGENCY ROUTER SCRIPT
# Usage: sudo ./emergency_linux_router.sh <WAN_INTERFACE> <LAN_INTERFACE>
# Example: sudo ./emergency_linux_router.sh eth0 eth1

WAN=$1
LAN=$2

if [ -z "$LAN" ]; then
    echo "Usage: ./emergency_linux_router.sh <Internet_Interface> <Internal_Interface>"
    echo "Example: ./emergency_linux_router.sh ens160 ens192"
    exit 1
fi

echo "[*] TURNING THIS SERVER INTO A FIREWALL..."

# 1. Enable IP Forwarding (The core router function)
echo "1" > /proc/sys/net/ipv4/ip_forward
echo "[+] IP Forwarding Enabled."

# 2. Flush existing rules (Clean slate)
iptables -F
iptables -t nat -F

# 3. Enable NAT (Masquerading) - Allows internal team to talk to Internet
iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE
echo "[+] NAT/Masquerading Enabled on $WAN."

# 4. Basic Firewall Rules (Block Red Team Inbound, Allow Team Outbound)
# Allow traffic from Inside to Outside
iptables -A FORWARD -i $LAN -o $WAN -j ACCEPT
# Allow return traffic (Established connections)
iptables -A FORWARD -i $WAN -o $LAN -m state --state RELATED,ESTABLISHED -j ACCEPT
# BLOCK EVERYTHING ELSE
iptables -A FORWARD -j DROP

echo "[+] Firewall Rules Applied."
echo "[!] EMERGENCY MODE ACTIVE. THIS MACHINE IS NOW THE GATEWAY."