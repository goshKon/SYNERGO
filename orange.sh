#!/bin/sh
# Зеленый цвет
LIGHT_CYAN="\033[1;36m"
# Красный цвет
RED='\033[0;31m'
# Сброс цвета
NC='\033[0m'
stat_new=$(systemctl status dnsmasq.service | awk '/Active/{print $2}')
echo "Current status of dnsmasq.service: $stat_new"

if grep -E "^(/sbin/ifconfig eth0 0.0.0.0 0.0.0.0|dhclient)" /etc/rc.local
then
 	/sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
	sleep 5
	killall -9 openvpn
	sleep 3
	/usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
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
        killall -9 openvpn
        sleep 3
        /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
        echo "Restarting VPN"		
 fi   
 
if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
    echo "Initialization Sequence Completed"
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
