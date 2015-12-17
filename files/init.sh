#!/bin/sh
set -e

rm -f /etc/mysql/conf.d/init.cnf

if [ ! -d "/var/lib/mysql/mysql" ]
then
  rm -Rf /var/lib/mysql/*

  mkdir -p /var/lib/mysql
  chmod 755 /var/lib/mysql
  cp -Ra /var/lib/mysql.default/* /var/lib/mysql/
  chown -R mysql:mysql /var/lib/mysql

  mkdir -p /etc/mysql
  chmod 755 /etc/mysql
  cp -Ra /etc/mysql.default/* /etc/mysql/

  TEMP_FILE='/tmp/mysql-first-time.sql'

  if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
      MYSQL_ROOT_PASSWORD=root
  fi

  echo 'DELETE FROM mysql.user WHERE user="root";' > "${TEMP_FILE}"
  echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'172.%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;" >> "${TEMP_FILE}"
  echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'10.%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;" >> "${TEMP_FILE}"
  echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;" >> "${TEMP_FILE}"
  echo 'DROP DATABASE IF EXISTS test ;' >> "${TEMP_FILE}"
  echo 'FLUSH PRIVILEGES ;' >> "${TEMP_FILE}"

  echo '[mysqld]'                            > /etc/mysql/conf.d/init.cnf
  echo "init-file            = ${TEMP_FILE}" >> /etc/mysql/conf.d/init.cnf

fi

mysqld
