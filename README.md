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
