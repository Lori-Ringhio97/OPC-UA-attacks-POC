# OPC UA ATTACKS

## Rogue Server, Rogue Client, and Middleperson attacks
This framework permits to execute rogue client/server/middleperson attacks in an OPC UA network:
- **Rogue Server**: the attacker creates a server that offers secure endpoints to establish a secure connection with new clients and make them believe that they are communicating with the actual OPC UA server in the network.
- **Rogue Client**: the attacker creates a client that attempts to connect to the server although not authorized by the network operator.
- **Middleperson attack (PitM)**: an attacker aims to establish themselves as Middleperson in the connection between the client and server, intercepting and manipulating all communications between both. In general, this requires achieving Rogue Client and Server objectives.
[Originally developped by Alessandro Erba, Anne Müller, Nils Ole Tippenhauer at CISPA Helmholtz Center for Information Security](https://cispa.saarland/group/tippenhauer/)

Requirements:
- [Python OPC UA](https://github.com/FreeOpcUa/python-opcua)
- OpenSSL
- Python3

Usage:
`./framework.py`

options:
- `-h help`
- `-a rogue_client`
- `-a rogue_server`
- `-a middleperson`

## ARP Spoofing man-in-the-middle attack
This section explains how to set up an OPC UA network based on docker conatiners in which it is possible to perform an ARP Spoofing mitm attack.
The network is composed by:
- An OPC UA Client (UAExpert).
- An OPC UA Server (.Net Core OPC UA Reference Server).
- One *attacker* Arpspoofer.
- An optional *observer* Tcpdumper that can be attached to different network interface.
The OPC UA Client runs in the local machine given that UAExpert requires a GUI, while the OPC UA Server, the Arpspoofer and the Tcpdumper run inside containers.

This attack was inspired and adapted from:
- https://dockersec.blogspot.com/2017/01/arp-spoofing-docker-containers_26.html
- https://github.com/BrunoVernay/lab-arpspoof/tree/master/Lab1-ArpSpoofing

Requirements:
- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [.Net Core OPC UA Reference Server](https://github.com/OPCFoundation/UA-.NETStandard)
- [UAExpert](https://www.unified-automation.com/downloads/opc-ua-clients.html)

### Build
Run `./build.sh` or the following commands (superuser privileges required):
```
(cd ~/UA-.NETStandard/Applications/ConsoleReferenceServer/; ./dockerbuild.sh)
sudo docker build -t arpspoofer arpspoofer
sudo docker build -t tcpdumper tcpdumper
```

### Run
Usually an ARP spoofing attack would spoof the gateway, but here the spoofing is performd on both the OPC UA Client and Server hosts. Since they are on the same LAN, they do not need the Gateway to communicate.
Launch 3 terminals and on terminal 1 run the following command which starts the .Net Core OPC UA Reference Server:
```
sudo docker run -it --ip 172.17.0.2 -p 62541:62541 -h refserver -v "$(pwd)/OPC Foundation:/root/.local/share/OPC Foundation" consolerefserver:latest
```
On the second terminal launch the arpspoofer attacker:
```
docker run -it --name arpspoofer arpspoofer
```
On the third terminal launch the tcpdumper container attached to the arpspoofer in order to capture the network traffic as an attacker would do:
```
sudo docker run -it --net=container:arpspoofer --name tcpdumper tcpdumper
```
In order to copy the captured pcap from the container to the host machine for an analisys with wireshark, run the following command:
```
sudo docker cp tcpdumper:/capture.pcap <path_in_the_localhost_at_which_to_save_the_file>
```

### Cleanup
By default Docker will keep images and containers. Here are some docker commands if you are not familiar with them:
- `sudo docker <image|container> ls -a` will show images or containers.
- `sudo docker <image|container> prune` will remove unused images or containers.
- `sudo docker rmi <image>` to remove a specific image.
- `sudo docker rm <container>` to remove a specific container.
In addition, a cleanup script is provided. Run `./cleanup.sh` or the following commands (superuser privileges required):
```
sudo docker rmi tcpdumper arpspoofer consolerefserver mcr.microsoft.com/dotnet/core/runtime:3.1 ubuntu
sudo docker rm tcpdumper arpspoofer consolerefserver
```