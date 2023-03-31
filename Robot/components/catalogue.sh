#!/bin/bash
set -e
source components/common.sh
COMPONENTS=catalogue
APPUSER=roboshop




echo -n " Downloading File:"
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE 
stat $?
echo -n " Installing Nodejs:"
yum install nodejs -y  &>> $LOGFILE 
stat $?

id $APPUSER  &>> $LOGFILE
    if [ $? -ne 0]; then
        echo " New User Add:"
        useradd $APPUSER
        stat $?
    if

#echo -n " App user is $APPUSER :"
#useradd roboshop
#stat $?

echo -n "Downloading the $COMPONENTS:"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip" &>> $LOGFILE 
stat $?

cd /home/$APPUSER/
echo -n "Unzipping $COMPONENTS:"
unzip -o /tmp/catalogue.zip &>> $LOGFILE 
stat $?


echo -n "Cleaning up:"
rm -rf $COMPONENTS
mv catalogue-main catalogue

stat $?

echo -n "Installing dependencies :"
cd $COMPONENTS
npm install &>> $LOGFILE 
stat $?


echo -n "Changing permission to $APPUSER :"
chown  $APPUSER:$APPUSER /home/$APPUSER/$COMPONENTS && chmod -R 775 /home/$APPUSER/$COMPONENTS
stat $?

echo -n " Configuring $COMPONENTS service"
sed -i -e's/MONGO_DNSNAME/172.31.83.219/' /home/$APPUSER/$COMPONENTS/systemd.service
mv /home/$APPUSER/$COMPONENTS/systemd.service /etc/systemd/system/$COMPONENTS.service
stat $?


echo -n "Starting Component Services :"

systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue &>> $LOGFILE 
stat $?
