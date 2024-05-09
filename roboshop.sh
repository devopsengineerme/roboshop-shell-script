#!/bin/bash
AMIID=$1
Securirygroup=$2
instance=(web cart catalogue dispatch mongodb mysql rabbitmq payment redis shipping user)
for i in "${instance[@]}"
do
if [ $i == web ] || [ $i == cart ] || [ $i == catalogue ] || [ $i == dispatch ] || [ $i == rabbitmq ] || [ $i == payment ] || [ $i == redis ] || [ $i == user ]
then
instance-type="t2.micro"
else
instance-type="t3.small"
fi
aws ec2-run instances --image-id $AMIID --instance-type $instance-type --count 1 --security-group-ids $securitygroup/
--tag-specifications 'ResourceType=instance,Tags=[{Key=name,Value=$i}]
done