#!/bin/bash

ID=$(id -u)

if [ $ID != 0 ]
then
 echo "Error: Pleae run as root user"
 exit 1 
else 
 echo "Suessful: You are a root user"
fi

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
      echo -e "$2... $RED Sucessful $NORAML "    
    else
      echo -e "$2...$G failed $NORMAL"
      exit 1
    fi
}

cp Mongo.repo /etc/yum.repos.d/ &>> $LOGFILE

VALIDATE $? "Coppied Mongodb repo"



