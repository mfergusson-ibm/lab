# Lab as Code

Simulated network (Lab01) that is based on Netlab and Containerlab for running in a home lab and providing a SevOne discoverable network that can be spun up in minutes. Requires reletively low cpu and memory. 7 routers are started and 1 linux host.


1. The instructions and config are for an Ubuntu standalone or VM server (other optionsr are supported, but below is what this is based on and tested with).
2. Once you have Netlab running, Lab01 can be run and based on FRRouting (FRR) that is a free and open source Internet routing protocol suite for Linux and Unix platforms.
3. FRR implements BGP, OSPF, RIP, IS-IS, PIM, LDP, BFD, Babel, PBR, OpenFabric and VRRP, with alpha support for EIGRP and NHRP. There are known issues with BGP and SNMP so BGP objects not created at present.
4. It is intended for lab, testing or training use.
5. The external network used is 10.10.10.0/24 and MUST be changed to the LAN network Ubuntu is running on (covered below).
6. Once up and running external hosts such as SevOne can poll the devices.
7. Devices can be reached via a management vrf using for example $ netlab connect r1, allowing full use of cli commands and customization of the running config (not persisent via restart).
8. Lab01 is configured with OSPF and BGP as per diagram below.
9. h1 is a Linux host that also has snmp enabled and can be discoveed.
10. The Ubuntu this was tested on is using the ubuntu-24.04.4-live-server-amd64.iso to deploy as a VM. See resources below to download from Box.
   

`Network Toplogy`

```
                                
         AS 64521                AS 64522              AS 64523
    +--------------+          +---------+          +------------------+
    |              |          |         |          |                  |
    |     [r1]-----+----------+--[r4]---+----------+----[r5]          |
    |     /|\      |          |   |     |          |     /|\          |
    |    / | \     |          |   |     |          |    / | \         |
    |   /  |  \    |          |   |     |          |   /  |  \        |
    |  /   |   \   |          |   |     |          |  /   |   \       |
    | [r2]-+-[r3]  |          +---------+          | [r6]-+-[r99]     |
    |      |       |            eBGP               |      |      |    |
    +------+-------+                               +------+------+----+
      OSPF + iBGP                                    OSPF + iBGP
           |                                              |
         [h1]                                       External Network
    172.16.2.0/24                                   10.10.10.0/24
                                                    (via ens160)
```

## Install



1. Install Ubuntu
    
   - For VMware "Expose hardware-assisted virtualization to the guest OS"
   - Tested on "ubuntu-24.04.4-live-server-amd64.iso". There are known issues with later versions, so suggest this for initial deployment.

2. Seup Environment
   
```
cd ~
sudo apt-get update
sudo apt-get install -y python3-pip python3-venv
python3 -m venv --system-site-packages .venv
source ~/.venv/bin/activate
echo "source ~/.venv/bin/activate" >> ~/.bashrc

```

3. Install Netlab

```
pip3 install networklab

```

4. Exit & re-login
   
5. Install Netlab Packages

```
netlab install ubuntu containerlab libvirt ansible

```
answer (y)es to questions


6. Validate Docker

```
groups
```

If user not part of docker and clab_admins

```
sudo usermod -aG docker,clab_admins $USER
newgroup docker

```
(newgrp docker is used to refresh your group memberships in the current terminal session without having to log out and back in - any issues that that re-login and check)

## Test
Note that libvirt is Not used in lab below.
This will download a bento/ubuntu image and can take time to do
provided here for completeness 
netlab test libvirt 

```

netlab test clab

```

SUCCESS clab is installed and working correctly


## Lab Setup

1. Clone or download directory from Github. Change to desired directory. For purposes here assumed to be user home directory.

```
cd ~
git clone git@github.com:mfergusson-ibm/lab.git

```

2. Navigate to lab

```
cd ~/lab/labs/lab01

```

3. Modify 

Edit the topology.yml file. 

Modify the section changing the 10.10.10.0/24 and 10.10.10.99/24
The 10.10.10.99/24 is what the route will be from SevOne on the same subnet

  - name: r5
    bgp.advertise: [ 10.10.10.0/24 ]

and

links:
  - r99:
      ipv4: 10.10.10.99/24
    clab:
      uplink: ens160

ens160 must be the interface of the Ubuntu server whose network is same as the SevOne subnet.

## Start Lab & Test

1. netlab up
   
```
netlab up

```

2. Test within Netlab
   -I is the source interface and loopback 0 in this case.

netlab connect r5
Connecting to container clab-lab011-r5, starting bash

Use vtysh to connect to FRR daemon

r5(bash)# ping -I 10.0.0.5 10.0.0.1

PING 10.0.0.1 (10.0.0.1) from 10.0.0.5: 56 data bytes

64 bytes from 10.0.0.1: seq=0 ttl=62 time=0.368 ms
64 bytes from 10.0.0.1: seq=1 ttl=62 time=0.232 ms


## Configure SevOne
1. Use nmtui from outside SevOne container to set custom static route

Destination/Prefix
10.0.0.8

Nexthop
10.10.10.99 <- Change to ip as set in step 3.

2. exit and restart NetworkManager

```
systemctl restart NetworkManager

```
3. ping r5

```
ping 10.0.0.5

```
4. ping h1

```
ping 10.0.0.8

nms

snmpwalk -v2c -c SevOne 10.0.0.1 sysDescr

```
RFC1213-MIB::sysDescr.0 = STRING: "Linux r1 6.8.0-117-generic #117-Ubuntu SMP PREEMPT_DYNAMIC Tue May  5 19:26:24 UTC 2026 x86_64"

```
snmpwalk -v2c -c SevOne 10.0.0.8 sysDescr

```

RFC1213-MIB::sysDescr.0 = STRING: "Linux h1 6.8.0-117-generic #117-Ubuntu SMP PREEMPT_DYNAMIC Tue May  5 19:26:24 UTC 2026 x86_64"


## Stop Lab

```
netlab down --cleanup

```

(use this if any issues encounterd with the above)

## References
Netlab: <https://netlab.tools/>  
Containerlab: <https://containerlab.dev>  
FRRouting Project: <https://frrouting.org>  

## Resources
Ubuntu iso from Box: <https://ibm.box.com/s/rz7e8g1rrig58enj6sfs30pm5sj14jyd>

## Credits
Ivan Pepelnjak from ipspace.net for providing Netlab and inspring me to put something together: <https://blog.ipspace.net/tag/netlab>


## Next Steps
- Create lab using Vyos that is more extensible (e.g. Flow support), and is based on FRR for routing engine.

---

* This has been a hobby project in my own time. If you find this useful, buy me a coffeee, or better yet, Blue Points always appreciated ;)
