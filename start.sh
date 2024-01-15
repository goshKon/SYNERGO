#!/bin/bash
# Зеленый цвет
LIGHT_CYAN="\033[1;36m"
# Красный цвет
RED='\033[0;31m'
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
sleep 4
adb_result_formatted=$(adb shell date +"%Y-%m-%d") # переформатирование даты adb в красивый вид
adb_result="${adb_result_formatted}"
echo "The current date ADB: ${adb_result}" 
sleep 4

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
sleep 4
else
echo "Date is not successfuly, updating the date on $ro."
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

		fi
	fi
if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"
then
echo "Initialization Sequence Completed"
elif
[ "$ro" = "Orange" ]
then  
	echo "Starting orange script"
 	sleep 5
	sh /etc/scripts/orange.sh
 	
else
	echo "Starting rasp script"
 	sleep 5
	sh /etc/scripts/rasp.sh
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

