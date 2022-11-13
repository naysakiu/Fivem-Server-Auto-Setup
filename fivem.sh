#!/bin/bash
set -e
if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi
echo "      Thanks For Buying From Ignition."
echo "With this script you can setup your fivem server"
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
wget https://raw.githubusercontent.com/naysaku/Fivem-Server-Auto-Setup/main/cdn/fivem.service
cd /usr/bin/
wget https://raw.githubusercontent.com/naysaku/Fivem-Server-Auto-Setup/main/cdn/fivem_ignition.sh
cd
systemctl enable fivem-server
txip=`hostname -i`
echo ""
echo "Your can connect on your database on https://phpmyadmin.ignitionhost.ro"
echo "Use your server ip as the server, user and password you set earlier"
read -p "Server installed, use $txip:40120 to configure your fivem server"