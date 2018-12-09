#include Encryption.ahk

ENM_Login(){
	FileEncoding,UTF-8
	
	;#######################초기 데이터######################
	LDr = %A_ProgramFiles%\ENM Soft\Image
	Blank := ""
	IDV := "ID"
	PWV := "Password"
	LoginFailCount = 0

	RegRead, ID, HKEY_CURRENT_USER, Software\ENM_soft, AutoLoginID
	RegRead, PW, HKEY_CURRENT_USER, Software\ENM_soft, AutoLoginPW
	;##########################암호화 해제#######################
	loop 2{
		newdata := ""

		if (a_index = 1){
			data := ID
		}else{
			data := PW
		}
		newdata := decryption(data)

		if (a_index = 1){
			IDV := newdata
		}else{
			PWV := newdata
		}
	}
	;########################################################
	;######################################################

	gui, Login:-caption
	gui, Login:Color, White
	gui, Login:Add, Pic, x0 y0 w210 h20, %LDr%\1.png
	gui, Login:Add, Pic, x210 y0 w20 h20 gLoginMinimize, %LDr%2.png
	gui, Login:Add, Pic, x230 y0 w20 h20 gLoginExit, %LDr%3.png
	gui, Login:Add, Pic, x0 y20 w250 h150, %LDr%4-1.png

	gui, Login:Font, CRed Bold
	gui, Login:Add, Text, x25 y30 w200 h20 +center, ENM 회원 ID를 입력 해 주세요
	gui, Login:Add, Text, x25 y75 w200 h20 +center, ENM 회원 PW를 입력 해 주세요

	gui, Login:Font, CBlue
	gui, Login:Add, Edit, x25 y50 w200 h20 +center vID gIDclick, %IDV%
	gui, Login:Add, Edit, x25 y95 w200 h20 +center vPW gPWclick Password, %PWV%
	gui, Login:Add, Button, x127 y120 w100 h30 gLogin, 로그인
	gui, Login:Add, Button, x25 y120 w100 h30 gNewMember, 회원가입

	gui, Login:Show,w250 h170, ENM Login
	Settimer, LoginActive, 100
	Return
	
	LoginActive:
		ifWinActive, ENM Login
		{
			Hotkey, Enter, Login, on
		}else{
			Hotkey, Enter, Login, off
		}
	Return
	
	NewMember:
		Run, http://www.enmsoftware.co.kr/index.php?mid=Main&act=dispMemberSignUpForm
	Return
	
	IDclick:
		gui, Login:Submit, nohide
		if (ID = "ID"){
			guicontrol, , ID, %Blank%
		}
	Return
	
	PWclick:
		gui, Login:Submit, nohide
		if (PW = "Password"){
			guicontrol, , PW, %Blank%
		}
	Return
	
	LoginMinimize:
		gui, Login:Minimize
	Return
	
	LoginExit:
	Loginguiclose:
	Exitapp
	
	Login:
		gui, Login:submit, Nohide
		if (ID = "" || PW = ""){
			msgbox, 48, 경고, 아이디 또는 비밀번호를 입력해주세요
			return
		}else{
			settimer, LoginActive, off
			Hotkey, Enter, Login, off

			data = user_id=%ID%&password=%PW%
			url = http://www.enmsoftware.co.kr/index.php?act=procMemberLogin
			ENM := ComobjCreate("WinHttp.WinHttpRequest.5.1")
			ENM.Open("POST",url)
			ENM.SetRequestHeader("Referer",url)
			ENM.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
			ENM.Send(Data)
			ENM.WaitForResponse
			ResponseData := ENM.ResponseText
	
			ifinstring, ResponseData, <div id="access">
			{
				LoginFailCount++
				regexmatch(responsedata, "<h1>(.*?)</h1>", tempfilter)
				stringreplace, tempfilter, tempfilter, <h1>, , All
				stringreplace, tempfilter, tempfilter, </h1>, , All
				outputdata := tempfilter
				msgbox, 48, 경고, %outputdata%
				if (LoginFailCount >= 4){
					Msgbox, 48, 경고,ID 혹은 PW를 4회이상 잘못입력하셨습니다.`n                    종료됩니다.
					Exitapp
				}else{
					settimer, LoginActive, 100
					return
				}
			}else{

				;######################데이터 암호화########################
				loop 2{
					resultdata := ""
					if (a_index = 1){
						data := ID
					}else{
						data := PW
					}
					newdata := encryption(data)

					if (a_index = 1){
						ID := newdata
					}else{
						PW := newdata
					}
				}
				;###############################################################
				RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\ENM_soft, AutoLoginID, %ID%
				RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\ENM_soft, AutoLoginPW, %PW%
				stringreplace, responsedata, responsedata, ", /, All
				stringreplace, responsedata, responsedata, alt=/
				regexmatch(responsedata, "alt=/(.*?)/", IDvalue)
				stringreplace, IDvalue, IDvalue, alt=/, , All
				stringreplace, IDvalue, IDvalue, /, , All
				gui, Login:Destroy
			}
		}
return IDvalue
}