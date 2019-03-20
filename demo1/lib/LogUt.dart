import 'dart:io';
import 'package:logging/logging.dart';

class LogUt {
  static LogUt log = new LogUt();
  final Level level = Level.ALL;

  LogUt() {
    Logger.root
      ..level = level
      ..onRecord.listen((rec) {
        // 基本的消息
        String log =
            '${rec.sequenceNumber}::${rec.level}::${rec.time}::${rec.message}';
        // 添加错误信息
        if (rec.error != null) {
          log += '\n::${rec.error}';
        }
        // 添加错误的堆栈
        if (rec.stackTrace != null) {
          log += '\n::${rec.stackTrace.toString()}';
        }
        print(log);

        // 只记录等级大于info的信息
        if (rec.level.value >= Level.INFO.value) {
          writeLog(log);
        }
      });
  }

  void finest(message, [Object error, StackTrace stackTrace]) =>
      Logger.root.log(Level.FINEST, message, error, stackTrace);

  void finer(message, [Object error, StackTrace stackTrace]) =>
      Logger.root.log(Level.FINER, message, error, stackTrace);

  void fine(message, [Object error, StackTrace stackTrace]) =>
      Logger.root.log(Level.FINE, message, error, stackTrace);

  void config(message, [Object error, StackTrace stackTrace]) =>
      Logger.root.log(Level.CONFIG, message, error, stackTrace);

  void info(message, [Object error, StackTrace stackTrace]) =>
      Logger.root.log(Level.INFO, message, error, stackTrace);

  void warning(message, [Object error, StackTrace stackTrace]) =>
      Logger.root.log(Level.WARNING, message, error, stackTrace);

  void severe(message, [Object error, StackTrace stackTrace]) =>
      Logger.root.log(Level.SEVERE, message, error, stackTrace);

  void shout(message, [Object error, StackTrace stackTrace]) =>
      Logger.root.log(Level.SHOUT, message, error, stackTrace);
}

void writeLog(String log) async {
  var date = DateTime.now();
  var year = date.year;
  var month = date.month;
  var day = date.day;

  // 如果recursive为true，会创建命名目录及父级目录
  Directory directory =
      await new Directory('log/$year').create(recursive: true);

  File file = new File('${directory.path}/$year-$month-$day.log');
  file.exists().then((isExists) {
    file.writeAsString(isExists ? '\n\n$log' : log, mode: FileMode.append);
  });
}
