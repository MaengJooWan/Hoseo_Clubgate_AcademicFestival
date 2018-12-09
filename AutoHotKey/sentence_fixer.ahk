#singleinstance Off
#include %a_scriptdir%\소스 모음\URL_Resource.ahk
FileEncoding, 

;##############default_variable###############
once_size := 480
detect_file := "result.txt"
next_file := "sorting.ahk"

global once_size, detect_file, next_file
;##########################################

gui, main:color, black
gui, main:font, cyellow w600
gui, main:add, progress, w300 vstatus_bar cred, 0
gui, main:add, text, w300 vstatus_01 +center, 0
gui, main:show, autosize, Sentence Fixer


loop{
	process, exist, No2_Crawling_Helper.exe
	if (errorlevel = 0){
		ifexist, %a_scriptdir%\big_data.txt
		{
			fileread, resource, %a_scriptdir%\big_data.txt
			filedelete, %a_scriptdir%\big_data.txt
			break
		}
	}
}
stringlen, result_size, resource
temp_calc := 100 / (result_size / once_size)
ENM := ComobjCreate("WinHttp.WinHttpRequest.5.1")

loop{
	stringlen, result_size, resource
	stringleft, LF_data, resource, %once_size%
	if (LF_data != ""){
		clipboard := LF_data
		stringreplace, resource, resource, %LF_data%
	}else{
		ifexist, %a_scriptdir%\%detect_file%
		{
			run, %a_scriptdir%\%next_file%
			exitapp
		}else if (status_data != "on"){
			status_data := "on"
			run, %a_scriptdir%\py_run.bat
		}
	}
	
	url = https://m.search.naver.com/p/csearch/ocontent/spellchecker.nhn?_callback=jQuery112402789366337842146_1538976238937&q=%LF_data%
	
	
	ENM.Open("GET", url)
	ENM.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
	ENM.Send()
	new_resource := ENM.ResponseText
	;msgbox, ,  , %new_resource%
	
	stringreplace, new_resource, new_resource, `", /, All
	regexmatch(new_resource, "notag_html/:/(.*?)/", temp_filter)
	fileappend, %temp_filter1%, new_data.txt
;	result_data = %result_data% %temp_filter1%
;	msgbox, , , original_data : %LF_data%`n`nfileter : %result_data%
	calc_data += temp_calc
	guicontrol, main:, status_bar, %calc_data%
	guicontrol, main:, status_01, %result_size%개 남음
}


	

mainguiclose:
exitapp