#!/bin/bash

for COMP in catalogue user cart shipping payment ; do 
sed -e '/$COMP/s/localhost/$COMP.robo.internal/' /tmp/roboshop.conf
done
