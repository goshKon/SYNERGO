#!/bin/sh
dhcl=$(grep "/sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient" /etc/rc.local)
dhcl_com="# /sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient &"
stat_new=$(systemctl status dnsmasq.service | awk '/Active/{print $2}')

echo "Current status of dnsmasq.service: $stat_new"

if [ "$dhcl" != "$dhcl_com" ] 
	then
 			/sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
			sleep 10
			killall -15 openvpn
			sleep 5
			/usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1 &
			echo "Restarting DHCP"	
   
   if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
    echo "Initialization Sequence Completed"
    
   	else
        s1=$(systemctl start dnsmasq.service)
        sleep 10
        echo "Starting dnsmasq.service: $s1"
        sleep 5
        s2=$(systemctl restart dnsmasq.service)
        sleep 10
        echo "Restarting dnsmasq.service: $s2"
        sleep 5
        killall -15 openvpn
        sleep 5
        /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
        echo "Restarting VPN"		
 fi   
fi
# Добавлен код для проверки "Initialization Sequence Completed"
 if grep -q "Initialization Sequence Completed" "$0"
 then
 echo "tun is work! Exiting the script."
 exit 0
 fi
