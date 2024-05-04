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
    echo -e " $2 ............ $G Success "
    else
    echo -e " $2 ............ $R Failed "
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
cp mongodbrepo /etc/yum.repos.d
yum list installed mongodb-org -y &>> $logfile
if [ $? -eq 0 ]
then
echo -e " momgodb already  installed so $Y skipping the installation "
else
yum install mongodb-org -y  &>> $logfile
validate $? "installing mongodb"
fi
systemctl enable mongod
validate $? " enabling mongodb"
systemctl start mongod
validate $? " starting mongodb "
sed -i "s/127.0.0.1/0.0.0.0/g " /etc/mongod.conf
validate $? " giving remote access "
systemctl restart mongod
validate $? "restarting mongodb"
