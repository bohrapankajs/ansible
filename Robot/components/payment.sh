#!/bin/bash
source components/common.sh
COMPONENTS=payment
APPUSER=roboshop

PYTHON(){


echo -n " installing Python:"
yum install python36 gcc python3-devel -y &>> $LOGFILE
stat $?

# Creating User 

CREAT_USER

# Download the repo.
DONWLOAD_AND_EXTRACT

#Install the dependencies
PYTHON_DEPENDECIES


# COnfuguring Payment Service
CONFIGURE_SERVICE

}

PYTHON_DEPENDECIES()
{

cd /home/$APPUSER/$COMPONENTS 
pip3 install -r requirements.txt &>> $LOGFILE


}

