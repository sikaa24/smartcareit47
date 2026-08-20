import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  ApiConfig._();

  /* This tells the app what web address to use when it talks to the PHP
  backend. A phone emulator cannot reach "localhost" the same way a web
  browser does, so this checks what kind of device is running the app and
  picks the correct address. If the app runs on the web, it uses
  localhost. If it runs on an Android emulator, it uses 10.0.2.2, which
  is the special address Android emulators use to mean "the computer
  running the emulator". Any other device also falls back to localhost. */
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
