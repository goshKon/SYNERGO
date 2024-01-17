#!/bin/sh
# Зеленый цвет
LIGHT_CYAN="\033[1;36m"
# Сброс цвета
NC='\033[0m'
stat_old=$(systemctl status isc-dhcp-server.service | awk '/Active/{print $2}')
echo "Current status of isc-dhcp-server.service: $stat_old"

	rest_VPN() {
	killall -9 openvpn
	sleep 3
	/usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
	}

max_attempts=3
attempt=0
while [$attempt -lt $max_attempts]
do
if [ "$stat_old" = "active" -o "$stat_old" = "inactive" ]
	then
           ping -c 5 172.81.0.1 >/dev/null 2>&1
		if [ $? -eq 0 ] 
		then
            echo "Ping successful"
	    sleep 3
        else
            echo "Rebooting VPN AFTER NO PING"
            sleep 3
	    rest_VPN

	fi   
fi
#if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
tun0_out=$(/sbin/ifconfig tun0)
if echo "$tun0_out" | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
 echo "Initialization Sequence Completed"
 echo "${LIGHT_CYAN}Tunnel is work! Exiting the script.${NC}"
   exit 0
    elif 
    grep -E "^(/sbin/ifconfig eth0 0.0.0.0 0.0.0.0|dhclient)" /etc/rc.local
	then
 /sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
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
echo "Failed to Initialize tunnel after $max_attempts attempts. Exiting script."
exit 1
    
# Добавлен код для проверки "Initialization Sequence Completed"
# if grep -q "Initialization Sequence Completed"
#if echo "$tun0_out" | grep -q "Initialization Sequence Completed"
#then
 # echo "${LIGHT_CYAN}Tunnel is work! Exiting the script.${NC}"
  #exit 0
#fi
