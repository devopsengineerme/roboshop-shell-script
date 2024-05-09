#!/bin/bash
AMI=ami-0f3c7d07486cad139
Securirygroup=sg-0461e1a264c88f92b
zoneid=Z0030464251IYYT5PS6JF
instance=("web" "cart" "catalogue" "dispatch" "mongodb" "mysql" "rabbitmq" "payment" "redis" "shipping" "user")
for i in "${instance[@]}"
do
    echo "instance is $i "
    if [ $i == "mysql" ] || [ $i == "mongodb" ] || [ $i == "shipping" ]
    then
    instance_type="t3.small"
    else
    instance_type="t2.micro"
    fi
IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI --instance-type $instance_type --security-group-ids $securitygroup \
 --tag-specifications "ResourceType=instance,Tags=[{Key=name,Value= $i}]"\
 --query 'Instances[0].[PrivateIpAddress]' --output text)
echo " instance is $i: IP_ADDRESS is $IP_ADDRESS"
## CREATING ROUTE 53 records
aws route53 change-resource-record-sets \
  --hosted-zone-id $zoneid \
  --change-batch '
  {
    "Comment": "Creating a record set for cognito endpoint"
    ,"Changes": [{
      "Action"              : "CREATE"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$i'.'myfirstroboshop.online'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP_ADDRESS'"
        }]
      }
    }]
  }'
  done
