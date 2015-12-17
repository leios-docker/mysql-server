# Pull base image.
FROM leios76/mysql-volume


# Install MySQL.
RUN \
    cp -Ra /var/lib/mysql /var/lib/mysql.default && \
    cp -Ra /etc/mysql /etc/mysql.default

COPY files/init.sh /init.sh

# Define default command.
CMD ["/init.sh"]

VOLUME ["/var/run/mysqld"]

# Define working directory.
WORKDIR /var/lib/mysql

# Expose ports.
EXPOSE 3306
