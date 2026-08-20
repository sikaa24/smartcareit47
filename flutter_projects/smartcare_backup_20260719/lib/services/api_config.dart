import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  ApiConfig._();

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost/smartcare.1';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2/smartcare.1';
    }
    return 'http://localhost/smartcare.1';
  }
}
