import 'dart:convert';
import 'package:flutter_application/utils/save_login_logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Network {
  static SharedPreferences prefs ;
  static postSmsConfirmation() async {
    final String bitelUrl = "https://api.bitel.rest/api/v1/sms/single";
    final String authToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzM"
        "jc3IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L"
        "2NsYWltcy9yb2xlIjoiMSIsImV4cCI6MTU1MjQwNTUzNywiaXNzIjoiQml0ZWwiLCJhdW"
        "QiOiJCaXRlbCJ9.OsL3JS-5ox7sFHtCk5U9TsrLFOId3QyKpYy33iip6mY";
    final Map<String, dynamic> bitel = {
      "message": "سلام شماره تایید شما 2201",
      "phoneNumber": "09384556978"
    };
    var response = await http.post(bitelUrl,
        body: json.encode(bitel),
        headers: {
          "authorization": "Bearer $authToken",
          "content-type": "application/json"
        });
    return jsonDecode(response.body);
  }

  static getSmsConfirmation(
      String _phoneNumber,
      String _name,
      String _password,
      var responseResult
      ) async {

    prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> registerFields = {
      "phone_number": _phoneNumber,
      "name": _name,
      "password": _password,
    };

    final Map<String, dynamic> loginFields = {
      "login": "$_phoneNumber",
      "password": "$_password",
    };
    final APP_ID = "/9E4CCE4C-0A66-4BCF-FF12-76992420E600";
    final REST_API_KEY = "/05C5912E-750A-EBD6-FF10-3573790FF000";
    final BASE_URL = "https://api.backendless.com";
    final REGISTER_URL = BASE_URL + APP_ID + REST_API_KEY + "/users/register";
    final LOGIN_URL = BASE_URL + APP_ID + REST_API_KEY + "/users/login";

    String requestId =(await responseResult)["result"]["requestId"];
    final String authToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzM"
        "jc3IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L"
        "2NsYWltcy9yb2xlIjoiMSIsImV4cCI6MTU1MjQwNTUzNywiaXNzIjoiQml0ZWwiLCJhdW"
        "QiOiJCaXRlbCJ9.OsL3JS-5ox7sFHtCk5U9TsrLFOId3QyKpYy33iip6mY";
    http.get("https://api.bitel.rest/api/v1/sms/detail/single/$requestId",
        headers: {
          "authorization": "Bearer $authToken",
          "content-type": "application/json",
        }).then((http.Response response) {
      var res = json.decode(response.body);
      if (res["result"]["message"].toString().contains("2201")) {
        http.post(REGISTER_URL,body: json.encode(registerFields),
            headers: {"Content-Type": "application/json"});
        print(loginFields["login"].toString());
        print(loginFields["password"].toString());
        Duration(seconds: 5);
        http.post(LOGIN_URL,
            body: json.encode({
              "login": "9384556978",
              "password": "ttdkbhg"
            }),
            headers: {"Content-Type": "application/json"})
            .then((http.Response loginResponse){
              var loginRes = json.decode(loginResponse.body);
               var save = SaveLoginAndLogout();
               save.saveLogin(loginRes["user-token"]);
               print(loginRes["user-token"]);
               print(loginResponse.body);

        });

      } else {
        print("ثبت نام ناموفق");
      }
    });
  }



  static getLoginSmsConfirmation(
      String _phoneNumber,
      String _name,
      String _password,
      var responseResult
      ) async {

    prefs = await SharedPreferences.getInstance();


    final Map<String, dynamic> loginFields = {
      "login": "$_phoneNumber",
      "password": "$_password",
    };
    final APP_ID = "/9E4CCE4C-0A66-4BCF-FF12-76992420E600";
    final REST_API_KEY = "/05C5912E-750A-EBD6-FF10-3573790FF000";
    final BASE_URL = "https://api.backendless.com";
    final LOGIN_URL = BASE_URL + APP_ID + REST_API_KEY + "/users/login";

    String requestId =(await responseResult)["result"]["requestId"];
    final String authToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzM"
        "jc3IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L"
        "2NsYWltcy9yb2xlIjoiMSIsImV4cCI6MTU1MjQwNTUzNywiaXNzIjoiQml0ZWwiLCJhdW"
        "QiOiJCaXRlbCJ9.OsL3JS-5ox7sFHtCk5U9TsrLFOId3QyKpYy33iip6mY";
    http.get("https://api.bitel.rest/api/v1/sms/detail/single/$requestId",
        headers: {
          "authorization": "Bearer $authToken",
          "content-type": "application/json",
        }).then((http.Response response) {
      var res = json.decode(response.body);
      if (res["result"]["message"].toString().contains("2201")) {
        http.post(LOGIN_URL,
            body: json.encode({
              "login": "09384556978",
              "password": "ttdkbhg"
            }),
            headers: {"Content-Type": "application/json"})
            .then((http.Response loginResponse){
          var loginRes = json.decode(loginResponse.body);
          var save = SaveLoginAndLogout();
          save.saveLogin(loginRes["user-token"]);
          print(loginRes["user-token"]);
          print(loginResponse.body);

        });

      } else {
        print("ثبت نام ناموفق");
      }
    });
  }
  Future<bool> loginWithUserToken(String _userToken)async{
    final APP_ID = "/9E4CCE4C-0A66-4BCF-FF12-76992420E600";
    final REST_API_KEY = "/05C5912E-750A-EBD6-FF10-3573790FF000";
    final BASE_URL = "https://api.backendless.com";
    final USER_TOKEN_URL = BASE_URL + APP_ID + REST_API_KEY + "/users/isvalidusertoken/$_userToken";
    var tokenResponse = await http.get(USER_TOKEN_URL);
    return tokenResponse.body == "true";
  }
}
