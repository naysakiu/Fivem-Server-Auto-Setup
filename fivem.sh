#!/bin/bash
set -e
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi
echo "      Thanks For Buying From Ignition."
echo "With this script you can setup your fivem server"
read -p "Press any key to start installing ..."
sudo apt update
sudo apt -y upgrade
