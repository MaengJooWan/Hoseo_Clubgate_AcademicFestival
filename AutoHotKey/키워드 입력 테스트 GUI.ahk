#singleinstance Force
FileEncoding, UTF-8

gui, main:color, white
gui, main:font, cblack w600
gui, main:add, text, w300 vstatus +center, 키워드를 입력하세요
gui, main:add, edit, w300 vdata +center, 
gui, main:add, button, w300 gstart, 시작
gui, main:show, autosize, crawling_main_client
return

mainguiclose:
ExitApp

start:
	gui, main:submit, nohide
	filedelete, %a_scriptdir%\keyword.txt
	fileappend, %data%, %a_scriptdir%\keyword.txt
	exitapp
return