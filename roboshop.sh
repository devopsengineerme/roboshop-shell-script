#!/bin/bash
AMI-ID=$1
Securiry-group=$2
instance=(web cart catalogue dispatch mongodb mysql rabbitmq payment redis shipping)
if [ 'instance{$@}' -eq cart|redis|rabbitmq|payment|web|dispatch|catalogue ]
then
instance-type=t2.micro
else
instance-type=t3.micro
fi
aws ec2-run instances --image-id $AMI-ID --instance-type $instance-type --count 1 --security-group-ids $security-group/
--key-name $instance