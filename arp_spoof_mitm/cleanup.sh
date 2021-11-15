#!/bin/bash
sudo docker rm tcpdumper arpspoofer consolerefserver
sudo docker rmi tcpdumper arpspoofer consolerefserver mcr.microsoft.com/dotnet/core/runtime:3.1 ubuntu
rm -rf ./OPC\ Foundation