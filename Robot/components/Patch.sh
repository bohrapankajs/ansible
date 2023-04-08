#!/bin/bash

for component in catalogue user cart shipping payment; do 
    sed -i -e "/$component/s/localhost/$component.robo.internal/" /tmp/roboshop.conf
    stat $?
done
