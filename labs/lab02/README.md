# Lab with Arista 
# (lab01 with r6 changed to Arista)

1. Follow instructions as per lab01
2. Arista cEOS-lab (Containerized EOS) is a free, containerized version of Arista's network operating system used for lab, testing, and automation purposes. Register at https://www.arista.com/en/login for an account.
3. Go to https://www.arista.com/en/support/software-download and download cEOS-lab-4.36.0F.tar.xz
4. Copy to your Ubuntu host
5. Extract the image

```
unxz cEOS-lab-4.36.0F.tar.xz

```
6. Import into Docker

```
docker image import cEOS-lab-4.36.0F.tar ceos:4.36.0F

```

Note that it is a large image and can a good few minutes to import (5-10 cdmin)

7. Verify image

```
docker images | grep ceos

```

8. Start Lab

```
cd ~/labs/lab02

netlab up

```

(Note that as r6 is a much larger image it may timeout. Might need to do a netlab down --cleanup then netlab up)

9. Test from SevOne

```
snmpwalk -v2c -c SevOne 10.0.0.6 sysDescr
SNMPv2-MIB::sysDescr.0 = STRING: Arista Networks EOS version 4.36.0F-47083774.4360F (engineering build) running on an Arista cEOSLab

```

