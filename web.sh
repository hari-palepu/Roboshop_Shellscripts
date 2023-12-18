#!/bin/bash

ID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started at $TIMESTAMP" &>> $LOGFILE

RED="\e[31m"
G="\e[32m"
Yel="\e[33m"
NORMAL="\e[0m"


VALIDATE(){
    if [ $1 = 0 ]
    then 
      echo -e "$2... $G Sucessful $NORMAL"    
    else
      echo -e "$2...$RED failed $NORMAL"
      exit 1
    fi
}

if [ $ID != 0 ]
then
 echo "Error: $RED Pleae run as root user $NORMAL"
 exit 1 
else 
 echo "Suessful: You are a root user"
fi

dnf install nginx -y
VALIDATE $? "Installing nginx"

systemctl enable nginx
VALIDATE $? "Enabling nginx"

systemctl start nginx
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/*

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

cd /usr/share/nginx/html


