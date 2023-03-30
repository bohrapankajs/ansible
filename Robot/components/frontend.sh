#!/bin/bash
set -e

COMPONENTS=frontend
USERID=$(id -u)


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
yum install nginx -y &>> /tmp/$COMPONENTS.log 
stat $?

echo -n "Downloading Service:"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" &>> /tmp/$COMPONENTS.log
stat $?

echo -n "Performing Cleanup:"
rm -rf  /usr/share/nginx/html/* &>> /tmp/$COMPONENTS.log 
stat $?

cd /usr/share/nginx/html
echo -n "Unzip the componenets:"
unzip /tmp/frontend.zip  &>> /tmp/$COMPONENTS.log
stat $?
mv frontend-main/* . 
mv static/* .
rm -rf frontend-master README.md
echo -n "Configuring the Proxyfile:"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Enabling Nginx:"
systemctl enable nginx &>> /tmp/$COMPONENTS.log
systemctl start nginx  &>> /tmp/$COMPONENTS.log
stat $?