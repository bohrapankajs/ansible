#!/bin/bash
set -e

COMPONENTS=shipping
source components/common.sh
APPUSER=roboshop


MAVEN


# echo -n " Downloading the repo:"
# cd /home/$APPUSER
# curl -s -L -o /tmp/$COMPONENTS.zip "https://github.com/stans-robot-project/$COMPONENTS/archive/main.zip" &>> $LOGFILE
# stat $?

# echo -n "Unzip the file :"
# unzip /tmp/$COMPONENTS.zip &>> $LOGFILE
# mv $COMPONENTS-main $COMPONENTS
# stat $?

echo " Install Package :"
cd $COMPENENTS
mvn clean package &>> $LOGFILE
stat $?

echo -n "move Component jar file:"
mv target/$COMPONENTS-1.0.jar $COMPONENTS.jar 
stat $?

CONFIGURE_SERVICE
echo -n -e "\e[32m___________ $COMPONENTS installation completed______________\e[0m"







