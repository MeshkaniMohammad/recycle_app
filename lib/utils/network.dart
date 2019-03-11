import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_application/utils/save_login_logout.dart';
import 'package:http/http.dart' as http;

class Network {
  static final _random = new Random();

  static int get _randomNumb => 1000 + _random.nextInt(9999 - 1000);
  static final _randomNumber = _randomNumb;

  static postSmsConfirmation(String _phoneNumber) async {
    final String bitelUrl = "https://api.bitel.rest/api/v1/sms/single";
    final String authToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzM"
        "jc3IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L"
        "2NsYWltcy9yb2xlIjoiMSIsImV4cCI6MTU1MjQwNTUzNywiaXNzIjoiQml0ZWwiLCJhdW"
        "QiOiJCaXRlbCJ9.OsL3JS-5ox7sFHtCk5U9TsrLFOId3QyKpYy33iip6mY";
    final Map<String, dynamic> bitel = {
      "message": "سلام کد تایید شما در بازیافتچی $_randomNumber",
      "phoneNumber": "$_phoneNumber"
    };
    var response = await http.post(bitelUrl,
        body: json.encode(bitel),
        headers: {
          "authorization": "Bearer $authToken",
          "content-type": "application/json"
        });
    return jsonDecode(response.body);
  }

  static Future<String> getRegisterSmsConfirmation(String _phoneNumber,
      String _name, String _password, var responseResult, String _value) async {
    final Map<String, dynamic> registerFields = {
      "phone_number": _phoneNumber,
      "name": _name,
      "password": _password,
    };

    final Map<String, dynamic> loginFields = {
      "login": "$_phoneNumber",
      "password": "$_password",
    };
    print("random number is: $_randomNumber");

    final APP_ID = "/9E4CCE4C-0A66-4BCF-FF12-76992420E600";
    final REST_API_KEY = "/05C5912E-750A-EBD6-FF10-3573790FF000";
    final BASE_URL = "https://api.backendless.com";
    final REGISTER_URL = BASE_URL + APP_ID + REST_API_KEY + "/users/register";
    final LOGIN_URL = BASE_URL + APP_ID + REST_API_KEY + "/users/login";

    String requestId = (await responseResult)["result"]["requestId"];
    final String authToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzM"
        "jc3IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L"
        "2NsYWltcy9yb2xlIjoiMSIsImV4cCI6MTU1MjQwNTUzNywiaXNzIjoiQml0ZWwiLCJhdW"
        "QiOiJCaXRlbCJ9.OsL3JS-5ox7sFHtCk5U9TsrLFOId3QyKpYy33iip6mY";
    final response = await http.get(
        "https://api.bitel.rest/api/v1/sms/detail/single/$requestId",
        headers: {
          "authorization": "Bearer $authToken",
          "content-type": "application/json",
        });
    var res = json.decode(response.body);
    if (res["result"]["message"].toString().contains("$_randomNumber") &&
        _value == _randomNumber.toString()) {
      http.post(REGISTER_URL, body: json.encode(registerFields), headers: {
        "Content-Type": "application/json"
      }).then((http.Response registerResponse) {
        var registerRes = json.decode(registerResponse.body);
        if (registerRes["userStatus"].toString() == "ENABLED") {
          http.post(LOGIN_URL, body: json.encode(loginFields), headers: {
            "Content-Type": "application/json"
          }).then((http.Response loginResponse) {
            var loginRes = json.decode(loginResponse.body);
            var save = SaveLoginAndLogout();
            save.saveLogin(loginRes["user-token"], loginRes["objectId"],
                loginRes["phone_number"]);
            print(loginRes["user-token"]);
            print(loginResponse.body);
          });
        } else {
          print("نه غلطه");
        }
      });
      //print(loginFields["login"].toString());
      //print(loginFields["password"].toString());
    } else {
      print("ثبت نام ناموفق");
    }
    return _randomNumber.toString();
  }

  static updateAddress(String _address) async {
    final Map<String, dynamic> updateFields = {
      "address": "$_address",
    };
    final APP_ID = "/9E4CCE4C-0A66-4BCF-FF12-76992420E600";
    final REST_API_KEY = "/05C5912E-750A-EBD6-FF10-3573790FF000";
    final BASE_URL = "https://api.backendless.com";
    var save = SaveLoginAndLogout();
    final _objectId = await save.getObjectId();
    final UPDATE_ADDRESS_URL =
        BASE_URL + APP_ID + REST_API_KEY + "/users/$_objectId";

    http.put(
      UPDATE_ADDRESS_URL,
      body: json.encode(updateFields),
      headers: {"Content-Type": "application/json"},
    ).then((http.Response updateRes) {
      print(updateRes.body);
    });
  }

  static updateOrder(String _orderTime, String _orderDate) async {
    final Map<String, dynamic> updateFields = {
      "order_date": "$_orderDate",
      "order_time": "$_orderTime",
    };
    final APP_ID = "/9E4CCE4C-0A66-4BCF-FF12-76992420E600";
    final REST_API_KEY = "/05C5912E-750A-EBD6-FF10-3573790FF000";
    final BASE_URL = "https://api.backendless.com";
    var save = SaveLoginAndLogout();
    final _objectId = await save.getObjectId();
    final _userToken = await save.getUserToken();
    final SAVE_DATA_OBJECT_URL =
        BASE_URL + APP_ID + REST_API_KEY + "/data/orders";
    final ADD_RELATION_URL =
        BASE_URL + APP_ID + REST_API_KEY + "/data/Users/$_objectId/orders";

    http.post(
      SAVE_DATA_OBJECT_URL,
      body: json.encode(updateFields),
      headers: {
        "Content-Type": "application/json",
        //"user-token": "$_userToken"
      },
    ).then((http.Response updateRes) {
      print(updateRes.body);
      //Network.sendLog(updateRes.body);
      var res = json.decode(updateRes.body);
      http.put(
        ADD_RELATION_URL,
        body: json.encode([res["objectId"]]),
        headers: {
          "Content-Type": "application/json",
          //"user-token": "$_userToken",
        },
      ).then((http.Response relationResponse) {
        var relRes = relationResponse.body;
        print("relation response is: $relRes");
      });
    });
  }

