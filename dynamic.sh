#!/bin/bash
TODAYDATE=$(date )
echo -e "Todays date is \e[33m $(date +%F) \e[0m "
echo -e " \n number of pc: \e[36:42m $(who | wc -l)\e[0m"