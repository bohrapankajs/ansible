#!/bin/bash

for COMP in catalogue user cart shipping payment ; do 
sed -i -e '/${COMP}/s/localhost/${COMP}.robo.internal/' /tmp/roboshop.conf
echo -n "Success :$COMP"
done
