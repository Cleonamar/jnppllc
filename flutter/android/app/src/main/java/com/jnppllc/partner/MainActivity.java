package com.jnppllc.partner;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  
  private Map<String, String> data = new HashMap<String, String>();

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    Intent intent = getIntent();
    String action = intent.getAction();
    String type = intent.getType();

    if (Intent.ACTION_SEND.equals(action) && type != null) {
      if ("text/plain".equals(type)) {
        data.put("url", intent.getStringExtra(Intent.EXTRA_TEXT));
        Uri link = intent.getClipData().getItemAt(0).getUri();
        try {
          FileDescriptor sourceFile = getContentResolver().openFileDescriptor(link, "r").getFileDescriptor();
          File cachedFile = File.createTempFile(link.getLastPathSegment(), null, getCacheDir());
          BufferedInputStream in = new BufferedInputStream(new FileInputStream(sourceFile));
          BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(cachedFile));
          int i;
          try {
            while ((i = in.read()) != -1) {
              out.write(i);
            }
          } finally {
            if (in != null) {
              in.close();
            }
            if (out != null) {
              out.close();
            }
            if (cachedFile != null && cachedFile.length() > 0) {
              data.put("file", cachedFile.getAbsolutePath());
            }
          }
        } catch (FileNotFoundException e) {
          e.printStackTrace();
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
    }

    new MethodChannel(getFlutterView(), "us.devlaw.data")
      .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
          if (methodCall.method.contentEquals("get")) {
            result.success(data);
          }
        }
      }
    );
  }
}
