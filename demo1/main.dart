import 'dart:io';

main() async {
  // HttpServer.bind(主机地址，端口号)
  // 主机地址：InternetAddress.loopbackIPv4和InternetAddress.loopbackIPv6都可以监听到
  var requestServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  print('监听 localhost地址，端口号为${requestServer.port}');

  // 监听请求
  await for (HttpRequest request in requestServer) {
    // 监听到请求后response回复它一个Hello World!然后关闭这个请求
    request.response
      ..write('Hello World!')
      ..close();
  }
}
