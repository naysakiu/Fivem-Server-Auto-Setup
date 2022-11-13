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
read -p "Artifacts Link?(From https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/): " artifacts
wget ${artifacts}
tar -xvf fx.tar.xz
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
apt update
apt -y install mariadb-server nginx tar unzip git
read -p "Database username?: " db
read -p "Database user password?: " password
mysql -u root<<MYSQL_SCRIPT
CREATE DATABASE ${db};
CREATE USER '${db}'@'%' IDENTIFIED BY '${password}';
GRANT ALL PRIVILEGES ON *.* TO '${db}'@'%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
