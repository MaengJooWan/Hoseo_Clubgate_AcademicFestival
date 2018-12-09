#singleinstance Force
#include D:\프로그래밍 작업실\오토핫키 작업실\소스 모음\URL_Resource.ahk
#include D:\프로그래밍 작업실\오토핫키 작업실\소스 모음\Voice.ahk

Weather_System(){
	route = %a_scriptdir%\resource.enm
	resource := URL_Resource("http://www.kma.go.kr/weather/forecast/timeseries.jsp", route)
	if (resource = "error"){
		msgbox, 48, 경고, 인터넷 연결에 문제가 발생하였습니다.`n프로그램을 종료합니다
		exitapp
	}
	
	;####################데이터 쓰레기 처리#######################
	stringreplace, resource, resource, ", /, All
	loop{
		ifinstring, resource, now_weather1_right
		{
			regexmatch(resource, "now_weather1_right(.*?)>", trash)
			stringreplace, resource, resource, %trash%, /enm_start/
		}else{
			break
		}
	}
	;########################################################
	
	;######################데이터 추출###########################
	loop{
		regexmatch(resource, "/enm_start/(.*?)</dd>", tempfilter)
		if (tempfilter = ""){
			regexmatch(resource, "png25/ alt=/(.*?)/", tempfilter)
			now_weather := tempfilter1
			break
		}else{
			stringreplace, resource, resource, %tempfilter%
				if (a_index = 1){
				temperature := tempfilter1
			}else if (a_index = 2){
				wind_speed := tempfilter1
			}else if (a_index = 3){
				humidity := tempfilter1
			}else if (a_index = 4){
				precipitation := tempfilter1
				if (precipitation = "-"){
					precipitation := "에 대한 데이터가 존재하지 않습니다."
				}
			}else{
				trashdata = %trashdata%`n%tempfilter1%
			}
		}
	}
	;##########################################################
string = 현재날씨 : %now_weather%`n온도 : %temperature%`n풍속 : %wind_speed%`n습도 : %humidity%`n강수량 : %precipitation%
return %string%
}