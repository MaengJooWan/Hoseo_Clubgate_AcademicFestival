package com.example.maengjoowan.ftp;

import android.os.SystemClock;
import android.util.Log;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Scanner;
import java.util.logging.Handler;
import java.util.logging.LogRecord;

public class FTP_Download {

    private FTPClient mFtp = new FTPClient();
    private String DIR = "/data/user/0/com.example.maengjoowan.ftp/files/"; //'저장 위치' 나중에 수정
    InputStream input;

    public void getFileFromeFTP() {
        //먼저 접속하는 로직이다.
        if (!FTPConnect("192.168.43.162")) {
            //msgBox("FTP 연결실패!!");
            return;
        }
        if (!FTPLogin("MaengJooWan", "852power")) {
            //msgBox("FTP 연결실패");
            FTPClose();
            return;
        }
        if (!FTPGetFile()) {
            //msgBox("FTPGetFile 실패");
            FTPClose();
            return;
        }
        //msgBox("FTP파일 다운로드 성공!!");
    }

    public boolean FTPConnect(String host) {
        try {
            //mFtp = new FTPClient();
            mFtp.connect(host, 21);

        } catch (IOException e) {
            Log.d("FTP", "error" + e.toString());
            return false;
        }
        return true;
    }

    //login
    public boolean FTPLogin(String ID, String PW) {
        try {
            if (!mFtp.login("MaengJooWan", "852power")) {
                return false;
            }
        } catch (IOException e) {
            Log.d("FTP", "error" + e.toString());
            return false;
        }
        return true;
    }

    public boolean FTPClose() {
        try {
            mFtp.disconnect();
        } catch (IOException e) {
            return false;
        }
        return true;
    }

    public boolean FTPGetFile() {
        FileOutputStream result;
        File f;
        try {
            mFtp.setControlEncoding("euc-kr");
            mFtp.enterLocalPassiveMode();
            mFtp.changeWorkingDirectory("/");//이것은 ftp상의 폴더경로를 지정하는 것이다.
            //후에 거기에 있는 파일을 가져온다.
            FTPFile[] files = mFtp.listFiles();
            //궁금해서 제일 처음에 가져오는게 뭔지 확인.
            //모든 파일을 가져온다.
            boolean sw = false;
            int file_lenghs = files.length;
            mFtp.deleteFile("rank.txt");
            while (true) {
                FTPFile[] files1 = mFtp.listFiles();
                file_lenghs = files1.length;
                SystemClock.sleep(30);
                for (int i = 0; i < file_lenghs; i++) {
                    //특정 xml을 원해서 그것을 가져오는데 다른게 필요하면 로직을 쓰면된다.
                    if (files1[i].getName().equals("rank.txt")) {
                        //DIR == 데이터 경로 ( 내장 데이터 )
                        f = new File(DIR + files1[i].getName());
                        //스트림
                        result = new FileOutputStream(f);
                        //ftp에서 가져온 파일을 스트림에 쓴다.
                        mFtp.retrieveFile(files1[i].getName(), result);
                        result.close();
                        mFtp.logout();
                        mFtp.disconnect();
                        sw = true;
                        break;
                    }
                }
                if (sw == true) {
                    break;
                }
            }
        } catch (IOException e) {
            Log.d("FTP", "error" + e.toString());
            return false;
        }
        return true;
    }


    public String FileRead() {

        String data = "";

        try {
            File file = new File(DIR + "rank.txt");
            Scanner scan = new Scanner(file);

            while(scan.hasNextLine()){
                data = data + scan.nextLine() + "\n";
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return data;
    }
}
