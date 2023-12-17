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
      echo -e "$2... $G Sucessful $NORMAL"    
    else
      echo -e "$2...$RED failed $NORMAL"
      exit 1
    fi
}

cp Mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Coppied Mongodb repo"

dnf install mongodb-org -y &>> $LOGFILE
VALIDATE $? "Installing MongoDB"

systemctl enable mongod
VALIDATE $? "Enabling mongodb"

sysytemctl start mongod
VALIDATE $? "Starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "Editing the file"

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "Restarting mongodb"



