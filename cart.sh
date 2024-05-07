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
dnf module disable nodejs -y &>> $logfile
validate $? " disabling nodejs"
dnf module enable nodejs:18 -y &>> $logfile
validate $? " enabling nodejs:18"
dnf install nodejs -y &>> $logfile
validate $? " installing nodejs"
id roboshop &>> $logfile
if [ $? -eq 0 ]
then
echo -e " $G roboshop user already exits '
else
useradd roboshop &>> $logfile
fi
if [ ! -d /app ]
then
mkdir /app &>> $logfile
else
echo -e "$N /app already exits "
fi
curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $logfile
validate  $? " downloading cart.zip "
unzip /tmp/cart.zip &>> $logfile
validate $? "extracting the cart.zip file"
cd /app &>> $logfile
npm install  &>> $logfile
validate $? " installing dependencies"
cp cart.service /etc/systemd/system/cart.service &>> $logfile
validate $? " copying cart.service"
systemctl daemon-reload &>> $logfile
validate $? " daemon reloading"
systemctl enable cart &>> $logfile
validate $? " enabling cart"
systemctl start cart &>> $logfile
validate $? " starting cart"