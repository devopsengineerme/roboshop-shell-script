#!/bin/bash
#########################################
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
dnf install python36 gcc python3-devel -y &>> $logfile
validate $? " installing python"
######################################################################
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
curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $logfile
validate  $? " downloading payment.zip "
unzip /tmp/payment.zip &>> $logfile
validate $? "extracting payment.zip file"
cd /app &>> $logfile
pip3.6 install -r requirements.txt  &>> $logfile
validate $? " installing dependencies"
cp payment.service /etc/systemd/system/payment.service &>> $logfile
validate $? " copying payment.service"
systemctl daemon-reload &>> $logfile
validate $? " daemon reloading"
systemctl enable payment &>> $logfile
validate $? " enabling payment"
systemctl start payment &>> $logfile
validate $? " starting payment service"