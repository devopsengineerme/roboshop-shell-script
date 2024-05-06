#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
timestamp=$(date +%F)
logfile="/tmp/$0-$timestamp.log"
exec &>> $logfile
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
dnf module disable nodejs -y
validate $? " disabling nodejs"
dnf module enable nodejs:18 -y
validate $? " enabling nodejs:18"
dnf install nodejs -y
validate $? " installing nodejs"
id roboshop
if [ $? -eq 0 ]
then
echo -e " $G roboshop user already exits '
else
useradd roboshop
fi
if [ ! -d /app ]
then
mkdir /app
else
echo -e "$N /app already exits "
fi
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
validate  $? " downloading catalogue.zip "
unzip /tmp/catalogue.zip
validate $? "extracting the catalogue.zip file"
cd /app
npm install 
validate $? " installing dependencies"
cp catalogue.service /etc/systemd/system/catalogue.service
validate $? " copying catalogue.service"
systemctl daemon-reload
validate $? " daemon reloading"
systemctl enable catalogue
validate $? " enabling catalogue"
systemctl start catalogue
validate $? " starting catalogue"
cp mongodbrepo /etc/yum.repos.d/mongo.repo
dnf install mongodb-org-shell -y
validate $? " installing mongodb client"
mongo --host mongodb.myfirstroboshop.online </app/schema/catalogue.js

