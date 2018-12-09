import ftplib
import os

ftp = ftplib.FTP("183.111.182.211","kwg0114","rpdlxm486")
ftp.cwd("gate_project")


try:
    link = os.getcwd()
    filename = "result.txt"
    fd = open(link + "\\" + filename, 'wb')
    ftp.retrbinary("RETR result.txt", fd.write)
    print("파일 다운로드 성공!!")
    fd.close()
except:
    print("파일 다운로드 실패!!")



