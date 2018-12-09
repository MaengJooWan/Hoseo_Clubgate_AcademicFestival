#singleinstance Force
#include %a_scriptdir%\소스 모음\Time_Calc.ahk

;#####################default_variable########################
rank_num := 10
accu_count := 0
count := 0
time := 0
examp_count := 1				;계산 제외 카운트 수 (보다 같거나 작은 경우)
detect_file := "result.txt"
save_file := "rank.txt"
next_file := "No1_Crawling_Client.ahk"

global rank_num, accu_count, count, time, time_text, examp_count, detect_file, save_file
;#########################################################

gui, main:color, white
gui, main:font, cblack w600
gui, main:add, progress, w300 vstatus_bar cred, 0
gui, main:add, text, w300 vstatus +center, no_data
gui, main:add, text, w300 vstatus_2 +center, no_data
gui, main:add, text, w300 vstatus_3 +center, no_data
gui, main:show, autosize, sorting

loop{
	ifexist, %a_scriptdir%\%detect_file%
	{
		fileread, resource, %a_scriptdir%\%detect_file%
		if (resource != "" && resource != " "){
			filedelete, %a_scriptdir%\%detect_file%
			break
		}
	}
}
resource = @enm@%resource%@enm@
stringreplace, resource, resource, %a_space%, @enm@, All

start_time := 0
guicontrol, main:, status, 데이터 필터링 중 입니다
settimer, timer, 1000
loop{
	if ((time - start_time) > 1){
		start_time := time
	}
	if (save_time != time){
		save_time := time
		start_len := strlen(resource)
		guicontrol, main:, status_2, %start_len% 개 남음
		if (expact_time_text != ""){
		guicontrol, main:, status_3, 예상 시간 %time_text% / %expact_time_text% 남음
		}else{
			guicontrol, main:, status_3, %time_text% 소모됨
		}
	}
	regexmatch(resource, "@enm@(.*?)@enm@", temp_filter)
	if (temp_filter = ""){
		count := 0
		break
	}else{
		stringreplace, resource, resource, %temp_filter%, @enm@
		if (strlen(temp_filter1) > 1){
			ifnotinstring, accu_data, @enm@%temp_filter1%@enm@
			{
				accu_count++
				accu_data = %accu_data%@enm@%temp_filter1%@enm@
				%accu_count%_vocab := temp_filter1
				%accu_count%_count := 1
			}else{
				loop %accu_count%{
					if (%a_index%_vocab = temp_filter1){
						%a_index%_count++
						break
					}
				}
			}
		}
	}
	if (expact_time = "" && start_time != 0 && start_time != time){
		temp_data := (strlen(resource) // (start_len - strlen(resource)))
		temp := time - start_time
		expact_time := expact_time_calc(time, (strlen(resource) // (start_len - strlen(resource))))
		;msgbox, , , %temp%`n%temp_data%`n%expact_time%
		expact_time_text := time_calc((expact_time))
	}
}


time := 0
save_time := "nodata"
expact_time := ""
expact_time_text := ""
settimer, timer, 1000
loop %rank_num%{
	start_time := time
	aindex_2 := a_index
	temp_calc := accu_count  - aindex_2			;아래 loop 카운트 결정
	guicontrol, main:, status, 총 [%aindex_2% / %rank_num%]
	;~ if (%aindex_2%_count <= examp_count){
		;~ break
	;~ }
		
	loop %temp_calc%{
		temp_calc_2 := aindex_2 + a_index			;메인과 비교되는 vocab의 카운트
	
		if (save_time != time){
			save_time := time
			status_calc := a_index / temp_calc * 100
			guicontrol, main:, status_bar, %status_calc%
			guicontrol, main:, status_2, 현재 %temp_calc%개 중 %a_index%번째 진행 중
			if (expact_time_text != ""){
			guicontrol, main:, status_3, 예상 시간 %time_text% / %expact_time_text% 남음
			}else{
				guicontrol, main:, status_3, %time_text% 소모됨
			}
		}
		if (%temp_calc_2%_count > %aindex_2%_count){		;메인이 더 작을경우 교체 -> 1위 부터 정렬하는 것이기 때문에 거꾸로 셋팅함
			temp_vocab := %aindex_2%_vocab
			vocab_count := %aindex_2%_count
			temp_comparison := %temp_calc_2%_vocab
			comparison_count := %temp_calc_2%_count
			
			;~ msgbox, , , 스왑 전`ntemp_vocab : %temp_vocab%`nvocab_count : %vocab_count%`n`ntemp_comparison : %temp_comparison%`ncomparison_count : %comparison_count%
			%temp_calc_2%_vocab := temp_vocab
			%temp_calc_2%_count := vocab_count
			%aindex_2%_vocab := temp_comparison
			%aindex_2%_count := comparison_count
				
			/*
			temp_vocab := %aindex_2%_vocab
			vocab_count := %aindex_2%_count
			temp_comparison := %temp_calc_2%_vocab
			comparison_count := %temp_calc_2%_count
			msgbox, , , 스왑 후`ntemp_vocab : %temp_vocab%`nvocab_count : %vocab_count%`n`ntemp_comparison : %temp_comparison%`ncomparison_count : %comparison_count%
			*/
		}
	}
	if (expact_time = ""){
		expact_time := expact_time_calc((time - start_time), rank_num)
		expact_time_text := time_calc((expact_time))
	}
}
guicontrol, main:, status_bar, 100
settimer, timer, off
loop %rank_num%{
	temp_vocab := %a_index%_vocab
	temp_count := %a_index%_count
	result_text = %result_text%`n%a_index%위 : %temp_vocab%`t`t%temp_count% 회 언급
}

run, %a_scriptdir%\%next_file%
fileappend, %result_text%, %a_scriptdir%\%save_file%
msgbox, , , %result_text%
exitapp









enm_facto(num){
	result_calc := 1
	loop %num%{
		result_calc *= (num - a_index + 1)
	}
	return result_calc
}

enm_square(main, num){
	result_calc := 1
	loop %num%{
		result_calc *= main
	}
	return result_calc
}

timer:
	time++
	time_text := time_calc(time)
return

expact_time_calc(consume_num, result_num){			;걸린시간 / 총 개수
	expact_time := consume_num * result_num
	return expact_time
}
	

mainguiclose:
exitapp