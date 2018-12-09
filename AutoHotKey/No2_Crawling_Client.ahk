#singleinstance Force
#include %a_scriptdir%\�ҽ� ����\URL_Resource.ahk

;####################default variable#####################
count := 0
helper_file := "No2_Crawling_Helper.ahk"
next_file := "sentence_fixer.ahk"
detect_file := "big_data.txt"

global count
;####################################################

loop{
	ifexist, %a_scriptdir%\url_data.txt
	{
		gui, main:color, black
		gui, main:font, cyellow w600
		gui, main:add, progress, w300 vstatus_bar cred, 0
		gui, main:add, text, w300 vstatus_01 +center, no_data
		gui, main:show, autosize, crawling main client
		guicontrol, main:, status_01, URL_DATA ���� �д� ��...
		fileread, resource, %a_scriptdir%\url_data.txt
		filedelete, %a_scriptdir%\url_data.txt
		regexmatch(resource, "@(.*?)@", temp_filter)
		stringreplace, resource, resource, %temp_filter%
		docu_count := temp_filter1
		guicontrol, main:, status_01, URL_DATA ���� �б� ����!
		break
	}
}

loop{
	guicontrol, main:, status_01, %a_index% / %docu_count% URL ���� ��...
	regexmatch(resource, "@(.*?)@", temp_filter)
	if (temp_filter = ""){
		break
	}else{		;#url_data���� ���� �Ϸ����� ���
		;msgbox, , , %temp_filter1%
		stringreplace, resource, resource, %temp_filter%
		guicontrol, main:, status_01, %a_index% / %docu_count% ������ ���� ��...
		fileappend, @%temp_filter1%@, %a_scriptdir%\deli.txt
		loop{
			ifexist, %a_scriptdir%\deli.txt
			{
				run, %a_scriptdir%\%helper_file%
				;msgbox, , , stop
				loop{
					ifnotexist, %a_scriptdir%\deli.txt
					{
						break
					}
				}
				break
			}
		}
		guicontrol, main:, status_01, %a_index%��° ������ ���� ����!
		temp_calc := a_index / docu_count * 100
		guicontrol, main:, status_bar, %temp_calc%
	}
}

loop{
	run, %a_scriptdir%\%next_file%
	break
}


mainguiclose:
ExitApp