  static Future<String> checkLoginState(
      String _phoneNumber, String _password) async {
    final Map<String, dynamic> loginFields = {
      "login": "$_phoneNumber",
      "password": "$_password",
    };
    final APP_ID = "/9E4CCE4C-0A66-4BCF-FF12-76992420E600";
    final REST_API_KEY = "/05C5912E-750A-EBD6-FF10-3573790FF000";
    final BASE_URL = "https://api.backendless.com";
    final LOGIN_URL = BASE_URL + APP_ID + REST_API_KEY + "/users/login";

    final response = await http.post(LOGIN_URL,
        body: json.encode(loginFields),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return json.decode(response.body)["phone_number"];
    } else {
      return "nothing";
    }
  }

  static Future<String> checkAddress() async {
    final save = SaveLoginAndLogout();
    final String _phoneNumber = await save.getPhoneNumber();
    final Map<String, dynamic> loginFields = {
      "login": "$_phoneNumber",
      "password": "ttdkbhg",
    };
    final APP_ID = "/9E4CCE4C-0A66-4BCF-FF12-76992420E600";
    final REST_API_KEY = "/05C5912E-750A-EBD6-FF10-3573790FF000";
    final BASE_URL = "https://api.backendless.com";
    final LOGIN_URL = BASE_URL + APP_ID + REST_API_KEY + "/users/login";

    final response = await http.post(LOGIN_URL,
        body: json.encode(loginFields),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return json.decode(response.body)["address"];
    } else {
      return "nothing";
    }
  }

  static Future<String> getLoginSmsConfirmation(String _phoneNumber,
      String _password, var responseResult, String _value) async {
    var save = SaveLoginAndLogout();
    final Map<String, dynamic> loginFields = {
      "login": "$_phoneNumber",
      "password": "$_password",
    };
    final APP_ID = "/9E4CCE4C-0A66-4BCF-FF12-76992420E600";
    final REST_API_KEY = "/05C5912E-750A-EBD6-FF10-3573790FF000";
    final BASE_URL = "https://api.backendless.com";
    final LOGIN_URL = BASE_URL + APP_ID + REST_API_KEY + "/users/login";

    String requestId = (await responseResult)["result"]["requestId"];
    final String authToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzM"
        "jc3IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L"
        "2NsYWltcy9yb2xlIjoiMSIsImV4cCI6MTU1MjQwNTUzNywiaXNzIjoiQml0ZWwiLCJhdW"
        "QiOiJCaXRlbCJ9.OsL3JS-5ox7sFHtCk5U9TsrLFOId3QyKpYy33iip6mY";
    final response = await http.get(
        "https://api.bitel.rest/api/v1/sms/detail/single/$requestId",
        headers: {
          "authorization": "Bearer $authToken",
          "content-type": "application/json",
        });
    var res = json.decode(response.body);
    if (res["result"]["message"].toString().contains("$_randomNumber") &&
        _value == _randomNumber.toString()) {
      http.post(LOGIN_URL, body: json.encode(loginFields), headers: {
        "Content-Type": "application/json"
      }).then((http.Response loginResponse) {
        var loginRes = json.decode(loginResponse.body);
        if (loginResponse.statusCode == 200) {
          save.saveLogin(loginRes["user-token"], loginRes["objectId"],
              loginRes["phone_number"]);
          print(loginRes["user-token"]);
          print(loginResponse.body);
        }
      });
    } else {
      print("ثبت نام ناموفق");
    }
    return _randomNumber.toString();
  }

  Future<bool> loginWithUserToken(String _userToken) async {
    final APP_ID = "/9E4CCE4C-0A66-4BCF-FF12-76992420E600";
    final REST_API_KEY = "/05C5912E-750A-EBD6-FF10-3573790FF000";
    final BASE_URL = "https://api.backendless.com";
    final USER_TOKEN_URL = BASE_URL +
        APP_ID +
        REST_API_KEY +
        "/users/isvalidusertoken/$_userToken";
    var tokenResponse = await http.get(USER_TOKEN_URL);
    print("token in loginer is: $_userToken");
    print("token in loginer is:" + tokenResponse.body);
    return tokenResponse.body == "true";
  }

  static sendLog(String _message) {
    final APP_ID = "/9E4CCE4C-0A66-4BCF-FF12-76992420E600";
    final REST_API_KEY = "/05C5912E-750A-EBD6-FF10-3573790FF000";
    final BASE_URL = "https://api.backendless.com";
    final SEND_LOG_URL = BASE_URL + APP_ID + REST_API_KEY + "/log";

    http.put(SEND_LOG_URL,
        body: json.encode([
          {
            "log-level": "INFO",
            "logger": "com.my.Logger",
            "timestamp": 1498488261599,
            "message": "$_message"
          }
        ]),
        headers: {"Content-Type": "application/json"});
  }


}
