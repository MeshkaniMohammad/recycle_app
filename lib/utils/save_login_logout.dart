import 'package:shared_preferences/shared_preferences.dart';

class SaveLoginAndLogout {
  saveLogin(String userToken,String objectId,String phoneNumber) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.setString("user_token", userToken);
    await _prefs.setString("object_id", objectId);
    await _prefs.setString("phone_number", phoneNumber);
  }

  Future<String> getUserToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print("data in saveLogin is:"+ _prefs.getString("user_token").toString());
    return _prefs.getString("user_token");
  }

  Future<String> getObjectId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print(_prefs.getString("object_id"));
    return _prefs.getString("object_id");
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString("phone_number");
  }
}
