import 'dart:io';

/// 将传递的 request 请求升级为 WebSocket 请求
class WebSocketManager {
  static WebSocketManager manager = new WebSocketManager();
  List<WebSocket> webSockets;

  WebSocketManager() {
    webSockets = [];
  }

  Future serveRequest(HttpRequest request) {
    // 判断当前请求是否可以升级为 WebSocket
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      // 升级为webSocket
      return WebSocketTransformer.upgrade(request).then((webSocket) {
        // 添加到 List 里面方便维护
        webSockets.add(webSocket);
        // webSocket 消息监听
        webSocket.listen(handMsg);
      });
    } else {
      request.response
        ..statusCode = HttpStatus.notAcceptable
        ..writeln('该请求应为WebSocket连接')
        ..close();
      return new Future(() {});
    }
  }

  // 处理消息
  void handMsg(dynamic msg) {
    print('收到客户端消息：$msg');

    // 给所有客户端回复当前客户端说了什么
    for (WebSocket webSocket in webSockets) {
      // 判断是否有关闭代码，如果没有证明客户端当前未关闭，给它回复
      if (webSocket.closeCode == null) {
        // 回复客户端一条消息
        webSocket.add('服务器回复: XX:$msg');
      }
    }
  }
}
