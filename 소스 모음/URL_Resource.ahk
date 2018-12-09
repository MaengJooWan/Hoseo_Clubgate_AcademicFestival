FileEncoding, UTF-8

URL_Resource(url, route){
	random, rand_data, 0, 495495495495
	loop{
		urldownloadtofile, %url%, %route%\%rand_data%resource.txt
		ifexist, %route%\%rand_data%resource.txt
		{
			fileread, resource, %route%\%rand_data%resource.txt
			filedelete, %route%\%rand_data%resource.txt
			break
		}else{
			if (a_index >= 5){
				return error
			}
		}
	}
return %resource%
}