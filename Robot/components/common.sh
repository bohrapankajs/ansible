
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
