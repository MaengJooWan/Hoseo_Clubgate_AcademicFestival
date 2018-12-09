#singleinstance Force

Voice(string){
	Voice := ComObjCreate("SAPI.SpVoice") 
	Voice.Speak(string)
return
}