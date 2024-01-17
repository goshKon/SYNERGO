#!/bin/sh

# Голубой цвет
LIGHT_CYAN="\033[1;36m"
# Сброс цвета
NC='\033[0m'
fmount.sh
success=0
rest_VPN() {
    killall -15 openvpn
    sleep 15
    /usr/sbin/openvpn --config /etc/openvpn/client.ovpn 2>&1 & sleep 15 | while read line
    do
        echo $line
        if echo $line | grep -q "Initialization Sequence Completed"
        then
            echo "${LIGHT_CYAN}Tunnel is work! Exiting the script.${NC}"
           killall -15 openvpn
            exit 0
        fi
    done &

    wait $!
}

max_attempts=3
attempt=0

while [ $attempt -lt $max_attempts -a $success -eq 0 ]
do
stat_old=$(systemctl status isc-dhcp-server.service | awk '/Active/{print $2}')
echo "Current status of isc-dhcp-server.service: $stat_old"

    if [ "$stat_old" = "active" -o "$stat_old" = "inactive" ]
    then
        if ping -c 5 172.81.0.1 >/dev/null 2>&1
        then
            echo "Ping successful"
            sleep 3
        else
            echo "Rebooting VPN AFTER NO PING"
            sleep 3
            rest_VPN
        fi
    fi

    tun0_out=$(/sbin/ifconfig tun0)
    if echo "$tun0_out" | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
    then
        echo "${LIGHT_CYAN}Tunnel is work! Exiting the script.${NC}"
	break
    elif 
	grep -E "^(/sbin/ifconfig eth0 0.0.0.0 0.0.0.0|dhclient)" /etc/rc.local
    then
        /sbin/ifconfig eth0 0.0.0.0 0.0.0.0 && dhclient & >/dev/null 2>&1
        sleep 5
        rest_VPN
        echo "Restarting VPN DHCP"
    else
        s3=$(systemctl start isc-dhcp-server.service)
        sleep 5
        echo "Starting isc-dhcp-server.service: $s3"
        sleep 3
        s4=$(systemctl restart isc-dhcp-server.service)
        sleep 5
        echo "Restarting isc-dhcp-server.service: $s4"
        sleep 3
        rest_VPN
        echo "Restarting VPN fnsh"
    fi

    attempt=$((attempt+1))
    echo "Attempt $attempt of $max_attempts failed. Retrying..."
    sleep 10
done
if [ $success -eq 0 ]
then
break
else
    echo "Failed to Initialize tunnel after $max_attempts attempts. Exiting script."
    exit 1
fi
