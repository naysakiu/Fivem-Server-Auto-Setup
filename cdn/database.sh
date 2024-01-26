#!/bin/bash

echo "Select operation:"
echo "1. Create a new database"
echo "2. Change the password for an existing database"
echo "3. Remove a database and its user"
echo "4. Show all users and databases"
read -p "Enter your choice (1, 2, 3, or 4): " choice

if [ "$choice" == "1" ]; then
    read -p "Database username?: " db
    read -p "Database user password?: " password

    mysql -u root <<MYSQL_SCRIPT
    CREATE DATABASE IF NOT EXISTS ${db};
    CREATE USER '${db}'@'%' IDENTIFIED BY '${password}';
    GRANT ALL PRIVILEGES ON ${db}.* TO '${db}'@'%';
    FLUSH PRIVILEGES;
MYSQL_SCRIPT

    echo "Database '${db}' created with password '${password}'."
elif [ "$choice" == "2" ]; then
    read -p "Existing database username?: " db
    read -p "New database user password?: " password

    mysql -u root <<MYSQL_SCRIPT
    ALTER USER '${db}'@'%' IDENTIFIED BY '${password}';
    FLUSH PRIVILEGES;
MYSQL_SCRIPT

    echo "Password for database '${db}' changed to '${password}'."
elif [ "$choice" == "3" ]; then
    read -p "Database username to remove?: " db

    mysql -u root <<MYSQL_SCRIPT
    DROP USER IF EXISTS '${db}'@'%';
    DROP DATABASE IF EXISTS ${db};
    FLUSH PRIVILEGES;
MYSQL_SCRIPT

    echo "Database '${db}' and its user removed."
elif [ "$choice" == "4" ]; then
    echo "Listing all users and databases:"
    
    mysql -u root -e "SELECT user, host FROM mysql.user;"
    echo ""
    mysql -u root -e "SHOW DATABASES;"
else
    echo "Invalid choice. Please select 1, 2, 3, or 4."
fi
