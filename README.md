# DartVM 
> Dart 语言服务端 

参考自：DartVM服务器开发 https://www.jianshu.com/p/32e2dcf5f391

## 安装 Dart 环境（Linux）
- Dart 官网：https://www.dartlang.org/tools/sdk#install
- Dart GitHub：https://github.com/dart-lang/sdk

```bash
$ wget https://storage.googleapis.com/dart-archive/channels/stable/release/latest/linux_packages/dart_2.2.0-1_amd64.deb
$ sudo dpkg -i dart_2.2.0-1_amd64.deb 
$ dart --version
Dart VM version: 2.2.0 (Unknown timestamp) on "linux_x64"
```
## 安装 Dart 环境（Windows）
一般而言，知道 Dart 的大概率知道 Flutter，直接使用 Flutter 目录下的就好了
```bash
$ export DART_HOME=C:\Users\DEVYY\Documents\FlutterSDK\flutter\bin\cache\dart-sdk
$ export Path=Path;%DART_HOME%\bin
$ dart --version
Dart VM version: 2.1.2-dev.0.0.flutter-0a7dcf17eb (Tue Feb 12 01:59:15 2019 +0000) on "windows_x64"
```
## IDE（推荐使用 WebStorm）


### DartVM服务器开发（第二天）--处理请求
```
监听 localhost地址，端口号为8080
key:user-agent
value:Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 SE 2.X MetaSr 1.0
key:connection
value:keep-alive
key:cache-control
value:max-age=0
key:accept
value:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
key:accept-language
value:zh-CN,zh;q=0.8
key:cookie
value:fp_ver=4.5.0; BSFIT_EXPIRATION=1552708217181; BSFIT_DEVICEID=Eqnx1znAYQ9OiOEsKngF-DEsengxG97ve8jelb0x3VwYl2WCmLy3_79e6eI5EuGqI-luF7fDwxxVnV1VLLgDVi4Mq4iiWqkNKRfxv7psziEKqY_iffR-el8MwKYgjEPQbeCyhMxvCTYNbkzr0g4EjBcErkSY2zlH; BSFIT_OkLJUJ=FFC4QwrflLDxSzwLOtqAZNIWLHanKmC0; JSESSIONID=A40CFE8A3A333F5101AAB691F90B8835
key:accept-encoding
value:gzip, deflate, sdch, br
key:host
value:localhost:8080
key:upgrade-insecure-requests
value:1
请求被处理了
```

### DartVM服务器开发（第四天）--代码优化
```dart
print(dirname(dirname(Platform.script.toFilePath()))+'/webApp');
C:\Users\DEVYY\Documents\GitHub\DartVM\demo1/webApp
```

### DartVM服务器开发（第五天）--日志工具
```log
0::INFO::2019-03-20 17:29:42.012273::服务器启动：http://localhost:8080

1::WARNING::2019-03-20 17:30:13.466638::请求消息发生异常
::Invalid argument(s): Warning happen
::#0      main.<anonymous closure> (file:///C:/Users/DEVYY/Documents/GitHub/DartVM/demo1/bin/main.dart:51:9)
#1      VirtualDirectory._serveErrorPage (package:http_server/src/virtual_directory.dart:368:7)
#2      VirtualDirectory.serveRequest.<anonymous closure> (package:http_server/src/virtual_directory.dart:101:9)
#3      _RootZone.runUnary (dart:async/zone.dart:1379:54)
#4      _FutureListener.handleValue (dart:async/future_impl.dart:126:18)
#5      Future._propagateToListeners.handleValueCallback (dart:async/future_impl.dart:639:45)
#6      Future._propagateToListeners (dart:async/future_impl.dart:668:32)
#7      Future._completeWithValue (dart:async/future_impl.dart:483:5)
#8      Future._asyncComplete.<anonymous closure> (dart:async/future_impl.dart:513:7)
#9      _microtaskLoop (dart:async/schedule_microtask.dart:41:21)
#10     _startMicrotaskLoop (dart:async/schedule_microtask.dart:50:5)
#11     _runPendingImmediateCallback (dart:isolate/runtime/libisolate_patch.dart:115:13)
#12     _RawReceivePortImpl._handleMessage (dart:isolate/runtime/libisolate_patch.dart:172:5)
```