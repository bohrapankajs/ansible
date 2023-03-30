#!/bin/bash
set -e

COMPONENTS=mongodb
source components/common.sh

echo -n " Downloading Configuration file:"
echo '[mongodb-org-4.2]
name=mongodb Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
stat $?

echo -n "installing mongodb"
yum install -y mongodb-org &>> LOGFILE

echo -n "Updating configuration file:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> LOGFILE
stat $?

echo -n "Starting mongodb:"
systemctl enable mongod
systemctl start mongod
stat $?


echo -n "Downloading the Schema:"
curl -s -L -o /tmp/$COMPONENTS.zip "https://github.com/stans-robot-project/$COMPONENTS/archive/main.zip" &>> LOGFILE
stat $?

cd /tmp
echo -n "Injecting Schema:"
unzip $COMPONENTS.zip &>> LOGFILE
cd $COMPONENTS-main
mongo < catalogue.js &>> LOGFILE
mongo < users.js  &>> LOGFILE
stat $?

