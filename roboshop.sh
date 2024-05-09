#!/bin/bash
AMI-ID=$1
Securiry-group=$2
instance=(web cart catalogue dispatch mongodb mysql rabbitmq payment redis shipping user)
for i in "${instance[@]}"
do
if [ $i == web ] || [ $i == cart ] || [ $i == catalogue ] || [ $i == dispatch ]
|| [ $i == rabbitmq ] || [ $i == payment ] || [ $i == redis ] || [ $i == user ]
then
instance-type=t2.micro
else
instance-type=t3.micro
fi
aws ec2-run instances --image-id $AMI-ID --instance-type $instance-type --count 1 --security-group-ids $security-group/
--key-name $instance
done