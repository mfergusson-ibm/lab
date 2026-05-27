#!/bin/sh
# 1. Setup Master Config with the correct order
mkdir -p /etc/snmp
cat <<EOF > /etc/snmp/snmpd.conf
view all included .1
rocommunity SevOne default -V all
# Specify the TCP socket address
agentxsocket tcp:localhost:705
master agentx
EOF

# 2. Update FRR daemons safely
sed 's/zebra_options="/zebra_options="-M snmp /' /etc/frr/daemons | \
sed 's/ospfd_options="/ospfd_options="-M snmp /' > /tmp/daemons.new
sed -i 's/bgpd_options="/bgpd_options="-M snmp /' >> /tmp/daemons.new
echo "export SNMP_MASTER_SPEC=tcp:localhost:705" >> /tmp/daemons.new
cat /tmp/daemons.new > /etc/frr/daemons

# 3. Start snmpd explicitly listening on the TCP port
/usr/sbin/snmpd -c /etc/snmp/snmpd.conf -x tcp:localhost:705

# 4. Background restart of FRR processes
(pkill -9 zebra; pkill -9 ospfd; sleep 2; 
 export SNMP_MASTER_SPEC=tcp:localhost:705; 
 /usr/lib/frr/zebra -d -M snmp; 
 /usr/lib/frr/ospfd -d -M snmp;
 /usr/lib/frr/bgpd -d -M snmp;
 ) &

