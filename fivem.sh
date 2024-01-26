#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

echo "      Thanks For Buying From NOPING.ro"
echo "With this script you can setup your FiveM server"
echo "      Made By NOPING"
read -p "Press any key to start installing ..."

apt -y install sudo
sudo apt update
sudo apt -y upgrade

curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
apt update
apt -y install mariadb-server tar unzip git screen

cd /etc/mysql
rm my.cnf
wget https://raw.githubusercontent.com/naysaku/Fivem-Server-Auto-Setup/main/cdn/my.cnf
cd /etc/mysql/mariadb.conf.d
rm 50-server.cnf
wget https://raw.githubusercontent.com/naysaku/Fivem-Server-Auto-Setup/main/cdn/50-server.cnf
systemctl restart mysql
systemctl restart mariadb
cd

mkdir fivem-server
cd fivem-server
mkdir resources
read -p "Artifacts Link?(From https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/): " artifacts
wget ${artifacts}
tar -xvf fx.tar.xz
https://raw.githubusercontent.com/spritsail/fivem/master/server.cfg

read -p "Database username?: " db
read -p "Database user password?: " password
mysql -u root<<MYSQL_SCRIPT
CREATE DATABASE ${db};
CREATE USER '${db}'@'%' IDENTIFIED BY '${password}';
GRANT ALL PRIVILEGES ON *.* TO '${db}'@'%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

cd /etc/systemd/system
wget https://raw.githubusercontent.com/naysaku/Fivem-Server-Auto-Setup/main/cdn/fivem-server.service
cd /usr/bin/
wget https://raw.githubusercontent.com/naysaku/Fivem-Server-Auto-Setup/main/cdn/fivem_noping.sh
chmod +x fivem_noping.sh
cd
systemctl enable fivem-server
systemctl restart fivem-server

txip=`hostname -i`
echo ""
echo "Server installed!!!"
echo ""
echo "Your can connect on your database on https://phpmyadmin.noping.ro"
echo "Connect to the db using the server ip, database username and password"
echo "-----------------------------------------------------------------------------"
echo "DO NOT EVER RUN THE SERVER USING fivem_noping.sh. [It is controlled automatically by systemd(systemctl)]"
echo "You can control the server using the TxAdmin UI"
echo "You can also control the server using systemctl (start/restart/stop) fivem-server but it is not recommended."
echo "The server starts up automatically on every startup and after this setup."
echo "Use screen -r to enter the console, to exit the console hit Ctrl+A and then D"
echo "-----------------------------------------------------------------------------"
read -p "Server installed, use http://$txip:40120/ to configure your FiveM server from TxAdmin Web UI"
