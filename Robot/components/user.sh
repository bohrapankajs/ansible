#!/bin/bash

source components/common.sh
COMPONENTS=user
APPUSER=roboshop
LOGFILE=/tmp/$COMPONENTS.log



echo -n " Downloading File:"
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE 
stat $?
echo -n " Installing Nodejs:"
yum install nodejs -y  &>> $LOGFILE 
stat $?

id $APPUSER  &>> $LOGFILE
    
    
    if [ $? -ne 0 ]; then
        echo -n " New User Add:"
        useradd $APPUSER
        stat $?
    fi



echo -n "Downloading the $COMPONENTS:"
curl -s -L -o /tmp/$COMPONENTS.zip "https://github.com/stans-robot-project/$COMPONENTS/archive/main.zip" &>> $LOGFILE 
stat $?

cd /home/$APPUSER/
echo -n "Unzipping $COMPONENTS:"
unzip -o /tmp/$COMPONENTS.zip &>> $LOGFILE 
stat $?


echo -n "Cleaning up:"
rm -rf $COMPONENTS
mv $COMPONENTS-main $COMPONENTS

stat $?

echo -n "Installing dependencies :"
cd $COMPONENTS
npm install &>> $LOGFILE 
stat $?


echo -n "Changing permission to $APPUSER :"
chown  $APPUSER:$APPUSER /home/$APPUSER/$COMPONENTS && chmod -R 775 /home/$APPUSER/$COMPONENTS
stat $?

echo -n " Configuring $COMPONENTS service"
sed -i -e's/MONGO_ENDPOINT/172.31.83.219/' -e 's/REDIS_ENDPOINT/172.31.93.27/' /home/$APPUSER/$COMPONENTS/systemd.service
mv /home/$APPUSER/$COMPONENTS/systemd.service /etc/systemd/system/$COMPONENTS.service
stat $?


echo -n "Starting Component Services :"

systemctl daemon-reload
systemctl start $COMPONENTS
systemctl enable $COMPONENTS &>> $LOGFILE 
stat $?
