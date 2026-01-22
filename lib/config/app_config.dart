class AppConfig {
  AppConfig._();

  static const String firebaseDatabaseUrl = 
      'https://matchmate-bugraydin-default-rtdb.europe-west1.firebasedatabase.app/';
  
  static bool get isDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}

