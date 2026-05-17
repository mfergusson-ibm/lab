# lab


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


Expose hardware-assisted virtualization to the guest OS


cd ~
sudo apt-get update
sudo python3 -m venv --system-site-packages lab
source lab/bin/activate
echo "source lab/bin/activate" >> ~/.bashrc
pip3 install networklab

exit

netlab install ubuntu containerlab libvirt ansible

(answer (y)es to questions)

# Test
libvirt is Not used in lab below
this will download a bento/ubuntu image and can take time to do
provided here for completeness 
netlab test libvirt 

netlab test clab

SUCCESS clab is installed and working correctly


cd

make docker-image

docker images

vrnetlab/cisco_iol:17.16.01a

netlab connect r5
Connecting to 192.168.200.105 using SSH port 22



`r5#ping 10.0.0.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.0.0.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms`


unxz 

docker image import cEOS-lab-4.36.0F.tar ceos:4.36.0F

https://ibm.box.com/s/5hnqi0d0h8h60mexbl84bza4hk7qhaec
