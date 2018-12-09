#singleinstance Force
#include %a_scriptdir%\소스 모음\URL_Resource.ahk
#include %a_scriptdir%\소스 모음\String_Change.ahk

;################default variable######################
url := ""
count := 1
NBL := 100			;Naver Blog Limit 문서 제한수
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
		guicontrol, main:, status_01, 키워드 파일 읽는 중...
		fileread, keyword, %a_scriptdir%\%detect_file%
		filedelete, %a_scriptdir%\%detect_file%
		guicontrol, main:, status_01, 키워드 파일 읽기 성공!
		break
	}
}

start:
	keyword := UrlEncode(keyword)
	progress_calc := 1000 / NBL
	progress_data := 0
	
	guicontrol, main:, status_01, 총 문서 개수 추출 중...
	docu_count := docu(keyword)
	if (docu_count = ""){
		guicontrol, main:, status_01, 문서 개수 추출 에러
		msgbox, 48, 경고, docu_count 추출 도중 에러가 발생했습니다.
		reload
	}else{
		guicontrol, main:, status_01, 총 문서 개수 추출 성공!
		if (docu_count > NBL){
			fileappend, 총 문서 개수 : @%NBL%@`n, %a_scriptdir%\url_data.txt
		}else{
			fileappend, 총 문서 개수 : @%docu_count%@, %a_scriptdir%\url_data.txt
		}
	}
	
	loop{
		count := (a_index - 1) * 10 + 1
		if (count > NBL || count > docu_count){
			guicontrol, main:, status_01, 문서 개수 최대치에 도달했습니다.
			guicontrol, main:, status_bar, 100
			break
		}else{
			guicontrol, main:, status_01, %a_index%번째 스레드 실행 중...
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
			guicontrol, main:, status_01, %a_index%번째 스레드 실행 성공!
		}
		progress_data += progress_calc
		guicontrol, main:, status_bar, %progress_data%
		;msgbox, , , stop
	}
	
	run, %a_scriptdir%\%next_file%
	exitapp
return


	;#docu_count setting area			총 문서 개수 추출
docu(keyword){
	url = https://search.naver.com/search.naver?date_from=&date_option=0&date_to=&dup_remove=1&nso=&post_blogurl=&post_blogurl_without=&query=%keyword%&sm=tab_pge&srchby=all&st=sim&where=post&start=1
	resource := URL_Resource(url, a_scriptdir)
	error_check(resource)
	stringreplace, resource, resource, ", /, All
	regexmatch(resource, "title_num/>(.*?)</span>", temp_filter)
	regexmatch(temp_filter1, "/ (.*?)건", temp_filter)
	stringreplace, docu_count, temp_filter1, `,, , All
	return docu_count
}

error_check(resource){
	ifinstring, resource, 검색결과가 없습니다
	{
		msgbox, 48, 경고, 검색결과가 없습니다.`n다른 키워드로 검색해주세요
		reload
	}
}
	
mainguiclose:
ExitApp