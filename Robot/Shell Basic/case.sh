#!/bin/bash

Action=$1

case $Action in 
    start)
        echo " You are started"
        exit 1
        ;;
    stop)
        echo " You are stopped"
        exit 2
        ;;
    *)
        echo " Choose option from start and stop only yed zavya"
        exit 3
        ;;

esac
