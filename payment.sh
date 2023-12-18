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
 echo -e "Error: $RED Pleae run as root user $NORMAL"
 exit 1 
else 
 echo "Suessful: You are a root user"
fi

dnf install python36 gcc python3-devel -y &>> $LOGFILE
VALIDATE $? "Installing python"

useradd roboshop &>> $LOGFILE
VALIDATE $? "Adding user"

mkdir /app &>> $LOGFILE
VALIDATE $? "Making app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE
VALIDATE $? "Curl- dowloding zip"

cd /app  &>> $LOGFILE
VALIDATE $? "Changing directory"

unzip -0 /tmp/payment.zip &>> $LOGFILE
VALIDATE $? "Unzipping"

pip3.6 install -r requirements.txt &>> $LOGFILE
VALIDATE $? "Installing pip"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Loading daemon"

systemctl enable payment  &>> $LOGFILE
VALIDATE $? "Enabling payment"

systemctl start payment &>> $LOGFILE
VALIDATE $? "Starting paymnet"