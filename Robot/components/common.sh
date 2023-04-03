
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

# CREAT_USER
#  id $APPUSER  &>> $LOGFILE
#     if [ $? -ne 0 ]; then
        echo -n " New User Add:"
        useradd $APPUSER
        stat $?
    # fi

# Download and exract 
DONWLOAD_AND_EXTRACT

#Confuring Services 
CONFIGURE_SERVICE



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

NPM_INSTALL() {
echo -n " Installing $COMPONENTS Dependenscies:"
cd $COMPONENTS
npm install &>> $LOGFILE 
stat $?

}

CONFIGURE_SERVICE() {

echo -n " Configuring $COMPONENTS service"
sed -i -e's/MONGO_DNSNAME/172.31.83.219/' -e 's/MONGO_ENDPOINT/172.31.83.219/' -e 's/CATALOGUE_ENDPOINT/172.31.12.211/' -e 's/REDIS_ENDPOINT/172.31.53.189/' /home/$APPUSER/$COMPONENTS/systemd.service
mv /home/$APPUSER/$COMPONENTS/systemd.service /etc/systemd/system/$COMPONENTS.service
stat $?


echo -n "Starting Component Services :"

systemctl daemon-reload
systemctl start $COMPONENTS
systemctl enable $COMPONENTS &>> $LOGFILE 
stat $?


}