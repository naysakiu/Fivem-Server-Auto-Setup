#!/bin/bash
set -e
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi
echo "      Thanks For Buying From Ignition."
echo "With this script you can setup your FiveM server"
echo "      Made By SuperHori♡#6969"
read -p "Press any key to start installing ..."
apt -y install sudo
sudo apt update
sudo apt -y upgrade
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
apt update
apt -y install mariadb-server tar unzip git

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
read -p "Artifacts Link?(From https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/): " artifacts
wget ${artifacts}
tar -xvf fx.tar.xz

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
wget https://raw.githubusercontent.com/naysaku/Fivem-Server-Auto-Setup/main/cdn/fivem_ignition.sh
chmod +x fivem_ignition.sh
cd
systemctl enable fivem-server

txip=`hostname -i`
echo ""
echo "Server installed!!!"
echo ""
echo "Your can connect on your database on https://phpmyadmin.ignitionhost.ro"
echo "Connect to the db using the server ip, database username and password"
echo "-----------------------------------------------------------------------------"
echo "DO NOT EVER RUN THE SERVER USING fivem_ignition.sh."
echo "You can control the server using systemctl start/restart/stop fivem-server."
echo "The server starts up automatically on every startup and after this setup."
echo "Use screen -r to enter the console, to exit the console hit Ctrl+A and then D"
echo "-----------------------------------------------------------------------------"
read -p "Server installed, use $txip:40120 to configure your FiveM server from TxAdmin"
rm fivem.sh