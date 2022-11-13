#!/bin/bash
set -e
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi
echo "      Thanks For Buying From Ignition."
echo "With this script you can setup your fivem server"
read -p "Press any key to start installing ..."
apt -y install sudo
sudo apt update
sudo apt -y upgrade
mkdir fivem-server
cd fivem-server
wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/6019-f14f98f0089b9068916e0fec0180b2ee968d8387/fx.tar.xz
tar -xvf fx.tar.xz
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
apt update
apt -y install mariadb-server nginx tar unzip git