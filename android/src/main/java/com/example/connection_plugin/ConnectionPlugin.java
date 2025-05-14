package com.example.connection_plugin;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.Call;
import okhttp3.Callback;

/** ConnectionPlugin */
public class ConnectionPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private OkHttpClient client;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "connection_plugin");
    channel.setMethodCallHandler(this);
    client = new OkHttpClient.Builder()
        .connectTimeout(10, TimeUnit.SECONDS)
        .build();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("getLatency")) {
      String url = call.argument("url");
      if (url == null || url.isEmpty()) {
        result.error("INVALID_URL", "URL cannot be null or empty", null);
        return;
      }

      try {
        measureSocketLatency(url, result);
      } catch (Exception e) {
        result.error("LATENCY_ERROR", "Failed to measure latency: " + e.getMessage(), null);
      }
    } else {
      result.notImplemented();
    }
  }

  private void measureSocketLatency(final String urlString, final Result result) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        Socket socket = null;
        try {
          URI uri = new URI(urlString);
          String host = uri.getHost();
          int port = uri.getPort();

          // Use default port (80 for HTTP, 443 for HTTPS) if not specified
          if (port == -1) {
            port = uri.getScheme().equals("https") ? 443 : 80;
          }

          long startTime = System.currentTimeMillis();

          // Create and connect socket
          socket = new Socket();
          socket.connect(new InetSocketAddress(host, port), 5000); // 5 second timeout

          long endTime = System.currentTimeMillis();
          final long latency = endTime - startTime;

          // Must post to main thread since we're in a background thread
          new android.os.Handler(android.os.Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
              result.success(latency);
            }
          });

        } catch (final Exception e) {
          new android.os.Handler(android.os.Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
              result.error("CONNECTION_ERROR", "Failed to connect: " + e.getMessage(), null);
            }
          });
        } finally {
          if (socket != null && !socket.isClosed()) {
            try {
              socket.close();
            } catch (IOException e) {
              // Ignore close exceptions
            }
          }
        }
      }
    }).start();
  }

  // Previous HTTP implementation that measured full request time
  private void measureLatency(String url, final Result result) {
    final long startTime = System.currentTimeMillis();

    Request request = new Request.Builder()
        .url(url)
        .build();

    client.newCall(request).enqueue(new Callback() {
      @Override
      public void onFailure(Call call, IOException e) {
        result.error("CONNECTION_ERROR", "Failed to connect: " + e.getMessage(), null);
      }

      @Override
      public void onResponse(Call call, Response response) {
        long endTime = System.currentTimeMillis();
        long latency = endTime - startTime;

        try {
          if (response.body() != null) {
            response.body().close();
          }
        } catch (Exception e) {
          // Ignore close exceptions
        }

        result.success(latency);
      }
    });
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    client = null;
  }
}