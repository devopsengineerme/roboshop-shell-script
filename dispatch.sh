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
dnf install golang -y &>> $logfile
validate $? " installing golang "
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
curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip &>> $logfile
validate $? " downloding dispatch file"
unzip /tmp/dispatch.zip &>> $logfile
validate $? "extracting the dispatch.zip file"
cd /app &>> $logfile
unzip /tmp/dispatch.zip &>> $logfile
validate $? "extracting dispatch file"
go mod init dispatch &>> $logfile
go get &>> $logfile
go build &>> $logfile
cp dispatch.service /etc/systemd/system/dispatch.service &>> $logfile
validate $? " copying dispatch.service"
systemctl daemon-reload &>> $logfile
validate $? " daemon reloading"
systemctl enable dispatch &>> $logfile
validate $? " enabling dispatch"
systemctl start dispatch &>> $logfile
validate $? " starting dispatch" 