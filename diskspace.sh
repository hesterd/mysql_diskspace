#!/bin/sh

RM="/bin/rm"

df -H |grep mysql |awk '{print $5 ":" $1}' | while read output;
do
diskspace=$(echo $output | cut -d: -f1)
diskspacenumber=$(echo $output |cut -d% -f1)
partition=$(echo $output | cut -d: -f2)
if [ $diskspacenumber -gt 50 ]
then
echo "LOW DISK SPACE ALERT Dev databases" > /tmp/header.tmp
#echo $header
fi


echo "Diskspace: *$diskspace* Partition: $partition\n" > /tmp/size.tmp
echo "Please Remove unneeded databases!!\n" >> /tmp/size.tmp
done

du -skh /var/lib/mysql/data/* |grep ^..G|egrep 'dev|qa' |sort -nr | while read diffput;
#du -skh /var/lib/mysql/data/* |grep ^..G | grep dev |sort -nr | while read diffput;
do
databasesize=$(echo $diffput |awk '{print $1}')
databasename=$(echo $diffput |cut -d\/ -f6)

echo "$databasesize $databasename" >> /tmp/size.tmp


done


if [ -f /tmp/size.tmp ] 
then
header=$(cat /tmp/header.tmp)
#cat /tmp/size.tmp|mail -s "$header" dave@sampledomain.com
cat /tmp/size.tmp|mail -s "$header" tech@sampledomain.com,dave@sampledomain.com
#cat /tmp/size.tmp|mail -s "$header" dave@sampledomain.com
$RM /tmp/size.tmp
$RM /tmp/header.tmp
fi
