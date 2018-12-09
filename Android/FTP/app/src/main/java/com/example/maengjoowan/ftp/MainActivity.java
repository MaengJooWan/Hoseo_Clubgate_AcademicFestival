package com.example.maengjoowan.ftp;

import android.content.Context;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class MainActivity extends AppCompatActivity {

    FTPClient ftpClient = new FTPClient();
    private File sourceFile;
    InputStream input;
    FTP_Download FTPDownloader = new FTP_Download();
    String result_value = "";

    //버튼 실행시 activity
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

       Button searchBtn;
        searchBtn = (Button) findViewById(R.id.searchBtn);
        final TextView textView=(TextView)findViewById(R.id.resultBox);

        searchBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FileWrite();
                FileRead();
                textView.setText("검색중....");
                Thread thread = new Thread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            ftpClient.setControlEncoding("euc-kr");
                            ftpClient.connect("192.168.43.162",21);
                            ftpClient.login("MaengJooWan","852power");//아디비번
                            ftpClient.setFileType(FTP.BINARY_FILE_TYPE);//파이너리 파일
                            ftpClient.enterLocalPassiveMode();
                            Log.d("FTP","로그인 완료");

                            FTPFile[] ftpFiles = ftpClient.listFiles();
                            int length = ftpFiles.length;

                            for(int i = 0 ; i < length ; i++){
                                String name = ftpFiles[i].getName();
                                boolean isFile = ftpFiles[i].isFile();
                                if(isFile){
                                    Log.d("FTP","File:" + name);
                                }
                                else{
                                    Log.d("FTP","Directory : " + name);
                                }
                                Log.d("FTP",ftpClient.getReplyString());
                            }
                        }catch (IOException ex){
                            Log.d("FTP","Error:" + ex.getMessage());
                        }
                        File uploadFile = new File(getFilesDir().getAbsolutePath()+"/File.txt");
                        FileInputStream fis = null;

                        try{
                            ftpClient.changeWorkingDirectory("/");//서버 이 폴도로 접속

                            fis = new FileInputStream(uploadFile);
                            Log.d("FTP","경로 : " + ftpClient.printWorkingDirectory());
                            boolean isSuccess = ftpClient.storeFile("keyword.txt",fis);
                            Log.d("FTP","uploadName : " + uploadFile.getName());
                            if(isSuccess){
                                Log.d("FTP","파일 전송 성공");
                                ftpClient.logout();
                                ftpClient.disconnect();
                                FTPDownloader.getFileFromeFTP();
                                String value_result = FTPDownloader.FileRead();
                                textView.setText(value_result);
                            }
                            else {
                                Log.d("FTP", "실패");
                            }
                        }catch (Exception e){
                            Log.d("FTP","에러남 : " + e);
                        }
                    }
                });
                thread.start();

            }
        });
    }

    public void FileWrite(){

        EditText inputWord;

        inputWord = (EditText) findViewById(R.id.inputWord);
        //Toast.makeText(getApplicationContext(),"Search..",Toast.LENGTH_SHORT).show();

        try {
            FileOutputStream outfs = openFileOutput("File.txt", Context.MODE_PRIVATE);
            String strTemp = inputWord.getText().toString();
            outfs.write(strTemp.getBytes());
            outfs.close();
            Log.d("ddd","파일생성완료");
            Log.d("ddd","파일위치:" + getFilesDir().getAbsolutePath());
        }catch (IOException e){
            e.printStackTrace();
            Log.d("ddd","파일생성error");
        }
    }
    public void FileRead(){
        try {
            FileInputStream infs = openFileInput("File.txt");//파일이 없으면 FileNotFoundException예외

            byte[] temp = new byte[infs.available()]; //파일길이 측정하다가 예외가 발생하면 IOException예외발생
            infs.read(temp);
            String strData = new String(temp);
            Log.d("ddd","파일읽어옴:" + strData);
            infs.close();
        }catch(IOException e){
            Log.d("ddd","읽기 예외사항 발생");

        }
    }
}