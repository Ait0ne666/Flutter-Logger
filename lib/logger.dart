library ait0ne_logger;

import 'package:http/http.dart' as http;

class LoggerConfig {
  final String API_KEY;
  final String API_URL;

  LoggerConfig(this.API_KEY, this.API_URL);
}

enum LogLevels { ERROR, INFO, WARNING }

class Logger {
  static Logger? _instance;
  final LoggerConfig config;

  Logger(this.config) {
    _instance = Logger(config);
  }

  static Logger? get instance => _instance;

  void log(LogLevels level, String message) async {
    var uri = Uri.parse(config.API_URL + '/logger');

    try {
      var response = await http.post(uri,
          headers: {"Authorization": "Bearer " + config.API_KEY},
          body: {level: mapLevelToString(level), message: message});

      print(response.body);
    } catch (err) {
      print(err.toString());
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
