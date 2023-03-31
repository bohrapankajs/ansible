#!/bin/bash
set -e

COMPONENTS=catalogue
APPUSER=roboshop
source components/common.sh



echo -n " Downloading File:"
wget http://nodejs.org/dist/v0.10.30/node-v0.10.30.tar.gz &>> $LOGFILE 
stat $?
echo -n " Unzip File:"
tar xzvf node-v0.10.30.tar.gz &>> $LOGFILE
cd node-v0.10.30
stat $?
echo -n " Installing Dependancies:"
yum install gcc gcc-c++ &>> $LOGFILE 
stat $?
echo -n " Configuring Dependencoes:"
/home/centos/Shell_script/Robot/node-v0.10.30/configure  

stat $?
echo -n " Installing Nodejs:"
 
stat $?

echo -n " App user is $APPUSER :"
id $roboshop  &>> $LOGFILE
if  [ $? -ne 0 ] ; then
echo "Creatind the App User"
useradd roboshop &>> $LOGFILE 
fi
stat $?

echo -n "Downloading the $COMPONENTS:"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip" &>> $LOGFILE 
stat $?

cd /home/$APPUSER
echo -n "Unzipping $COMPONENTS:"
unzip /tmp/catalogue.zip &>> $LOGFILE 
stat $?


echo -n "Cleaning up"
rm -rf $COMPONENTS
mv catalogue-main catalogue
cd /home/$APPUSER/catalogue

echo -n "Installing dependencies :"
npm install &>> $LOGFILE 
stat $?


echo -n "Changing permission to $APPUSER :"
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENTS
stat $?

echo -n " Configuring $COMPONENTS service"
sed -e -i 's/MONGO_DNSNAME/172.31.83.219/' /home/$APPUSER/$COMPONENTS/systemd.service
mv /home/$APPUSER/$COMPONENTS/systemd.service /etc/systemd/system/$COMPONENTS.service
stat $?


echo -n "Starting Component Services :"

systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue
stat $?

