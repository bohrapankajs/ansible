#!/bin/bash 
set -e 

# Verify the script is been executed as a root user or not.

COMPONENT=mongodb

source components/common.sh

echo -n "Configuring the repo:"
curl -s -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo
stat $? 

echo -n "Installing ${COMPONENT}:"
yum install mongodb-org -y &>> $LOGFILE
stat $?

echo -n "Updating the mongodb config:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf 
stat $? 

echo -n "Strating MongoDB: "
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE

echo -n "Downloading the $COMPONENT Schema:"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip" &>> $LOGFILE
stat $? 

echo -n "Injecting the schems:"
cd /tmp 
unzip -o  $COMPONENT.zip  &>> $LOGFILE
cd $COMPONENT-main 
mongo < catalogue.js &>> $LOGFILE
mongo < users.js &>> $LOGFILE
stat $?