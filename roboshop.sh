#!/bin/bash
AMI=ami-0f3c7d07486cad139
Securirygroup=sg-0461e1a264c88f92b
instance=("web" "cart" "catalogue" "dispatch" "mongodb" "mysql" "rabbitmq" "payment" "redis" "shipping" "user")
for i in "${instance[@]}"
do
echo "instance is $i "
if [ $i -eq "mysql" ] || [ $i -eq "mongodb" ] || [ $i -eq "shipping" ]
then
instance_type="t3.small"
else
instance_type="t2.micro"
fi
aws ec2-run instances --image-id $AMI --instance-type $instance_type --security-group-ids $securitygroup --tag-specifications "ResourceType=instance,Tags=[{Key=name,Value=$i}]"
done