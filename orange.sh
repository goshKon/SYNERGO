#!/bin/sh

# Голубой цвет
LIGHT_CYAN="\033[1;36m"
# Сброс цвета
NC='\033[0m'
fmount.sh
success=0
rest_VPN() {
    pkill openvpn
    sleep 15
    /usr/sbin/openvpn --config /etc/openvpn/client.ovpn 2>&1 & sleep 15 | while read line
    do
        echo $line
        if echo $line | grep -q "Initialization Sequence Completed"
        then
            echo "${LIGHT_CYAN}Tunnel is work! Exiting the script.${NC}"
            pkill openvpn
            exit 0
        fi
    done &

    wait $!
}

max_attempts=3
attempt=0

while [ $attempt -lt $max_attempts -a $success -eq 0 ]
do
stat_new=$(systemctl status dnsmasq.service | awk '/Active/{print $2}')
echo "Current status of dnsmasq.service: $stat_new"

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
	echo "Restarting DHCP"	
else
        s1=$(systemctl start dnsmasq.service)
        sleep 3
        echo "Starting dnsmasq.service: $s1"
        sleep 3
        s2=$(systemctl restart dnsmasq.service)
        sleep 5
        echo "Restarting dnsmasq.service: $s2"
        sleep 3
        rest_VPN
        echo "Restarting VPN"		
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
