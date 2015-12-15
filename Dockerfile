# Pull base image.
FROM ubuntu:14.04

RUN locale-gen ko_KR.UTF-8
RUN update-locale LANG=ko_KR.UTF-8
RUN dpkg-reconfigure locales

ENV LANG ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

# Install MySQL.
RUN \
    sed -ri 's/archive\.ubuntu\.com/kr\.archive\.ubuntu\.com/g' /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server-5.6 && \
    rm -rf /var/lib/apt/lists/* && \
    mv /var/lib/mysql /var/lib/mysql.init && \
    mv /etc/mysql /etc/mysql.init

COPY files/init.sh /init.sh

# Define default command.
CMD ["/init.sh"]

# Define working directory.
WORKDIR /var/lib/mysql

# Expose ports.
EXPOSE 3306
