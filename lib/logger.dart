library ait0ne_logger;

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

class LoggerConfig {
  final String API_KEY;
  final String API_URL;

  LoggerConfig(this.API_KEY, this.API_URL);
}

enum LogLevels { ERROR, INFO, WARNING }

class Logger {
  static Logger? _instance;
  final LoggerConfig config;

  Logger._(this.config);

  factory Logger(LoggerConfig config) => _instance ??= Logger._(config);

  void log(LogLevels level, String message) async {
    var uri = Uri.parse(config.API_URL + '/logger');

    try {
      var device = DeviceInfoPlugin();
      var mes = message;
      if (Platform.isAndroid) {
        var info = await device.androidInfo;

        mes = "Device: " +
            (info.device ?? "") +
            "\n Model: " +
            (info.model ?? "") +
            "\n" +
            mes;
      } else if (Platform.isIOS) {
        var info = await device.iosInfo;

        mes = "Device: " +
            (info.utsname.machine ?? "") +
            "\n Model: " +
            (info.model ?? "") +
            "\n" +
            mes;
      }
      var lvl = mapLevelToString(level);

      var response = await http.post(uri,
          headers: {"Authorization": "Bearer " + config.API_KEY},
          body: {"level": lvl, "message": mes});
    } catch (err) {
      print("resp:" + err.toString());
    }
  }

  String mapLevelToString(LogLevels level) {
    switch (level) {
      case LogLevels.ERROR:
        return "error";
      case LogLevels.INFO:
        return "info";
      case LogLevels.WARNING:
        return "warning";
    }
  }
}
