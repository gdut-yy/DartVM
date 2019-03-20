import 'dart:io';
import 'dart:mirrors';

class Controller {
  final String path;

  // 构造方法定义为编译时常量
  const Controller({this.path});

  @override
  String toString() => 'Controller'; // 这里是区别其它注解
}

@Controller(path: '/user')
class UserController extends BaseController {
  @Get(path: '/login')
  void login(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..writeln('LoginSuccess')
      ..close();
  }

  @Post(path: '/logout')
  void logout(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..writeln('logoutSuccess')
      ..close();
  }

  @Request(path: '/delete', method: 'DELETE')
  void editUser(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..writeln('DeleteSuccess')
      ..close();
  }
}

class Request {
  final String path;
  final String method;

  const Request({this.path, this.method});

  @override
  String toString() => 'Request';
}

class Get extends Request {
  final String path;

  const Get({this.path}) : super(path: path, method: 'GET');

  @override
  String toString() => 'Get';
}

class Post extends Request {
  final String path;

  const Post({this.path}) : super(path: path, method: 'POST');

  @override
  String toString() => 'Get';
}

/// 抽象类
abstract class BaseController {}

/// 用于管理 Controller
class ControllerManager {
  static ControllerManager manager = new ControllerManager();

  // 该 list 用于判断 Controller 是否已经被添加
  List<BaseController> controllers = [];

  // 这是一个 map，对应的是请求链接，跟对应的 controller 信息
  Map<String, ControllerInfo> urlToMirror = new Map();

  // 添加控制器
  void addController(BaseController controller) {
    // 判断当前是否已经添加过控制器
    if (!controllers.contains(controller)) {
      controllers.add(controller);
      // 添加 map
      urlToMirror.addAll(getRequestInfo(controller));
    }
  }

  // 该 controllerManager 处理请求的方法
  void requestServer(HttpRequest request) {
    // 当前请求的路径
    String path = request.uri.toString();
    // 当前请求的方法
    String method = request.method;

    // 判断 map 中是否包含该请求地址
    if (urlToMirror.containsKey(path)) {
      ControllerInfo info = urlToMirror[path];
      // 获取到该请求，传递路径、请求方法跟请求
      info.invoke(path, method, request);
    } else {
      // 没有该地址返回一个 404
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('''{
  "code": 404,
  "msg": "链接不存在！"
}''')
        ..close();
    }
  }
}

class ControllerInfo {
  // 请求地址对应Controller中的方法，Symbol包含方法标识
  final Map<String, Symbol> urlToMethod;

  // 该参数包含通过类初始化得到的实例镜子，可以通过该参数调用方法
  final InstanceMirror instanceMirror;

  // 构造方法
  ControllerInfo(this.instanceMirror, this.urlToMethod);

  // 调用请求方法
  void invoke(String url, String method, HttpRequest request) {
    // 判断是否该请求地址是对应的请求方法
    if (urlToMethod.containsKey('$url#$method')) {
      // 调用方法
      instanceMirror.invoke(urlToMethod['$url#$method'], [request]);
    } else {
      // 请求方法不对，返回一个错误
      request.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write('''{
  "code": 405,
  "msg": "请求出错！"
}''')
        ..close();
    }
  }
}

/// 传递一个 Controller 进去
Map<String, ControllerInfo> getRequestInfo(BaseController controller) {
  // 实际返回的 Map
  Map<String, ControllerInfo> info = new Map();
  // 请求地址对应的方法
  Map<String, Symbol> urlToMethod = new Map();
  // 获取 Controller 实例的镜子
  InstanceMirror im = reflect(controller);
  // 获取 Controller 运行时类型的镜子
  ClassMirror classMirror = im.type;
  // 请求的根路径
  List<String> path = [];
  // 该 Controller 的所有接收的请求地址
  List<String> urlList = [];
  // 获取元数据,就是获取 @Controller(path: xxx) 中的 xxx
  classMirror.metadata.forEach((medate) {
    path.add(medate.reflectee.path);
  });

  // 获取该类的所有方法
  classMirror.declarations.forEach((symbol, declarationMirror) {
    // 将自身的构造方法剔除
    if (symbol.toString() != classMirror.simpleName.toString()) {
      // 获取方法的元数据，就是 @Get(path： path)
      declarationMirror.metadata.forEach((medate) {
        // 请求的地址
        String requestPath = path.join() + medate.reflectee.path;
        // 请求的类型
        String method = medate.reflectee.method;

//        print('请求地址为：$requestPath,请求方法为：$method');
        // 添加到请求地址集合
        urlList.add(requestPath);
        // 添加到请求地址对应方法的集合
        urlToMethod.putIfAbsent('$requestPath#$method', () => symbol);
      });
    }
  });

  // 实例化一个 Controller 信息
  ControllerInfo controllerInfo = new ControllerInfo(im, urlToMethod);

  // 循环添加到实际需要的 Map，对应请求地址根 ControllerInfo 信息
  urlList.forEach((url) {
    info.putIfAbsent(url, () => controllerInfo);
  });
  // 返回需要的 map
  return info;
}
