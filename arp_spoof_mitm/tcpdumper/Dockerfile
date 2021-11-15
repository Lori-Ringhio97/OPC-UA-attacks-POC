# Arpspoofer attacker Dockerfile
FROM ubuntu
RUN apt-get update && apt-get install -y tcpdump
CMD tcpdump -n -i eth0 -w capture.pcap