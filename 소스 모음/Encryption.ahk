;#############Copyright ⓒ ENM Soft#################
encryption(data){
	loop{
		aindex := a_index - 1
		stringleft, tempfilter, data, %a_index%
		loop %aindex%{
			tempdata := data%a_index%
			stringreplace, tempfilter, tempfilter, %tempdata%
		}
		if (tempfilter = ""){
			break
		}else{
			data%a_index% := tempfilter
			ascdata := Asc(tempfilter)
			ascdata += 495
			chrdata := Chr(ascdata)
			newdata = %newdata%%chrdata%
		}
	}
return newdata
}

decryption(data){
	loop{
		aindex := a_index - 1
		stringleft, tempfilter, data, %a_index%
		loop %aindex%{
			tempdata := data%a_index%
			stringreplace, tempfilter, tempfilter, %tempdata%
		}
		if (tempfilter = ""){
			break
		}else{
			data%a_index% := tempfilter
			ascdata := Asc(tempfilter)
			ascdata -= 495
			chrdata := Chr(ascdata)
			newdata = %newdata%%chrdata%
		}
	}
return newdata
}