#!/bin/bash
read -p "enter your number: " No
if [ $No -gt 10 ]; then
echo " Your number is greather than 10"
exit 1
elif [ $No -gt 5 ]; then
echo " Your Number is greater than 5"
exit 2
else 
echo "your number is less than 5 "
exit 3
fi