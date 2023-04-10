#!/bin/bash/

if [ -z $1 ] ; then
    echo "enter service name: "
    exit
fi

COMPONENT=$1


AMI_ID="$(aws ec2 describe-instances | jq '.Reservations[].Instances[].ImageId' | sed -e 's/"//g')"
SGID="$(aws ec2 describe-security-groups   --filters Name=group-name,Values=Free-Everyone | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')"
echo "AMI ID Used to launch instance is : $AMI_ID"
echo "SG ID Used to launch instance is : $SGID"
echo $COMPONENT

CREATE_SERVER()
{
aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SGID
}

if [ "$1" == "all" ] ; then
    for component in frontend catalogue cart user shipping payment mongodb mysql rabbitmq redis; do
    COMPONENT=component
    CREATE_SERVER
    echo -n " CREATED SERVER $component SUCCESSFULLY"
done
else
    CREATE_SERVER
fi