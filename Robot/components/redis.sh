#!/bin/bash
set -e
source components/common.sh
COMPONENTS=redis
APPUSER=roboshop

echo -n "configuring $COMPONENTS report:"
wget https://download.redis.io/releases/redis-6.2.7.tar.gz &>> /tmp/redis.log
tar -xvf  redis-6.2.7.tar.gz &>> $LOGFILE
cd /home/centos/Shell_script/Robot/redis-6.2.7/ 
stat $?

echo -n "Installing $COMPONENTS:"
yum install redis-* -y &>> /tmp/redis.log
stat $?

echo - "Whitelisting $COMPONENTS to other:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>> /tmp/redis.log
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>> /tmp/redis.log
stat $?

echo -n "Startng $COMPONENTS service:"
systemctl daemon-reload
systemctl enable redis &>> /tmp/redis.log
systemctl start redis
stat $?
