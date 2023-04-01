#!/bin/bash


COMPONENTS=cart
source components/common.sh
APPUSER=roboshop
LOGFILE=/tmp/$COMPONENTS.log
NODEJS


# echo -n "Configuring Node JS :"
# curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -  &>> $LOGFILE
# stat $?

# echo -n "Installing Node JS :"
# yum install nodejs -y &>> $LOGFILE
# stat $?

# id $APPUSER &>> $LOGFILE
#     if [ $? -ne 0 ]; then 
#         echo -n "Creating app user :"
#         useradd roboshop
#         stat $?
#     fi

# echo -n "Downloading $COMPONENTS :"
# curl -s -L -o /tmp/$COMPONENTS.zip "https://github.com/stans-robot-project/$COMPONENTS/archive/main.zip" &>> $LOGFILE
# stat $?

# echo -n "moving files :"
# cd /home/$APPUSER/
# unzip -o /tmp/$COMPONENTS.zip &>> $LOGFILE
# stat $?

# echo -n "Performing cleanup :"
# rm -rf $COMPONENTS
# mv $COMPONENTS-main $COMPONENTS
# stat $?

# echo -n "Installing Dependancies:"
# cd $COMPONENTS
# npm install &>> $LOGFILE
# stat $?

# echo -n "Changing Permissions to  $APPUSER"
# chown $APPUSER:$APPUSER /home/$APPUSER/$COMPONENTS && chmod -R 775 /home/$APPUSER/$COMPONENTS
# stat $?

# echo -n "configuring $COMPONENTS service"
# sed -i -e 's/MONGO_ENDPOINT/172.31.83.219/' -e 's/REDIS_ENDPOINT/172.31.53.189/' /home/$APPUSER/$COMPONENTS/systemd.service
# mv /home/$APPUSER/$COMPONENTS/systemd.service /etc/systemd/system/$COMPONENTS.service
# stat $?


# echo -n "Starting $COMPONENTS service"
# systemctl daemon-reload
# systemctl start $COMPONENTS
# systemctl enable $COMPONENTS &>> $LOGFILE
# stat $?

echo -n -e "\e[32m___________ $COMPONENTS installation completed______________\e[0m"