import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';

class SaveLoginAndLogout{
  saveLogin(String userToken) async {
    SharedPreferences  _prefs = await SharedPreferences.getInstance();

    await _prefs.setString("user_token", userToken);
  }

  Future<String> getUserToken() async {
    SharedPreferences  _prefs = await SharedPreferences.getInstance();
    print(_prefs.getString("user_token"));
    return _prefs.getString("user_token") ?? "nothing";
  }
}