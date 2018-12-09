time_calc(second){
	if (second >= 86400){
		daysdata := second // 86400
		daysdata = %daysdata%일
		tempmod := Mod(second, 86400)
		second := tempmod
	}
	if (second >= 3600){
		hourdata := second // 3600
		hourdata = %hourdata%시간
		tempmod := Mod(second, 3600)
		second := tempmod
	}
	if (second >= 60){
		mindata := second // 60
		mindata = %mindata%분
		tempmod := Mod(second, 60)
		second := tempmod
	}
	if (second <= 0){
		secdata := 0
	}else{
		secdata := second
	}
	secdata = %secdata%초
	if (daysdata != "" && hourdata = ""){
		hourdata := "0시간"
	}
	if (hourdata != "" && mindata = ""){
		mindata := "0분"
	}
	resultdata = %daysdata% %hourdata% %mindata% %secdata%
return resultdata
}