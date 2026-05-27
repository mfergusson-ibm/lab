#!/bin/sh
#
# SNMP Configuration Script for Linux hosts (BusyBox compatible)
# Community: SevOne
#

# Check if running in BusyBox environment
if command -v apk > /dev/null 2>&1; then
    # Alpine/BusyBox - install net-snmp
    apk add --no-cache net-snmp net-snmp-tools 2>/dev/null || true
elif command -v apt-get > /dev/null 2>&1; then
    # Debian/Ubuntu
    apt-get update
    apt-get install -y snmpd
fi

# Create snmp directory if it doesn't exist
mkdir -p /etc/snmp

# Backup original config
cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bak 2>/dev/null || true

# Create snmpd.conf WITHOUT agentaddress (port binding handled by command line/init)
# This prevents the "Error opening specified endpoint" issue
cat > /etc/snmp/snmpd.conf << 'EOF'
# SNMP Configuration - Community: SevOne (read-only)
# Note: No agentaddress directive - port binding handled externally
rocommunity SevOne default
sysLocation Lab 
sysContact Network Admin
EOF

# Kill any existing snmpd process
killall snmpd 2>/dev/null || true
sleep 1

# Start snmpd
if command -v systemctl > /dev/null 2>&1; then
    # SystemD
    systemctl restart snmpd
    systemctl enable snmpd
elif [ -f /etc/init.d/snmpd ]; then
    # Init.d
    /etc/init.d/snmpd restart
    rc-update add snmpd default 2>/dev/null || true
else
    # Direct start for BusyBox - let snmpd bind to default port (161)
    /usr/sbin/snmpd -c /etc/snmp/snmpd.conf -Lf /var/log/snmpd.log &
fi

echo "SNMP configured with community: SevOne"
echo "snmpd started (listening on default UDP port 161)"
echo "Check status: ps | grep snmpd"
echo "Test: snmpwalk -v2c -c SevOne localhost system"

