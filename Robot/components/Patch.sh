#!/bin/bash
source components/common.sh
for component in catalogue user cart shipping payment; do 
    echo -n " For $component runs:"
    sed -i -e "/$component/s/localhost/$component.robo.internal/" /tmp/roboshop.conf
    stat $?
done
