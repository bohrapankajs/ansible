#!/bin/bash
set -e

COMPONENTS=mongodb
APPUSER=roboshop
source components/common.sh

echo -n " Configuring NodeJs:"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE 
stat $?

echo -n " Installing NodeJs:"
yum install nodejs -y &>> $LOGFILE 
stat $?

id $APPUSER &>> $LOGFILE 
if  [ $? -ne 0 ]; then
echo "Creatind the App User"
useradd $APPUSER &>> $LOGFILE 
stat $?

echo -n "Downloading the $COMPONENTS:"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip" &>> $LOGFILE 
stat $?

cd /home/$APPUSER
echo -n "Unzipping $COMPONENTS:"
unzip /tmp/catalogue.zip &>> $LOGFILE 
stat $?

mv catalogue-main catalogue
cd /home/$APPUSER/catalogue
echo -n "Installing npm :"
npm install &>> $LOGFILE 
stat $?
