Здравствуйте! Как я могу вам помочь сегодня?

исправь пожалуйста,
после строки echo "Restarting VPN DHCP" выдает Tunnel is work! Exiting the script, хотя не должен, так как не попадает в данное условие и не находит grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
#!/bin/sh

Зеленый цвет
LIGHT_CYAN="\033[1;36m"

Сброс цвета
NC='\033[0m'
stat_old=(systemctl status isc-dhcp-server.service | awk '/Active/{print \2}')
echo "Current status of isc-dhcp-server.service: $stat_old"

if [ "
�
�
�
�
�
�
�
"
=
"
�
�
�
�
�
�
"
−
�
"
stat 
o
​
 ld"="active"−o"stat_old" = "inactive" ]
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
s3=
(
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
−
�
ℎ
�
�
−
�
�
�
�
�
�
.
�
�
�
�
�
�
�
)
�
�
�
�
�
5
�
�
ℎ
�
"
�
�
�
�
�
�
�
�
�
�
�
−
�
ℎ
�
�
−
�
�
�
�
�
�
.
�
�
�
�
�
�
�
:
(systemctlstartisc−dhcp−server.service)sleep5echo"Startingisc−dhcp−server.service:s3"
sleep 3
s4=
(
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
−
�
ℎ
�
�
−
�
�
�
�
�
�
.
�
�
�
�
�
�
�
)
�
�
�
�
�
5
�
�
ℎ
�
"
�
�
�
�
�
�
�
�
�
�
�
�
�
−
�
ℎ
�
�
−
�
�
�
�
�
�
.
�
�
�
�
�
�
�
:
(systemctlrestartisc−dhcp−server.service)sleep5echo"Restartingisc−dhcp−server.service:s4"
sleep 3
killall -9 openvpn
sleep 3
/usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
echo "Restarting VPN fnsh"
fi

Добавлен код для проверки "Initialization Sequence Completed"
if grep -q "Initialization Sequence Completed" "$0"
then
echo "
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
!
�
�
�
�
�
�
�
�
ℎ
�
�
�
�
�
�
�
.
LIGHT 
C
​
 YANTunneliswork!Exitingthescript.{NC}"
exit 0
fi

Скрипт проверяет наличие строки "Initialization Sequence Completed" в самом себе, а не в выводе команды /sbin/ifconfig tun0. Из-за этого условие grep -q "Initialization Sequence Completed" "\$0" всегда будет истинным, если в скрипте есть строка "Initialization Sequence Completed".

Чтобы исправить это, вам нужно сохранить вывод команды /sbin/ifconfig tun0 в переменную и затем проверить эту переменную на наличие строки "Initialization Sequence Completed". Вот исправленный скрипт:

#!/bin/sh
# Зеленый цвет
LIGHT_CYAN="\033[1;36m"
# Сброс цвета
NC='\033[0m'
stat_old=$(systemctl status isc-dhcp-server.service | awk '/Active/{print \$2}')
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
tun0_output=$(/sbin/ifconfig tun0)
if echo "$tun0_output" | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
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
if echo "$tun0_output" | grep -q "Initialization Sequence Completed"
then
  echo "${LIGHT_CYAN}Tunnel is work! Exiting the script.${NC}"
  exit 0
fi
Обратите внимание, что я добавил переменную tun0_output, которая хранит вывод команды /sbin/ifconfig tun0, и затем проверяю эту переменную на наличие строки "Initialization Sequence Completed".

как добавить в данный скрипт цикл повторной проверки по всем командам с самого начала, пока не будет достигнут результат?

Вы можете использовать цикл while для повторения проверок до тех пор, пока не будет достигнут ожидаемый результат. Вот пример того, как это может выглядеть:

#!/bin/sh
# Зеленый цвет
LIGHT_CYAN="\033[1;36m"
# Сброс цвета
NC='\033[0m'

while true; do
    stat_old=$(systemctl status isc-dhcp-server.service | awk '/Active/{print \$2}')
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
    tun0_output=$(/sbin/ifconfig tun0)
    if echo "$tun0_output" | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
    then
        echo "Initialization Sequence Completed"
        echo "${LIGHT_CYAN}Tunnel is work! Exiting the script.${NC}"
        exit 0
    elif grep -E "^(/sbin/ifconfig eth0 0.0.0.0 0.0.0.0|dhclient)" /etc/rc.local
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
done
В этом примере цикл while true будет выполняться бесконечно, пока не будет вызвана команда exit 0 при успешной инициализации туннеля. Обратите внимание, что бесконечные циклы могут быть опасны, если в них нет проверки условия прерывания. В данном случае, если туннель никогда не будет успешно инициализирован, скрипт будет выполняться бесконечно.

как оптимизировать данный скрипт ?

Ваш скрипт уже достаточно хорош, но есть некоторые места, где можно его немного улучшить:

Использование функций: Вы можете вынести повторяющиеся действия в функции, чтобы избежать дублирования кода. Например, вы можете создать функцию для перезапуска OpenVPN.

Оптимизация sleep: Вместо использования sleep после каждой команды, можно использовать его только в тех местах, где это действительно необходимо. Иногда sleep используется для обеспечения того, чтобы предыдущая команда полностью завершилась перед выполнением следующей, но в некоторых случаях это может быть излишним.

Обработка ошибок: Ваш скрипт не обрабатывает ошибки, которые могут возникнуть при выполнении команд. Вы можете добавить проверки ошибок для каждой команды, чтобы убедиться, что она выполнилась успешно, и прервать скрипт или предпринять соответствующие действия в случае ошибки.

Оптимизация цикла: Вместо бесконечного цикла while true, можно ограничить количество попыток или добавить тайм-аут, чтобы избежать бесконечного выполнения скрипта в случае непредвиденных проблем.

Улучшение читаемости: Вы можете добавить комментарии к ключевым частям скрипта и использовать более понятные имена переменных, чтобы упростить понимание того, что делает каждая часть скрипта.

Вот пример оптимизированного скрипта, в котором учтены все эти предложения:

#!/bin/sh

# Зеленый цвет
LIGHT_CYAN="\033[1;36m"
# Сброс цвета
NC='\033[0m'

# Функция для перезапуска OpenVPN
restart_openvpn() {
    killall -9 openvpn
    sleep 3
    /usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
}

# Ограничиваем количество попыток
max_attempts=10
attempt=0

while [ $attempt -lt $max_attempts ]; do
    stat_old=$(systemctl status isc-dhcp-server.service | awk '/Active/{print \$2}')
    echo "Current status of isc-dhcp-server.service: $stat_old"

    if [ "$stat_old" = "active" -o "$stat_old" = "inactive" ]
    then
        if ping -c 5 172.81.0.1 >/dev/null 2>&1
        then
            echo "Ping successful"
        else
            echo "Rebooting VPN AFTER NO PING"
            restart_openvpn
        fi   
    fi

    tun0_output=$(/sbin/ifconfig tun0)
    if echo "$tun0_output" | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
    then
        echo "Initialization Sequence Completed"
        echo "${LIGHT_CYAN}Tunnel is work! Exiting the script.${NC}"
        exit 0
    elif grep -E "^(/sbin/ifconfig eth0 0.0.0.0 0.0.0.0|dhclient)" /etc/rc.local
    then
        /sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
        sleep 5
        restart_openvpn
        echo "Restarting VPN DHCP"
    else
        systemctl start isc-dhcp-server.service
        sleep 5
        echo "Starting isc-dhcp-server.service"
        sleep 3
        systemctl restart isc-dhcp-server.service
        sleep 5
        echo "Restarting isc-dhcp-server.service"
        restart_openvpn
        echo "Restarting VPN fnsh"
    fi

    attempt=$((attempt+1))
    echo "Attempt $attempt of $max_attempts failed. Retrying..."
    sleep 10
done

echo "Failed to initialize tunnel after $max_attempts attempts. Exiting script."
exit 1
Этот скрипт делает то же самое, что и ваш оригинальный скрипт, но с некоторыми улучшениями. Он ограничивает количество попыток до 10 и добавляет задержку в 10 секунд между попытками. Если после 10 попыток туннель так и не будет инициализирован, скрипт завершится с кодом ошибки 1.

#!/bin/sh

Зеленый цвет
LIGHT_CYAN="\033[1;36m"

Сброс цвета
NC='\033[0m'
stat_new=(systemctl status dnsmasq.service | awk '/Active/{print \2}')
echo "Current status of dnsmasq.service: $stat_new"
rest_VPN() {
killall -9 openvpn
sleep 3
/usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
}

max_attempts=3
attempt=0
while [ 
�
�
�
�
�
�
�
−
�
�
attempt−ltmax_attempts ]
do

if grep -E "^(/sbin/ifconfig eth0 0.0.0.0 0.0.0.0|dhclient)" /etc/rc.local
then
/sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
sleep 5
rest_VPN
echo "Restarting DHCP"
else
s1=
(
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
.
�
�
�
�
�
�
�
)
�
�
�
�
�
3
�
�
ℎ
�
"
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
.
�
�
�
�
�
�
�
:
(systemctlstartdnsmasq.service)sleep3echo"Startingdnsmasq.service:s1"
sleep 3
s2=
(
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
.
�
�
�
�
�
�
�
)
�
�
�
�
�
5
�
�
ℎ
�
"
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
.
�
�
�
�
�
�
�
:
(systemctlrestartdnsmasq.service)sleep5echo"Restartingdnsmasq.service:s2"
sleep 3
rest_VPN
echo "Restarting VPN"
fi

tun0_out=
(
/
�
�
�
�
/
�
�
�
�
�
�
�
�
�
�
�
0
)
�
�
�
�
ℎ
�
"
(/sbin/ifconfigtun0)ifecho"tun0_out" | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
#if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
echo "
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
!
�
�
�
�
�
�
�
�
ℎ
�
�
�
�
�
�
�
.
LIGHT 
C
​
 YANTunneliswork!Exitingthescript.{NC}"
exit 0
else
attempt=
(
(
�
�
�
�
�
�
�
+
1
)
)
�
�
ℎ
�
"
�
�
�
�
�
�
�
((attempt+1))echo"Attemptattempt of 
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
.
�
�
�
�
�
�
�
�
.
.
.
"
�
�
�
�
�
10
�
�
�
�
�
�
ℎ
�
"
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
�
max 
a
​
 ttemptsfailed.Retrying..."sleep10doneecho"FailedtoInitializetunnelaftermax_attempts attempts. Exiting script."
exit 1
исправь ошибки

Ваш скрипт содержит ошибку синтаксиса в конструкции if-else. Ветка else, которая увеличивает счетчик попыток и выводит сообщение о неудаче, должна быть внутри цикла while, но перед done. Также ветка else должна закрываться командой fi перед увеличением счетчика попыток. Вот исправленный вариант:

#!/bin/sh
# Зеленый цвет
LIGHT_CYAN="\033[1;36m"
# Сброс цвета
NC='\033[0m'
stat_new=$(systemctl status dnsmasq.service | awk '/Active/{print \$2}')
echo "Current status of dnsmasq.service: $stat_new"
rest_VPN() {
	killall -9 openvpn
	sleep 3
	/usr/sbin/openvpn --config /etc/openvpn/client.ovpn & >/dev/null 2>&1
	}

max_attempts=3
attempt=0
while [ $attempt -lt $max_attempts ]
do

if grep -E "^(/sbin/ifconfig eth0 0.0.0.0 0.0.0.0|dhclient)" /etc/rc.local
then
 	/sbin/ifconfig eth0 0.0.0.0 0.0.0.0 | dhclient & >/dev/null 2>&1
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

tun0_out=$(/sbin/ifconfig tun0)
if echo "$tun0_out" | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
     echo "${LIGHT_CYAN}Tunnel is work! Exiting the script.${NC}"
     exit 0
else
     attempt=$((attempt+1))
     echo "Attempt $attempt of $max_attempts failed. Retrying..."
     sleep 10
fi
done
echo "Failed to Initialize tunnel after $max_attempts attempts. Exiting script."
exit 1
Теперь ваш скрипт должен работать корректно.
