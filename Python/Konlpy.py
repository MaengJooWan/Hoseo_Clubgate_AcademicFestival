from konlpy.tag import Hannanum
from konlpy.tag import Kkma
from konlpy.tag import Twitter
from os import getcwd
import time
import jpype
from threading import Thread
from os import remove

result_value = []
twitter = Twitter()
hannanum = Hannanum()
kkma = Kkma()


def do_concurrent_tagging(start,end,lines,result):
    jpype.attachThreadToJVM()
    l = [twitter.nouns(lines[i]) for i in range(start,end)]
    result_value.append(l)
    return

def file_read():
    #경로 가지고 오기
    link = getcwd()

    #크롤링한 파일 오픈
    lines = open(link + "/new_data.txt").read().splitlines()
    nlines = len(lines)

    print("파일 읽기 완료!")

    return lines, nlines

#형태소 변환
def noun(file_range,file_content):
    print("변환 작업 실행 중...")
    s = time.clock()

    t1 = Thread(target=do_concurrent_tagging, args=(0,int(nlines/3),lines,result_value))
    t2 = Thread(target=do_concurrent_tagging,args=(int(nlines/3),int(nlines/3)*2,lines,result_value))
    t3 = Thread(target=do_concurrent_tagging,args=(int(nlines/3)*2,nlines,lines,result_value))
    t1.start(); t2.start(); t3.start()
    t1.join(); t2.join(); t3.join()

    print("형태소 변환 완료!")

#파일 저장
def file_save():
    link = getcwd()

    save_file = open(link + "/result.txt","w")

    for i in range(0,3):
        result_str = str(result_value[i]).replace('[]','')
        result_str1 = str(result_str).replace('[', '')
        result_str2 = str(result_str1).replace(']', '')
        result_str3 = str(result_str2).replace("'", '')
        result_str4 = str(result_str3).replace(',', '')
        save_file.write(result_str4)


    print("파일 저장 완료!")
    save_file.close()

def file_del():
    link = getcwd() + "/new_data.txt"

    remove(link)

    print("파일 삭제 완료!")

lines, nlines = file_read()
file_del()
print(lines)
noun(lines,nlines)
file_save()