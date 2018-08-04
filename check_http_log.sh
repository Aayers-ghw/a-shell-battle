#!/bin/bash
#Program function:Nginx's log analysis
resettem=$(tput sgr0)
Logfile_path='/opt/logs/nginx/access.log'
Check_http_status()
{
	Http_statu_codes=(`cat $Logfile_path | grep -ioE "HTTP\/1\.[1|0]\"[[:blank:]][0-9]{3}"||awk -F" [ ]+" '{
		 if($2>=100&&$2<200)
			{i++}
                 else if($2>=200&&$2<300)
                        {j++}
                 else if($2>=300&&$2<400)
                        {k++}
                 else if($2>=400&&$2<500)
                        {n++}
                 else if($2>=500)
                        {p++}
                 }END{
		print i?i:0,j?j:0,k?k:0,n?n:0,p?p:0,i+j+k+n+p
		}'
		`)

echo -e '\033[31m' "The number of http status[100+]:" ${resettem} ${Http_statu_codes[0]}
echo -e '\033[31m' "The number of http status[200+]:" ${resettem} ${Http_statu_codes[1]}
echo -e '\033[31m' "The number of http status[300+]:" ${resettem} ${Http_statu_codes[2]}
echo -e '\033[31m' "The number of http status[400+]:" ${resettem} ${Http_statu_codes[3]}
echo -e '\033[31m' "The number of http status[500+]:" ${resettem} ${Http_statu_codes[4]}
echo -e '\033[31m' "All request numbers:" ${resettem} ${Http_statu_codes[5]}

}

Check_http_code()
{
	Http_Code=(`cat $Logfile_path | grep -ioE "HTTP\/1\.[1|0]\"[[:blank:]][0-9]{3}"|awk -v total=0 -F '[ ]+''{
		if ($2!="")
			{code[$2]++;total++}
		else
			{exit}
		}END{
		print code[404]?code[404]:0,code[403]?code[403]:0,total
		}'
		`)

echo -e '\033[31m' "The number of http status[404]:" ${resettem} ${Http_Code[0]}
echo -e '\033[31m' "The number of http status[403]:" ${resettem} ${Http_Code[1]}
echo -e '\033[31m' "All request numbers:" ${resettem} ${Tttp_Code[2]}
}
Check_http_status
Check_http_code
