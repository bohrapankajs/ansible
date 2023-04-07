#!/bin/bash
set -e

COMPONENTS=$COMPONENTS
source components/common.sh
APPUSER=roboshop

echo -n "Erlang is a dependency which is needed for $COMPONENTS: "
yum install https://github.com/$COMPONENTS/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y 
stat $?

echo -n "Setup YUM repositories for $COMPONENTS: "
curl -s https://packagecloud.io/install/repositories/$COMPONENTS/$COMPONENTS-server/script.rpm.sh | sudo bash
stat $?

echo -n " Install $COMPONENTS: "
yum install $COMPONENTS-server -y 
stat $?

echo -n "Start $COMPONENTS: "
systemctl enable $COMPONENTS-server 
systemctl start $COMPONENTS-server 
stat $?

echo -n "Creating application user: "
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" 
stat $?



