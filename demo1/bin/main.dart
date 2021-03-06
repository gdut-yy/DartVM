import 'dart:io';
import 'package:demo/annotation.dart';
import 'package:demo/LogUt.dart';
import 'package:demo/websocket.dart';
import 'package:http_server/http_server.dart';
import 'package:path/path.dart';
import 'package:logging/logging.dart';

main() async {
  /// 添加控制器
  ControllerManager.manager.addController(new UserController());

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
    }

    /// 当请求路径为 /mini，判断为进行 webScoket 连接
    else if (request.uri.path == '/mini') {
      WebSocketManager.manager.serveRequest(request).catchError((error) {
        LogUt.log.warning('webSocket异常', error, error.stackTrace);
      });
    }

    /// 当请求地址为 /mini/client 时开启一个客户端
    else if (request.uri.path == '/mini/client') {
      SocketClient();
    } else {
      try {
//        handleMessage(request);
        /// 将之前的 handleMessage(request) 方法替换为
        ControllerManager.manager.requestServer(request);
        throw ArgumentError('Warning happen');
      } catch (e) {
        try {
          //有可能没有回复客户端，所以这里回复一次
          request.response
            ..statusCode = HttpStatus.internalServerError
            ..close();
        } catch (_) {}
        Logger.root.warning('请求消息发生异常', e,
            e.runtimeType == ArgumentError ? e.stackTrace : null);
      }
    }
  };
  var requestServer = await HttpServer.bind(InternetAddress.loopbackIPv6, 8080);
  LogUt.log.finest('服务器启动：http://localhost:${requestServer.port}');

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

/// 开启一个客户端
void SocketClient() async {
  // 客户端连接到服务端
  WebSocket client = await WebSocket.connect('ws://localhost:8080/mini');
  // 客户端接收消息
  client.listen((msg) {
    print('客户端收到消息！');
    print(msg);
  });
  // 客户端发送消息
  client.add('Hello World!');
}
