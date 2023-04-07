#!/bin/bash


COMPONENTS=rabbitmq
source components/common.sh
APPUSER=roboshop
LOGFILE=/tmp/$COMPONENTS.log


# echo -n "Erlang is a dependency which is needed for $COMPONENTS: "
# yum install https://github.com/$COMPONENTS/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>> $LOGFILE
# stat $?

echo -n "Erlang is a dependency which is needed for $COMPONENTS: "
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y 
stat $?

echo -n "Setup YUM repositories for $COMPONENTS: "
curl -s https://packagecloud.io/install/repositories/$COMPONENTS/$COMPONENTS-server/script.rpm.sh | sudo bash &>> $LOGFILE
stat $?

echo -n " Install $COMPONENTS: "
yum install $COMPONENTS-server -y &>> $LOGFILE
stat $?

echo -n "Start $COMPONENTS: "
systemctl enable $COMPONENTS-server &>> $LOGFILE
systemctl start $COMPONENTS-server 
stat $?

echo -n "Creating application user: "
rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE
rabbitmqctl set_user_tags roboshop administrator &>> $LOGFILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>> $LOGFILE
stat $?



