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
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $logfile
validate $? " configuring yum repositories"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $logfile
validate $? "configuring rabbitmq repositories"
dnf install rabbitmq-server -y  &>> $logfile
validate $? "installing rabbitmq"
systemctl start rabbitmq-server &>> $logfile
validate $? "starting rabbitmq"
rabbitmqctl add_user roboshop roboshop123 &>> $logfile
validate $? " adding user to access rabbitmq"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $logfile
validate $? " setting permissions to access roboshop"