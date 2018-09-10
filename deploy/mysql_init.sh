#!/bin/sh
MYSQL_ROOT_PASSWORD=9f8742a4cbdfdea9
#Run mysql if all setting is done
cat << EOF > /etc/my.cnf
[mysqld]
user = root
datadir = /app/mysql
port = 3306
EOF
if [ -d /app/mysql  ]; then
      echo "[i] MySQL directory already present, skipping creation"
      mkdir -p /run/mysqld
      exec /usr/bin/mysqld --user=root --console
      exit 1
else
      echo "[i] MySQL not yet create. Create a new environment."
fi

#Install and initialize mysql lib
tfile=`mktemp`
mysql_install_db --user=root #> /dev/null

if [ ! -f "$tfile"  ]; then
    return 1
else
cat << EOF > $tfile
USE mysql;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("") WHERE user='root' AND host='localhost';
FLUSH PRIVILEGES;
EOF
    mkdir -p /run/mysqld
    /usr/bin/mysqld --user=root --bootstrap
    exec /usr/bin/mysqld --user=root --console &
    while [ ! -S "/run/mysqld/mysqld.sock" ]
    do
        echo "Waiting mysql to started.."
        sleep 1
    done
    mysql -uroot < $tfile
    rm  -f $tfile
    tail -f /dev/null
fi
