#!/bin/bash
for service in jenkins httpd; do pgrep -f "$service" >/dev/null;
status=$?
if [ $status -eq 0 ];
then
echo "$service is RUNNING"
ps -C httpd -o %cpu,%mem --no-headers | \
awk '{cpu+=$1; mem+=$2} END {print "CPU:",cpu"%","MEM:",mem"%"}'
else
echo "$service is NOT runing"
sudo systemctl status $service | awk 'NR==3{print $1,$2}'
echo "Starting the service of this $service"
sudo systemctl start $service
sleep 5

pgrep -f $service >/dev/null
status=$?
if [ $status -eq 0 ];
then
echo "$service is RUNNING NOW"
sudo systemctl status $service | awk 'NR==3{print $1,$2}'
ps -C httpd -o %cpu,%mem --no-headers | \
awk '{cpu+=$1; mem+=$2} END {print "CPU:",cpu"%","MEM:",mem"%"}'
else
echo "we got error while runing the $service"
fi
fi
done

