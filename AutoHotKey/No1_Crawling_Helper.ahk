#singleinstance Off
#include %a_scriptdir%\소스 모음\URL_Resource.ahk

ifexist, %a_scriptdir%\deli.txt
{
	fileread, deli_data, %a_scriptdir%\deli.txt
	filedelete, %a_scriptdir%\deli.txt
	
	regexmatch(deli_data, "@(.*?)@", temp_filter)
	stringreplace, deli_data, deli_data, %temp_filter%
	keyword := temp_filter1
	
	regexmatch(deli_data, "@(.*?)@", temp_filter)
	stringreplace, deli_data, deli_data, %temp_filter%
	count := temp_filter1
	save_count := count
	
	regexmatch(deli_data, "@(.*?)@", temp_filter)
	stringreplace, deli_data, deli_data, %temp_filter%
	docu_count := temp_filter1
	
	regexmatch(deli_data, "@(.*?)@", temp_filter)
	NBL := temp_filter1
	
	url = https://search.naver.com/search.naver?date_from=&date_option=0&date_to=&dup_remove=1&nso=&post_blogurl=&post_blogurl_without=&query=%keyword%&sm=tab_pge&srchby=all&st=sim&where=post&start=%count%
	resource := URL_Resource(url, a_scriptdir)
	stringreplace, resource, resource, ", /, All
	stringreplace, resource, resource, (, /, All
	stringreplace, resource, resource, ), /, All
	;~ fileappend, %resource%, data.txt
	
	;#blog url extraction area
	loop{
		regexmatch(resource, "urlencode/this.href/// >(.*?)</a>", temp_filter)
		if (temp_filter = ""){
			break
		}else{
			stringreplace, resource, resource, %temp_filter%
			if (substr(temp_filter1, -2) = "..."){													;url 깨짐 수정 코드
				stringreplace, temp_filter1, temp_filter1, ...
				stringreplace, resource, resource, %temp_filter1%, /enm/
				regexmatch(resource, "/enm/(.*?)/", No2_temp_filter)
				stringreplace, resource, resource, %No2_temp_filter%, , All
				%count%_url = http://%temp_filter1%%No2_temp_filter1%
			}else{
				%count%_url = http://%temp_filter1%
			}
			count++
		}
		
		;#over pervent
		if (count > docu_count || count > NBL){
			break
		}
	}
	
	;#url save area
	loop{
		temp_data := %save_count%_url
		if (temp_data = ""){
			fileappend, %result_data%, %a_scriptdir%\url_data.txt
			break
		}else{
			result_data = %result_data%`n%save_count%번째 URL : @%temp_data%@
			save_count++
		}
	}
}