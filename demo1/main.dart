import 'dart:io';

main() async {
  // HttpServer.bind(主机地址，端口号)
  // 主机地址：InternetAddress.loopbackIPv4和InternetAddress.loopbackIPv6都可以监听到
  var requestServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  print('监听 localhost地址，端口号为${requestServer.port}');

  // 监听请求
  await for (HttpRequest request in requestServer) {
    // 监听到请求后response回复它一个Hello World!然后关闭这个请求
//    request.response
//      ..write('Hello World!')
//      ..close();
    handleMessage(request);
  }
}

/// 在这个方法里面处理请求
void handleMessage(HttpRequest request) {
  try {
    if (request.method == 'GET') {
      // 获取到GET请求
      handleGET(request);
    } else if (request.method == 'POST') {
      // 获取到POST请求
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
  var id = request.uri.queryParameters['id']; // 查询id的值
  // 打印出客户端请求的详细请求头
  request.headers.forEach((key, values) {
    print('key:$key');
    for (String value in values) {
      print('value:$value');
    }
  });
  request.response
    ..statusCode = HttpStatus.ok // 回复它一个ok状态，说明我收到请求啦
    ..write('当前查询的id为$id') // 显示到浏览器的内容
    ..close(); // 我已经回复你了，所以关闭这个请求
}

/// 处理POST请求
void handlePOST(HttpRequest request) {}
