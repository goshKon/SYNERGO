#!/bin/bash
LIGHT_CYAN="\033[1;36m"
YELLOW="\033[1;33m"
PINK="\033[38;5;211m"
ORANGE="\033[38;5;208m"
# Сброс цвета
NC='\033[0m'
ro=$(cat /proc/cpuinfo | grep "model name" | awk '{print $7}' | head -n 1) 
if [ "$ro" = "5" ]
then
ro="Orange"
else
ro="Raspberry"
fi

date_rasp=$(date +"%Y-%m-%d") # дата rasp
fmount.sh
echo "The current date $ro: ${date_rasp}" 
sleep 3
adb_result_formatted=$(adb shell date +"%Y-%m-%d") # переформатирование даты adb в красивый вид
adb_result="${adb_result_formatted}"
echo "The current date ADB: ${adb_result}" 
sleep 3

dev1=$(adb devices | grep "device" | awk '{print $2}' | grep "device") # поиск в команде "device"
	if [ -z "$dev1" ] # проверка на работоспособность ADB
then
echo "Device ADB no found"
else
echo "Device connected"

# проверка на пинг ADB
if ! adb shell ping -c 5 8.8.8.8 >/dev/null 2>&1
then
echo "Error: Failed to restore ping." # пинг ADB не идет 
exit 1
	fi

		if [ "$date_rasp" = "$adb_result_formatted" ] # проверка на корректность даты из adb в rasp
then
echo "Date is successfuly, the script is running."
sleep 3
else
echo "Date is not successfuly, updating the date on $ro."
sleep 3
# Текущая дата и время с adb shell
adb_result="${adb_result_formatted} $(date +"%T")"
#Извлечь год, месяц, день, часы, минуты и секунды
year=$(echo "$adb_result" | cut -d'-' -f1)
month=$(echo "$adb_result" | cut -d'-' -f2)
day=$(echo "$adb_result" | cut -d'-' -f3 | cut -d' ' -f1)
hour=$(echo "$adb_result" | cut -d' ' -f2 | cut -d':' -f1)
minute=$(echo "$adb_result" | cut -d':' -f2)
second=$(echo "$adb_result" | cut -d':' -f3)

# Сформировать строку с новым форматом
formatted_date="${year}-${month}-${day} ${hour}:${minute}:${second}"
# Установить дату на Raspberry Pi
date -s "${formatted_date}"

# Вывести результат
echo "Date and time are set to $ro: ${formatted_date}"
sleep 3
		fi
	fi
tun0_out=$(/sbin/ifconfig tun0)
if echo "$tun0_out" | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
echo "${LIGHT_CYAN}Tunnel is work! Exiting the script.${NC}"
if grep -E "^(/sbin/ifconfig eth0 0.0.0.0 0.0.0.0|dhclient)" /etc/rc.local >/dev/null 2>&1
then
    # Проверяем наличие строки "netmask" в выводе команды ifconfig для интерфейса eth0
eth0_info=$(ifconfig eth0 | grep "netmask" | awk '{print $3}')

# Если в выводе нет строки "netmask"...
if [ -z "$eth0_info" ]
then
    echo "${LIGHT_CYAN}IPv4 not found, Restarting...${NC}"
    if [ "$ro" = 3 ]
    then
        echo "${YELLOW}Restarting ${PINK}dhcpcd${NC}"
        systemctl restart dhcpcd
    else 
        dhclient -r eth0 && dhclient eth0
        echo "${YELLOW}Restarting ${ORANGE}dhclient${NC}"
        sleep 3
    fi
else
    echo "${LIGHT_CYAN}IPv4 found, Exiting...${NC}"
fi

if [ "$ro" = "${ORANGE}Orange${NC}" ]
then  
    echo "Starting orange script"
    sleep 3
    sh /etc/scripts/orange.sh
else
    echo "Starting rasp script"
    sleep 3
    sh /etc/scripts/rasp.sh
