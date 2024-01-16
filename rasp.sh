#!/bin/sh
# Зеленый цвет
LIGHT_CYAN="\033[1;36m"
# Красный цвет
RED='\033[0;31m'
# Сброс цвета
NC='\033[0m'
stat_old=$(systemctl status isc-dhcp-server.service | awk '/Active/{print $2}')
echo "Current status of isc-dhcp-server.service: $stat_old"

if [ "$stat_old" = "active" -o "$stat_old" = "inactive" ]
	then
            ping -c 5 172.81.0.1 >/dev/null 2>&1
		if [ $? -eq 0 ] 
		then
            echo "Ping successful"
	    sleep 3
        else
            echo "Rebooting VPN AFTER NO PING"
            killall -9 openvpn
            sleep 3
          /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1

		fi   
fi
if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
    echo "Initialization Sequence Completed"
    elif 
    grep -E "^(/sbin/ifconfig eth0 0.0.0.0 0.0.0.0|dhclient)" /etc/rc.local
	then
 /sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
        sleep 5
        killall -9 openvpn
        sleep 3
       /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
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
        killall -9 openvpn
        sleep 3
       /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
        echo "Restarting VPN fnsh"
fi    
    
# Добавлен код для проверки "Initialization Sequence Completed"
if grep -q "Initialization Sequence Completed" "$0"
then
  echo "${LIGHT_CYAN}Tunnel is work! Exiting the script.${NC}"
  exit 0
else
  echo "${RED}Tunnel is NOT work! Exiting the script.${NC}"
  exit 0
fi
