# Lab with Arista (r6)

1. Follow instructions as per lab01
2. Arista cEOS-lab (Containerized EOS) is a free, containerized version of Arista's network operating system used for lab, testing, and automation purposes. Register https://www.arista.com/en/login for an account.
3. Go to https://www.arista.com/en/support/software-download and download cEOS-lab-4.36.0F.tar.xz
4. Copy to your ubuntu host
5. Extract the image

```
unxz cEOS-lab-4.36.0F.tar.xz

```
6. Import into Docker

```
sudo docker import cEOS-lab-4.36.0F.tar

```

7. Verify image

```
docker images | grep ceos

```

8. Start Lab

```
cd 

