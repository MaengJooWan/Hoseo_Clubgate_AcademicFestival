#singleinstance Force
#include %a_scriptdir%\�ҽ� ����\URL_Resource.ahk
#include %a_scriptdir%\�ҽ� ����\String_Change.ahk

;################default variable######################
url := ""
count := 1
NBL := 100			;Naver Blog Limit ���� ���Ѽ�
detect_file := "keyword.txt"
helper_file := "No1_Crawling_Helper.ahk"
next_file := "No2_crawling_client.ahk"

global count, NBL, detect_file, helper_file, next_file
;#################################################

loop{
	ifexist, %a_scriptdir%\%detect_file%
	{
		gui, main:color, black
		gui, main:font, cyellow w600
		gui, main:add, progress, w300 vstatus_bar cred, 0
		gui, main:add, text, w300 vstatus_01 +center, no_data
		gui, main:show, autosize, crawling main client
		guicontrol, main:, status_01, Ű���� ���� �д� ��...
		fileread, keyword, %a_scriptdir%\%detect_file%
		filedelete, %a_scriptdir%\%detect_file%
		guicontrol, main:, status_01, Ű���� ���� �б� ����!
		break
	}
}

start:
	keyword := UrlEncode(keyword)
	progress_calc := 1000 / NBL
	progress_data := 0
	
	guicontrol, main:, status_01, �� ���� ���� ���� ��...
	docu_count := docu(keyword)
	if (docu_count = ""){
		guicontrol, main:, status_01, ���� ���� ���� ����
		msgbox, 48, ���, docu_count ���� ���� ������ �߻��߽��ϴ�.
		reload
	}else{
		guicontrol, main:, status_01, �� ���� ���� ���� ����!
		if (docu_count > NBL){
			fileappend, �� ���� ���� : @%NBL%@`n, %a_scriptdir%\url_data.txt
		}else{
			fileappend, �� ���� ���� : @%docu_count%@, %a_scriptdir%\url_data.txt
		}
	}
	
	loop{
		count := (a_index - 1) * 10 + 1
		if (count > NBL || count > docu_count){
			guicontrol, main:, status_01, ���� ���� �ִ�ġ�� �����߽��ϴ�.
			guicontrol, main:, status_bar, 100
			break
		}else{
			guicontrol, main:, status_01, %a_index%��° ������ ���� ��...
			fileappend, @%keyword%@@%count%@@%docu_count%@@%NBL%@, %a_scriptdir%\deli.txt
			loop{
				ifexist, %a_scriptdir%\deli.txt
				{
					run, %a_scriptdir%\%helper_file%
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
		}
		progress_data += progress_calc
		guicontrol, main:, status_bar, %progress_data%
		;msgbox, , , stop
	}
	
	run, %a_scriptdir%\%next_file%
	exitapp
return


	;#docu_count setting area			�� ���� ���� ����
docu(keyword){
	url = https://search.naver.com/search.naver?date_from=&date_option=0&date_to=&dup_remove=1&nso=&post_blogurl=&post_blogurl_without=&query=%keyword%&sm=tab_pge&srchby=all&st=sim&where=post&start=1
	resource := URL_Resource(url, a_scriptdir)
	error_check(resource)
	stringreplace, resource, resource, ", /, All
	regexmatch(resource, "title_num/>(.*?)</span>", temp_filter)
	regexmatch(temp_filter1, "/ (.*?)��", temp_filter)
	stringreplace, docu_count, temp_filter1, `,, , All
	return docu_count
}

error_check(resource){
	ifinstring, resource, �˻������ �����ϴ�
	{
		msgbox, 48, ���, �˻������ �����ϴ�.`n�ٸ� Ű����� �˻����ּ���
		reload
	}
}
	
mainguiclose:
ExitApp