#!/bin/bash
#Program function:A Shell Script to Monitor Network,Disk Usage,Uptime,LocaAverage and RAM Usage in Linxu.
clear
if [[ $# -eq 0  ]]
then
#Define Variable reset_terminal
reset_terminal=$(tput sgr0)

#Check OS Tyoe
	os=$(uname -o)
	echo -e '\033[31m' "Check OS Tyoe: " $reset_terminal $os
#Check OS Release Version and Name
	os_name=$(cat /etc/issue | grep -e "Final" | cut -d " " -f 1,2,3)
	echo -e '\033[31m' "Check OS Release Version and Name: " $reset_terminal $os_name
#Check Architecture
	architecture=$(uname -m)
	echo -e '\033[31m' "Check Architecture: " $reset_terminal $architecture
#Check Kernel Release
	Kernelrelease=$(uname -r)
	echo -e '\033[31m' "Check Kernel Release: " $reset_terminal $Kernelrelease
#Check hostname
	hostname=$(uname -n)
	echo -e '\033[31m' "Check hostname: " $reset_terminal $hostname
#Check Intenal IP
	internalip=$(hostname -I)
	echo -e '\033[31m' "Check Intenal IP: " $reset_terminal $internalip
#Check External IP
	externalip=$(curl -s http://ipecho.net/plain)
	echo -e '\033[31m' "Check External IP: " $reset_terminal $externalip
#Check DNS
	nameservers=$( cat /etc/resolv.conf |grep -E "\<nameserver[ ]+"|awk '{print $NF}')
	echo -e '\033[31m' "Check DNS: " $reset_terminal $nameservers
#Check if connected to Internet or not
	ping -c 3 www.baidu.com &> /dev/null && echo "Internet:Connected" || echo "Internet:Disconnected"
#Check Logged In Users
	who>/tmp/who
	echo -e '\033[31m' "Logged In Users" $reset_terminal && cat /tmp/who
	rm -rf /tmp/who

##########################################
	system_mem_usages=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}END{print (total-free)/1024}' /proc/meminfo )
	apps_mem_usages=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}/^Cached/{cached=$2}/Buffers/{buffers=$2}END{print (total-free-cached-buffers)/1024}' /proc/meminfo)
	echo -e '\033[31m' "system memuserages " $reset_terminal $system_mem_usages
	echo -e '\033[31m' "system memuserages " $reset_terminal $apps_mem_usages
	loadaverge=$(top -n 1 -b | grep "load average:" | cut -d " " -f 13,14,15)
	echo -e '\033[31m' "load averges: " $reset_terminal $loadaverge
	diskavege=$(df -hP|grep -vE '文件系统|tmpfs' | awk '{print $1 " " $5}')
	echo -e '\033[31m' "disk averges: " $reset_terminal $diskavege




fi
