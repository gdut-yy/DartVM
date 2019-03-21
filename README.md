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
一般而言，知道 `Dart` 的大概率知道 `Flutter`，直接使用 `Flutter` 目录下 `Dart SDK` 的就好了
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

### DartVM服务器开发（第七天）--WebSocket
```log
0::FINEST::2019-03-21 09:06:15.393541::服务器启动：http://localhost:8080
收到客户端消息：Hello World!
客户端收到消息！
服务器回复: XX:Hello World!
```

### DartVM服务器开发（第八天）--http服务端框架
- Aqueduct 
    - 官网：https://aqueduct.io/docs/tour/
    - github：https://github.com/stablekernel/aqueduct
- Jaguar
    - 官网：https://jaguar-dart.com/
    - github：https://github.com/Jaguar-dart/jaguar

### DartVM服务器开发（第九天）--Aqueduct环境搭建
激活 Aqueduct
```
$ pub global activate aqueduct
Resolving dependencies...
+ analyzer 0.34.3 (0.35.4 available)
+ aqueduct 3.2.0
+ args 1.5.1
+ async 2.0.8
+ charcode 1.1.2
+ codable 1.0.0
+ collection 1.14.11
+ convert 2.1.1
+ crypto 2.0.6
+ csslib 0.14.6
+ front_end 0.1.9+1 (0.1.14 available)
+ glob 1.1.7
+ html 0.13.4+1
+ isolate_executor 2.0.2+1
+ kernel 0.3.9+1 (0.3.14 available)
+ logging 0.11.3+2
+ meta 1.1.7
+ open_api 2.0.1
+ package_config 1.0.5
+ password_hash 2.0.0
+ path 1.6.2
+ plugin 0.2.0+3
+ postgres 1.0.2
+ pub_cache 0.2.3
+ pub_semver 1.4.2
+ safe_config 2.0.2
+ source_span 1.5.5
+ string_scanner 1.0.4
+ term_glyph 1.1.0
+ typed_data 1.1.6
+ utf 0.9.0+5
+ watcher 0.9.7+10
+ yaml 2.1.15
Downloading aqueduct 3.2.0...
Downloading password_hash 2.0.0...
Downloading open_api 2.0.1...
Downloading codable 1.0.0...
Downloading safe_config 2.0.2...
Downloading postgres 1.0.2...
Downloading pub_cache 0.2.3...
Downloading isolate_executor 2.0.2+1...
Downloading analyzer 0.34.3...
Downloading kernel 0.3.9+1...
Downloading front_end 0.1.9+1...
Precompiling executables...
Precompiled aqueduct:bin\aqueduct.
Installed executable aqueduct.
Warning: Pub installs executables into C:\Users\DEVYY\AppData\Roaming\Pub\Cache\bin, which is not on your path.
You can fix that by adding that directory to your system's "Path" environment variable.
A web search for "configure windows path" will show you how.
Activated aqueduct 3.2.0.
```
配置环境变量 & 测试 `aqueduct` 命令
```bash
$ export AQUEDUCT_PATH=C:\Users\DEVYY\AppData\Roaming\Pub\Cache\bin
$ export Path=Path;%AQUEDUCT_PATH%\
$ aqueduct
-- Aqueduct CLI Version: 3.2.0
Aqueduct is a tool for managing Aqueduct applications.


Usage: aqueduct <command> [arguments]

Options:
    --version            Prints version of this tool
    --[no-]color         Toggles ANSI color
                         (defaults to on)

-h, --help               Shows this
    --[no-]stacktrace    Shows the stacktrace if an error occurs
    --[no-]machine       Output is machine-readable, usable for creating tools on top of this CLI. Behavior varies by command.
Available sub-commands:
  document   Generates an OpenAPI specification of an application.
  create     Creates Aqueduct applications from templates.
  serve      Runs Aqueduct applications.
  setup      A one-time setup command for your development environment.
  auth       A tool for adding OAuth 2.0 clients to a database using the managed_auth package.
  db         Modifies, verifies and generates database schemas.
```
使用 CLI 构建项目
```
$ aqueduct create my_aqueduct
$ cd my_aqueduct
$ aqueduct serve
-- Aqueduct CLI Version: 3.2.0
-- Aqueduct project version: 3.2.0
-- Preparing...
-- Starting application 'my_aqueduct/my_aqueduct'
    Channel: MyAqueductChannel
    Config: C:\Users\DEVYY\Documents\GitHub\DartVM\my_aqueduct\config.yaml
    Port: 8888
[INFO] aqueduct: Server aqueduct/1 started.
[INFO] aqueduct: Server aqueduct/2 started.
[INFO] aqueduct: Server aqueduct/3 started.
[INFO] aqueduct: Server aqueduct/4 started.
```

### DartVM服务器开发（第十天）--Jaguar环境搭建
my_jaguar