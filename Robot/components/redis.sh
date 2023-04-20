#!/bin/bash 
set -e 

COMPONENT=redis

source components/common.sh

echo -n "Configuring $COMPONENT repo:"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> $LOGFILE
stat $? 

echo -n "Installing $COMPONENT:"
yum install redis-6.2.7 -y  &>> $LOGFILE
stat $? 

echo -n "Whitelisting redis to others:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $? 

echo -n "Starting $COMPONENT service:"
systemctl daemon-reload 
systemctl enable redis 
systemctl restart redis 
stat $? 