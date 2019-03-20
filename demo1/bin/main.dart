import 'dart:io';
import 'package:http_server/http_server.dart';
import 'package:path/path.dart';

main() async {
  var webPath = dirname(dirname(Platform.script.toFilePath())) + '/webApp';
  VirtualDirectory staticFiles = new VirtualDirectory(webPath);

  // 允许目录监听,按照目录去请求
  staticFiles.allowDirectoryListing = true;
  // 目录处理，当请求根目录时，会返回该地址
  staticFiles.directoryHandler = (dir, request) {
    var indexUri = new Uri.file(
      dir.path,
    ).resolve('index.html');
    staticFiles.serveFile(new File(indexUri.toFilePath()), request);
  };
  // 处理访问不存在的页面
  staticFiles.errorPageHandler = (request) {
    if (request.uri.pathSegments.last.contains('.html')) {
      staticFiles.serveFile(new File(webPath + '/404.html'), request);
    } else {
      handleMessage(request);
    }
  };
  var requestServer = await HttpServer.bind(InternetAddress.loopbackIPv6, 8080);
  print('监听 localhost 地址，端口号为${requestServer.port}');

  // 监听请求
  await for (HttpRequest request in requestServer) {
    // 交给 staticFiles 处理了
    staticFiles.serveRequest(request);
  }
}

/// 在这个方法里面处理请求
void handleMessage(HttpRequest request) {
  try {
    if (request.method == 'GET') {
      // 获取到 GET 请求
      handleGET(request);
    } else if (request.method == 'POST') {
      // 获取到 POST 请求
      handlePOST(request);
    } else {
      // 其它的请求方法暂时不支持，回复它一个状态
      request.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write('对不起，不支持${request.method}方法的请求！')
        ..close();
    }
  } catch (e) {
    print('出现了一个异常，异常为：$e');
  }
  print('请求被处理了');
}

/// 处理GET请求
void handleGET(HttpRequest request) {
  // 获取一个参数
  var id = request.uri.queryParameters['id']; // 查询 id 的值
  // 打印出客户端请求的详细请求头
  request.headers.forEach((key, values) {
    print('key:$key');
    for (String value in values) {
      print('value:$value');
    }
  });
  request.response
    ..statusCode = HttpStatus.ok // 回复它一个 ok 状态，说明我收到请求啦
    ..write('当前查询的id为$id') // 显示到浏览器的内容
    ..close(); // 我已经回复你了，所以关闭这个请求
}

/// 处理POST请求
void handlePOST(HttpRequest request) {}

void writeHeaders(HttpRequest request) {
  List<String> headers = [];
  request.headers.forEach((key, values) {
    String header = '$key：';
    for (String value in values) {
      header += '$value , ';
    }
    headers.add(header.substring(0, header.length - 2));
  });
  writeLog('${headers.join('\n')}');
}

void writeLog(String log) async {
  var date = DateTime.now();
  var year = date.year;
  var month = date.month;
  var day = date.day;
  var hour = date.hour;
  var minute = date.minute;

  //如果 recursive 为 true，会创建命名目录及父级目录
  Directory directory =
      await new Directory('log/$year-$month-$day').create(recursive: true);

  File file = new File('${directory.path}/$hour:$minute.log');
  file.exists().then((isExists) {
    String logAddTime = 'time：${date.toIso8601String()}\n$log';
    file.writeAsString(isExists ? '\n\n$logAddTime' : logAddTime,
        mode: FileMode.append);
  });
}
