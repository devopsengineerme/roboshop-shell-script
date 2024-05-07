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
dnf install nginx -y &>> $logfile
validate $? " installing nginx"
systemctl enable nginx &>> $logfile
validate $? "enabling nginx"
systemctl start nginx &>> $logfile
validate $? "starting nginx"
http://<public-IP>:80
validate $? " checking nginx connected or not"
rm -rf /usr/share/nginx/html/* &>> $logfile
validate $? " removing the default content"
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $logfile
validate $? " downloding the frontend content "
cd /usr/share/nginx/html &>> $logfile
validate $? " changing the current dir"
unzip /tmp/web.zip &>> $logfile
validate $? " extracting the content from web.zip"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $logfile
validate $? "copying roboshop conf file"
systemctl restart nginx &>> $logfile
validate $? " restarting nginx"