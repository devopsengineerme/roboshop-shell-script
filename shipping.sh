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
dnf install maven -y &>> $logfile
validate $? " installing maven"
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
curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $logfile
validate  $? " downloading shipping.zip "
unzip /tmp/shipping.zip &>> $logfile
validate $? "extracting shipping.zip file"
cd /app &>> $logfile
mvn clean package  &>> $logfile
validate $? " installing dependencies"
cp shipping.service /etc/systemd/system/shipping.service &>> $logfile
validate $? " copying shipping.service"
systemctl daemon-reload &>> $logfile
validate $? " daemon reloading"
systemctl enable shipping &>> $logfile
validate $? " enabling user"
systemctl start shipping &>> $logfile
validate $? " starting shipping service"
cp mysqlrepo /etc/yum.repos.d/mysql.repo &>> $logfile
validate $? " coying mysql repository "
dnf install mysql -y &>> $logfile
validate $? " installing mysql"
mysql -h mysql.myfirstroboshop.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $logfile
validate "$? " loading schema"
systemctl restart shipping &>> $logfile
validate $?  " restarting shipping "