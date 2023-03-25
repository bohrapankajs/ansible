#!/bin/bash
sample()
{
    echo " Ye Kon He bhai"
}

Star(){

echo "Number of PC attached : $(who | wc -l)"
echo "Your Uptime is $(uptime | awk -F : '{print $NF}'| awk -F , '{print $1}')"

sample


}

Star
sample