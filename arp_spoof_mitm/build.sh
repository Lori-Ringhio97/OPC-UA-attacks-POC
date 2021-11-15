#!/bin/bash
(cd ~/UA-.NETStandard/Applications/ConsoleReferenceServer/; ./dockerbuild.sh)
sudo docker build -t arpspoofer arpspoofer
sudo docker build -t tcpdumper tcpdumper