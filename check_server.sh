#/bin/bash
#Program function: To check nginx and mysql 's running status.
Resettem=$(tput sgr0)
Nginxserver='http://127.0.0.1/nginx_status'
Mysql_Slave_Server='127.0.0.1'
Mysql_User='root'
Mysql_Pass='123456'

Check_Nginx_Server()
{
	Status_code=$(curl -m 5 -s -w %{http_code} ${Nginxserver} -o /dev/null)
	
	if [ $Status_code -eq 000 -o $Status_code -ge 500 ];then
		echo -e '\033[31m' "check http server error! Response status code is" $Resettem $Status_code
	else
		Http_content=$(curl -s ${Nginxserver})
		echo -e '\033[31m' "check http server is ok! \n" $Resettem $Http_content
	fi
}
Check_Mysql_Server()
{
	nc -z -w2 ${Mysql_Slave_Server} 3306 &> /dev/null
	if [ $? -eq 0 ];then
		mysql -u${Mysql_User} -p${Mysql_Pass} -h${Mysql_Slave_Server} -e "show slave status\G"|grep "Slave_IO_Running" | awk '{if($2!="Yes"){print "Slave thread not running!";exit 1}}'
		if [ $? -eq 0 ];then
		mysql -u${Mysql_User} -p${Mysql_Pass} -h${Mysql_Slave_Server} -e "show slave status\G"|grep "Sccons_Bebind_Master"
		fi
	else
		echo "Connect Mysql server not succeeded!" 
	fi
}

Check_Nginx_Server
Check_Mysql_Server
