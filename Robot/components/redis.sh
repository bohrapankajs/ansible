#!/bin/bash
set -e
source components/common.sh
COMPONENTS=redis
APPUSER=roboshop

echo -n "configuring $COMPONENTS report:"
wget https://download.redis.io/releases/redis-6.2.7.tar.gz &>> $LOGFILE
tar -xvf  redis-6.2.7.tar.gz &>> $LOGFILE
cd redis-6.2.7 
stat $?

echo -n "Installing $COMPONENTS:"
yum install redis-6.2.7 -y &>> $LOGFILE
stat $?

echo - "Whitelisting $COMPONENTS to other:"
sed -i -e 's/127.0.0.0/0.0.0.0/' /etc/redis.conf
stat $?

echo -n "Startng $COMPONENTS service:"
systemctl daemon-reload
systemctl enable redis &>> $LOGFILE
systemctl start redis
stat $?
