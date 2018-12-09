import ftplib
import os

#파일 경로 가지고 오기
link = os.getcwd()
fname = "result.txt"
File2Send = link + "\\" + fname
print(File2Send)

try:
    #FTP 셋팅
    ftp = ftplib.FTP("183.111.182.211","kwg0114","rpdlxm486")
    ftp.cwd("gate_project")
    file = open(File2Send, "rb")
    ftp.storbinary("STOR result.txt", file)
    print("파일 전송 중....")
    ftp.quit()
    ftp.close()
    print("파일 전송 성공!!")
except:
    print("파일 전송 실패!!")


