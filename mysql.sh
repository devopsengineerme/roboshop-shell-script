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
dnf module disable mysql -y &>> $logfile
validate $? "disabling the current mysql version"
cp mysqlrepo /etc/yum.repos.d/mysql.repo &>> $logfile
validate $? " coying mysql repository "
dnf install mysql-community-server -y &>> $logfile
validate $? " installing mysql "
systemctl enable mysqld &>> $logfile
validate $? " enabling mysql "
systemctl start mysqld &>> $logfile
validate $? " starting mysql"
mysql_secure_installation --set-root-pass RoboShop@1 &>> $logfile
validate $? " changing root password "
mysql -uroot -pRoboShop@1 &>> $logfile
validate $? " checking mysql connectivity "