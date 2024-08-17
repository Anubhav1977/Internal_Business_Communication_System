import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<void> setLoginData(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  Future<bool> getData(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key) ?? false;
  }
}
