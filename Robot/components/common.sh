
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

NODEJS() {

echo -n "Configuring Node JS :"
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -  &>> $LOGFILE
stat $?

echo -n "Installing Node JS :"
yum install nodejs -y &>> $LOGFILE
stat $?


#calling User creat to add user

CREAT_USER


# Download and exract 
DONWLOAD_AND_EXTRACT

# performing 
NPM_INSTALL

#Confuring Services 
CONFIGURE_SERVICE

}

MAVEN(){

echo -n " Install Maven:"

yum install maven -y &>> $LOGFILE

stat $?

#calling User creat to add user

CREAT_USER
#  id $APPUSER  &>> $LOGFILE
# #     if [ $? -ne 0 ]; then
#         echo -n " New User Add:"
#         useradd $APPUSER
#         stat $?
 # fi

# Download and exract 
DONWLOAD_AND_EXTRACT

#Confuring Services 
CONFIGURE_SERVICE

#Install Maven
MAVEN_INSTALL

#Confuring Services 
CONFIGURE_SERVICE



}


MAVEN_INSTALL(){
    
echo " Install Package :"
cd /home/roboshop/$COMPONENTS
mvn clean package &>> $LOGFILE
stat $?

echo -n "move Component jar file:"
mv target/$COMPONENTS-1.0.jar $COMPONENTS.jar 
stat $?

}
CREAT_USER() {


 id $APPUSER  &>> $LOGFILE
    if [ $? -ne 0 ]; then
        echo -n " New User Add:"
        useradd $APPUSER
        stat $?
    fi
}

DONWLOAD_AND_EXTRACT() {

echo -n "Downloading the $COMPONENTS:"
curl -s -L -o /tmp/$COMPONENTS.zip "https://github.com/stans-robot-project/$COMPONENTS/archive/main.zip" &>> $LOGFILE 
stat $?

echo -n "Cleaning /up:"
rm -rf /home/$APPUSER/$COMPONENTS
cd /home/$APPUSER/
echo -n "Unzipping $COMPONENTS:"
unzip -o /tmp/$COMPONENTS.zip &>> $LOGFILE && mv $COMPONENTS-main $COMPONENTS &>> $LOGFILE
stat $?

echo -n "Changing permission to $APPUSER :"
chown  $APPUSER:$APPUSER /home/$APPUSER/$COMPONENTS && chmod -R 775 /home/$APPUSER/$COMPONENTS
stat $?

}
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

USERID=$(id -u roboshop)
GROUPID=$(id -g roboshop)

echo -n "Update the roboshop user and group id in payment.ini file: "
sed -i -e "/^uid/ c uid=$USERID" -e "/^gid/ c gid=$GROUPID" /home/$APPUSER/$COMPONENTS/$COMPONENTS.ini
stat $?



# COnfuguring Payment Service
CONFIGURE_SERVICE

}

PYTHON_DEPENDECIES()
{

cd /home/$APPUSER/$COMPONENTS 
pip3 install -r requirements.txt &>> $LOGFILE


}






NPM_INSTALL() {
echo -n " Installing $COMPONENTS Dependenscies:"
cd $COMPONENTS
npm install &>> $LOGFILE 
stat $?

}

CONFIGURE_SERVICE() {

echo -n " Configuring $COMPONENTS service"
sed -i -e's/MONGO_DNSNAME/172.31.83.219/' -e 's/MONGO_ENDPOINT/172.31.83.219/' -e 's/AMQPHOST/172.31.80.205/' -e 's/CARTHOST/172.31.91.209/' -e 's/USERHOST/172.31.93.202/' -e 's/CARTENDPOINT/172.31.91.209/' -e 's/DBHOST/172.31.83.219/' -e 's/CATALOGUE_ENDPOINT/172.31.12.211/' -e 's/REDIS_ENDPOINT/172.31.82.34/' /home/$APPUSER/$COMPONENTS/systemd.service
mv /home/$APPUSER/$COMPONENTS/systemd.service /etc/systemd/system/$COMPONENTS.service
stat $?g


echo -n "Starting Component Services :"

systemctl daemon-reload
systemctl start $COMPONENTS
systemctl enable $COMPONENTS &>> $LOGFILE 
stat $?


}