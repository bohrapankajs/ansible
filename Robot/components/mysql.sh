#!/bin/bash
COMPONENTS=mysql
source components/common.sh
LOGFILE=/tmp/$COMPONENTS.log

read -p 'Enter Mysql password you wish to configure:' MYSQL_PWD


echo -n "Configuration $COMPONENTS repo:"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo &>> $LOGFILE
stat $?

echo -n "Installing $COMPONENTS :"
yum remove mariadb-libs -y &>> $LOGFILE
yum install mysql-community-server -y &>> $LOGFILE
stat $?

echo -n "Starting the $COMPONENTS : "
systemctl enable mysqld  &>> $LOGFILE
systemctl start mysqld
stat $?
 
echo -n "Changing the default Password:"

DEF_ROOT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk -F ' ' '{print $NF}')
stat $?

echo show database | mysql -uroot -pRoboShop@1 &>> $LOGFILE
if [ $? -ne 0 ] ; then
    echo -n "Reset root password:"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${RoboShop@1}';" | mysql --connect-expired-password -uroot -p"${DEF_ROOT_PASSWORD}" &>> $LOGFILE
    stat $?
fi

echo show plugins | mysql -uroot -p${RoboShop@1} | grep validate_password; &>> $LOGFILE
if [ $? -eq 0 ] ; then
    echo -n "Uninstalling password validate plugin:"
    echo "uninstall plugin validate_password;" | mysql --connect-expired-password -uroot -p${RoboShop@1} &>> $LOGFILE
    stat $?
fi


echo -n "downloading the $COMPONENTS schema:"
cd /tmp
curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip"
unzip -o $COMPONENTS.zip &>> $LOGFILE
stat $?

echo -n " Injecting the $COMPENENTS schema:"
cd /tmp/$COMPONENTS-main
mysql -u root -p${RoboShop@1} < shipping.sql
stat $?

echo -n -e "\e[32m___________ $COMPONENTS installation completed______________\e[0m"