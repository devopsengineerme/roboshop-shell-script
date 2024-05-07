#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
timestamp=$(date +%F)
logfile="/tmp/$0-$timestamp.log"
validate()
{
    if [ $1 -eq 0 ]
    then
    echo -e " $Y $2 ............ $G Success "
    else
    echo -e " $N $2 ............ $R Failed "
    fi
}
# ****************************************************
if [ $(id -u) -eq 0 ]
then
echo -e " $G it is a root user, so can proceed with the installations "
else
echo -e " $R please proceed with the root user "
exit
fi
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $logfile
validate $? " installing redis repository "
dnf module enable redis:remi-6.2 -y &>> $logfile
validate $? " enabling remi-6.2 "
dnf install redis -y &>> $logfile
validate $? " installing redis"
sed -i "s/ 127.0.0.1/0.0.0.0/g" /etc/redis.conf &>> $logfile
validate $? " enabling remote access"
systemctl enable redis &>> $logfile
validate $? " enabling redis"
systemctl start redis &>> $logfile
validate $? " starting redis"