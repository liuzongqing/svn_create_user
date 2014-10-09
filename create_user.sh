#!/bin/bash

AUTH_DIR="/mnt/test"
AUTH_FILE="${AUTH_DIR}/svn.passwd"
USERNAME=$1
MailDomain="@funplus.com"
MailAddress=${USERNAME}${MailDomain}
Subject="SVN username and passwd"

function GetPasswd() {
local array=(a b c d e f g h i j k m n o p q r s t u v w x y z \
0 1 2 3 4 5 6 7 8 9 \
A B C D E F G H I J K L M N P Q R S T U V W X Y Z)

local Lenth_ARR=`echo ${#array[@]}`
local Lenth_Pass=8
local Passwd=""

for i in `seq 1 ${Lenth_Pass}`;do
	local Word=${array[$((RANDOM%${Lenth_ARR}))]}
	local Passwd=${Passwd}${Word}
done 

Password="${Passwd}"
}

if [ $# != 1 ]
then
	echo "Error,Please specify a user name."
	echo "For example: sh $0 username"
	exit 1
fi

GetPasswd

if [[ ! -d ${AUTH_DIR} ]]
then
	mkdir -p ${AUTH_DIR}
fi

if [[ ! -f ${AUTH_FILE} ]]
then
	touch ${AUTH_FILE}
	chown apache.apache ${AUTH_FILE}
else
	sed -ic '/'${USERNAME}'/d' ${AUTH_FILE}
fi

echo $USERNAME  $Password >> /tmp/svn.txt
htpasswd -bnm "${USERNAME}" "${Password}" | head -n 1 >> ${AUTH_FILE}

echo -e "HI ${USERNAME},\n\t This mail is from svn server for creating new user for you.If you have any questions,please send email to zongqing.liu@funplus.com.\n\t Your SVN username is ${USERNAME} and password is ${Password} .\n\t" | mail -s "${Subject}" ${MailAddress}

tail -n 1 /tmp/svn.txt
