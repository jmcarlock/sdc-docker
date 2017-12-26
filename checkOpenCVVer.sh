#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

curl https://opencv.org/releases.html -o OpenCV_new.log &> /dev/null
subject="New version of OpenCV?"
message=/tmp/email-log-message.txt
sender="null@sgtwilko.f9.co.uk"

date=`date -R`
boundary="${RANDOM}_${RANDOM}_${RANDOM}"

# create a file for the email message
echo "Subject: $subject" > $message
echo "From: $sender" >> $message
echo "Date: $date" >> $message
echo "" >> $message
echo "There may be a new version of OpenCV at https://opencv.org/releases.html" >> $message
echo "" >> $message

diff OpenCV.log OpenCV_new.log &>> $message
if [ ! $? -eq 0 ]; then
	echo "" >> $message
	cat $message | /usr/bin/esmtp wilko@sgtwilko.f9.co.uk -f $sender
fi
#cat $message
rm $message
