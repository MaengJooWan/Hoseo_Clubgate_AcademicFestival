#singleinstance Off
#include %a_scriptdir%\소스 모음\URL_Resource.ahk

ifexist, %a_scriptdir%\deli.txt
{
	fileread, deli_data, %a_scriptdir%\deli.txt
	filedelete, %a_scriptdir%\deli.txt
	
	regexmatch(deli_data, "@(.*?)@", temp_filter)
	stringreplace, deli_data, deli_data, %temp_filter%
	url_data := temp_filter1
	
	new_resource := URL_Resource(url_data, a_scriptdir)
	;msgbox, , , %new_resource%
	
	ifnotinstring, new_resource, PostView.nhn						;티스토리 이글루 추가할거면 여기서
	{
		ifinstring, new_resource, 네이버 블로그
		{
			stringreplace, new_resource, new_resource, ', /, All
			regexmatch(new_resource, "src=/(.*?) />", temp_filter)
			;msgbox, , , %temp_filter1%

			new_resource := URL_Resource(temp_filter1, a_scriptdir)
			;filedelete, data.txt
			;fileappend, %new_resource%, data.txt
			;msgbox, , , stop
		}
	}
		
	ifinstring, new_resource, PostView.nhn
	{
		stringreplace, new_resource, new_resource, `", /, All
		regexmatch(new_resource, "mainFrame/ src=/(.*?)/ scrolling", temp_filter)
		temp_filter1 = https://blog.naver.com%temp_filter1%
	}
	;msgbox, , , %temp_filter1%
		
	new_resource := URL_Resource(temp_filter1, a_scriptdir)
		
	;#초기 필수 필터링
	stringreplace, new_resource, new_resource, `n, , All
	stringreplace, new_resource, new_resource, `", /enm_quote/, All
	loop{
		regexmatch(new_resource, "<div style=/enm_quote/text-align(.*?)>", temp_filter)
		if (temp_filter = ""){
			break
		}else{
			stringreplace, new_resource, new_resource, %temp_filter%, /enm_div/, All
		}
	}
		
	loop{																										;<p style="TEXT-ALIGN: center" align="center"> 같은거 <p> 로 변환
		regexmatch(new_resource, "<p (.*?)>", temp_filter)
		if (temp_filter = ""){
			break
		}else{
			ifnotinstring, temp_filter, postAddDate
			{
				ifnotinstring, temp_filter, subtext
				{
					ifnotinstring, temp_filter, nodt_post
					{
						stringreplace, new_resource, new_resource, %temp_filter%, <p>, All
					}else{
						stringreplace, new_resource, new_resource, %temp_filter%, /enm_error/
					}
				}else{
					stringreplace, new_resource, new_resource, %temp_filter%, /enm_error/
				}
			}else{
				stringreplace, new_resource, new_resource, %temp_filter%, /enm_error/
			}
		}
	}
		
	loop{																										;대문자임 <P style="TEXT-ALIGN: center" align="center"> 같은거 <p> 로 변환
		regexmatch(new_resource, "<P (.*?)>", temp_filter)
		if (temp_filter = ""){
			break
		}else{
			ifnotinstring, temp_filter, postAddDate
			{
				ifnotinstring, temp_filter, subtext
				{
					stringreplace, new_resource, new_resource, %temp_filter%, <P>, All
				}else{
					stringreplace, new_resource, new_resource, %temp_filter%, /enm_error/
				}
			}else{
				stringreplace, new_resource, new_resource, %temp_filter%, /enm_error/
			}
		}
	}
		
	loop{																										;대문자임 <DIV align="center"> 같은거 <P> 로 변환
		regexmatch(new_resource, "<DIV align(.*?)>", temp_filter)
		if (temp_filter = ""){
			break
		}else{
			stringreplace, new_resource, new_resource, %temp_filter%, <P>, All
		}
	}
	;filedelete, data.txt
	;fileappend, %new_resource%, data.txt
	;msgbox, , , stop
		
	loop{
		regexmatch(new_resource, "<p>(.*?)</p>", temp_filter)
		if (temp_filter = ""){
			result_data := filtering(result_data)
			break
		}else{
			stringreplace, new_resource, new_resource, %temp_filter%
			ifnotinstring, temp_filter1, 퀵에디터
			{
				ifnotinstring, temp_filter1, Adobe Flash Plugin
				{
					ifnotinstring, temp_filter1, 서재안에 글
					{
						;msgbox, , , tempfilter : %tempfilter%
						result_data = %result_data% %temp_filter1%
					}
				}
			}
		}
	}
		
	if (result_data = "" || result_data = " "){
		result_data := ""
		loop{
			regexmatch(new_resource, "<P>(.*?)</P>", temp_filter)
			if (temp_filter = ""){
				result_data := filtering(result_data)
				break
			}else{
				stringreplace, new_resource, new_resource, %temp_filter%
				ifnotinstring, temp_filter1, 퀵에디터
				{
					;msgbox, , , tempfilter : %temp_filter%
					result_data = %result_data% %temp_filter1%
				}
			}
		}
	}
		
	loop{																										;대문자임 <DIV align="center"> 같은거 <P> 로 변환
		ifinstring, new_resource, /enm_div/
		{
			regexmatch(new_resource, "/enm_div/(.*?)</div>", temp_filter)
			stringreplace, new_resource, new_resource, %temp_filter%
			ifnotinstring, temp_filter1, 퀵에디터
			{
				;msgbox, , , tempfilter : %temp_filter%
				result_data = %result_data% %temp_filter1%
			}
		}else{
			result_data := filtering(result_data)
			break
		}
	}
	
	;msgbox, , , [%result_data%]
	FileEncoding, 
	fileappend, %result_data%`n, %a_scriptdir%\big_data.txt
	exitapp
}



filtering(resource){
	;msgbox, , , %resource%
	;#반복 데이터 제거 영역
	loop{
		regexmatch(resource, "<span(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<SPAN(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<img src(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<a class(.*?)</a>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<br style(.*?)/>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<a target(.*?)</A>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<U>(.*?)</U>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<iframe(.*?)</IFRAME>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<iframe(.*?)</iframe>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<a href(.*?)</a>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<strong style(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<!-- Not Allowed(.*?)>", tempfilter)
		if (tempfilter = ""){
			;msgbox, , , %resource%
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<object(.*?)</object>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<OBJECT(.*?)</OBJECT>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<param name(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<PARAM NAME(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<embed(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<EMBED(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<input type(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<img id(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<div class(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<div id(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<div style(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<font(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<FONT(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<blockquote(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<td style(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<table(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<b style(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<a target(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "</EMBED(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
		
	loop{
		regexmatch(resource, "<a title(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}
	
	loop{
		regexmatch(resource, "<strong class(.*?)>", tempfilter)
		if (tempfilter = ""){
			break
		}else{
			stringreplace, resource, resource, %tempfilter%, , All
		}
	}

	
	
	;#데이터 감지시 반복 변환/제거 영역 No1
	/*
	loop{
		ifinstring, resource, ..
		{
			stringreplace, resource, resource, .., ., All
		}else{
			break
		}
	}
	*/
	
	;#데이터 완전 삭제 영역
	stringreplace, resource, resource, ▲, , All
	stringreplace, resource, resource, ▼, , All
	stringreplace, resource, resource, ※, , All
	stringreplace, resource, resource, ☆, , All
	stringreplace, resource, resource, ★, , All
	stringreplace, resource, resource, ♡, , All
	stringreplace, resource, resource, ♥, , All
	stringreplace, resource, resource, </a>, , All
	stringreplace, resource, resource, </br>, , All
	stringreplace, resource, resource, <div>, , All
	stringreplace, resource, resource, </div>, , All
	stringreplace, resource, resource, </embed>, ,All
	stringreplace, resource, resource, </span>, , All
	stringreplace, resource, resource, ㅋ, , All
	stringreplace, resource, resource, ㅎ, , All
	stringreplace, resource, resource, ㅇ, , All
	stringreplace, resource, resource, ㅁ, , All
	stringreplace, resource, resource, ㄴ, , All
	stringreplace, resource, resource, ㄹ, , All
	stringreplace, resource, resource, ㄷ, , All
	stringreplace, resource, resource, ㅠ, , All
	stringreplace, resource, resource, ㅜ, , All
	stringreplace, resource, resource, ㅂ, , All
	stringreplace, resource, resource, ㅡ, , All
	stringreplace, resource, resource, `;, , All
	stringreplace, resource, resource, &#65279, , All
	stringreplace, resource, resource, &#20081, , All
	stringreplace, resource, resource, &#32210, , All
	stringreplace, resource, resource, &#24403, , All
	stringreplace, resource, resource, &#32435, , All
	stringreplace, resource, resource, &#20250, , All
	stringreplace, resource, resource, &#24456, , All
	stringreplace, resource, resource, &#20852, , All
	stringreplace, resource, resource, &#20010, , All
	stringreplace, resource, resource, &#35753, , All
	stringreplace, resource, resource, &#20204, , All
	stringreplace, resource, resource, &#21543, , All
	stringreplace, resource, resource, &#12540, , All
	stringreplace, resource, resource, <STRIKE>, , All
	stringreplace, resource, resource, </STRIKE>, , All
	stringreplace, resource, resource, </FONT>, , All
	stringreplace, resource, resource, <EM>, , All
	stringreplace, resource, resource, </EM>, , All
	stringreplace, resource, resource, <tr>, , All
	stringreplace, resource, resource, </tr>, , All
	stringreplace, resource, resource, </td>, , All
	stringreplace, resource, resource, =, , All
	stringreplace, resource, resource, +, , All
	stringreplace, resource, resource, <b>, , All
	stringreplace, resource, resource, <u>, , All
	stringreplace, resource, resource, </b>, , All
	stringreplace, resource, resource, </u>, , All
	;filedelete, data.txt
	;fileappend, %resource%, data.txt
	;msgbox, , , stop
	stringreplace, resource, resource, <!--quote_txt-->, , All
	stringreplace, resource, resource, < `} SE3 TEXT >, , All
	stringreplace, resource, resource, < SE3 TEXT `{ >, , All
	;msgbox, , , %resource%
	
	
	;#데이터 스페이스 변환 영역
	stringreplace, resource, resource, &nbsp, %a_space%, All
	stringreplace, resource, resource, &amp, %a_space%, All
	stringreplace, resource, resource, &lt, %a_space%, All
	stringreplace, resource, resource, &gt, %a_space%, All
	stringreplace, resource, resource, <br>, %a_space%, All
	stringreplace, resource, resource, ', %a_space%, All
	stringreplace, resource, resource, `", %a_space%, All
	stringreplace, resource, resource, (, %a_space%, All
	stringreplace, resource, resource, ), %a_space%, All
	stringreplace, resource, resource, %a_tab%, %a_space%, All
	stringreplace, resource, resource, `n, %a_space%, All
	stringreplace, resource, resource, `r, %a_space%, All
	stringreplace, resource, resource, `,, %a_space%, All
	stringreplace, resource, resource, ., %a_space%, All
	stringreplace, resource, resource, !, %a_space%, All
	stringreplace, resource, resource, :, %a_space%, All
	stringreplace, resource, resource, ^, %a_space%, All
	stringreplace, resource, resource, ?, %a_space%, All
	stringreplace, resource, resource, [, %a_space%, All
	stringreplace, resource, resource, ], %a_space%, All
	stringreplace, resource, resource, ~, %a_space%, All
	stringreplace, resource, resource, -, %a_space%, All
	stringreplace, resource, resource, |, %a_space%, All
	stringreplace, resource, resource, _, %a_space%, All
	stringreplace, resource, resource, -, %a_space%, All
	stringreplace, resource, resource, `", %a_space%, All
	stringreplace, resource, resource, ', %a_space%, All

	
	;msgbox, , ,No1`n%resource%
	;#쓰레기 데이터 제거 영역
	resource = %resource%/enm_end/
	regexmatch(resource, "<strong>이 블로그(.*?)/enm_end/", tempfilter)
	stringreplace, resource, resource, %tempfilter%
	regexmatch(resource, "안녕하세요 <br/>이 포스트(.*?)/enm_end/", tempfilter)
	stringreplace, resource, resource, %tempfilter%
	regexmatch(resource, "이 포스트는 네이버 블로그에서(.*?)/enm_end/", tempfilter)
	stringreplace, resource, resource, %tempfilter%
	stringreplace, resource, resource, /enm_end/
	stringreplace, resource, resource, <STRONG>, , All
	stringreplace, resource, resource, </STRONG>, , All
	stringreplace, resource, resource, 출처, , All
	stringreplace, resource, resource, 작성자, , All
	stringreplace, resource, resource, <p>, , All
	stringreplace, resource, resource, </P>, , All
	stringreplace, resource, resource, <br />, , All
	stringreplace, resource, resource, /enm quote/, , All
	
	
	;#데이터 감지시 반복 변환/제거 영역 No2
	loop{
		ifinstring, resource, %a_space%%a_space%
		{
			stringreplace, resource, resource, %a_space%%a_space%, %a_space%, All
		}else{
			break
		}
	}
	
	return resource
}