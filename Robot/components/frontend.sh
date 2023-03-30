#!/bin/bash
set -e

COMPONENTS=frontend
USERID=$(id -u)
LOGFILE=/tmp/$COMPONENTS.log


if [ $USERID -ne 0 ] ; then
    echo -e "\e[31m Not a Root User \e[0m"
    exit 1
fi

stat()
{
    if [ $? -eq 0 ]; then
        echo -e "\e[32m Success\e[0m"
    else
        echo -e "\e[31m Faillure\e[0m"
    fi
}

echo -n "Installing nginx:"
yum install nginx -y &>> $LOGFILE
stat $?

echo -n "Downloading Service:"
curl -s -L -o /tmp/$COMPONENTS.zip "https://github.com/stans-robot-project/$COMPONENTS/archive/main.zip" &>> $LOGFILE
stat $?

echo -n "Performing Cleanup:"
rm -rf  /usr/share/nginx/html/* &>> $LOGFILE 
stat $?

cd /usr/share/nginx/html
echo -n "Unzip the componenets:"
unzip /tmp/$COMPONENTS.zip  &>> $LOGFILE
stat $?
mv $COMPONENTS-main/* . 
mv static/* .
rm -rf $COMPONENTS-master README.md
echo -n "Configuring the Proxyfile:"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Enabling Nginx:"
systemctl enable nginx &>> $LOGFILE
systemctl start nginx  &>> $LOGFILE
stat $?