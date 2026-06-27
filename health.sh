#!/bin/bash

for service in jenkins httpd; do

    if pgrep -f "$service" >/dev/null; then
        echo "$service is running"

        ps -C httpd -o %cpu,%mem --no-headers | \
        awk '{cpu+=$1; mem+=$2}
             END {print "CPU:",cpu"%","MEM:",mem"%"}'

    else
        echo "$service is not running"

        sudo systemctl status "$service" | awk 'NR==3{print $1,$2}'

        echo "Starting the service of $service"
        sudo systemctl start "$service"

        sleep 5

        if pgrep -f "$service" >/dev/null; then
            echo "$service is running now"

            sudo systemctl status "$service" | awk 'NR==3{print $1,$2}'

            ps -C httpd -o %cpu,%mem --no-headers | \
            awk '{cpu+=$1; mem+=$2}
                 END {print "CPU:",cpu"%","MEM:",mem"%"}'
        else
            echo "We got an error while running $service"
        fi
    fi

done

