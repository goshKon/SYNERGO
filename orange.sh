#!/bin/sh

# Голубой цвет
LIGHT_CYAN="\033[1;36m"
# Сброс цвета
NC='\033[0m'
fmount.sh
success=0
rest_VPN() {
    echo "Killing any existing openvpn processes..."
    killall -9 openvpn
    sleep 5
    echo "Starting openvpn..."
    /usr/sbin/openvpn --config /etc/openvpn/client.ovpn 2>&1 & sleep 5 | while read line
    do
        echo $line
        if echo $line | grep -Eq "Initialization Sequence Completed|Tunnel is work! Exiting the script."
        then
            echo "${LIGHT_CYAN}Tunnel is work! Exiting the script.${NC}"
            killall -9 openvpn
            success=1
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
    if [ $success -eq 0 ]
    then
        echo "Attempt $attempt of $max_attempts failed. Retrying..."
        sleep 10
    fi
done
