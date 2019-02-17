import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_application/pages/home.dart';
import 'package:flutter_application/pages/login_or_register.dart';
import 'package:flutter_application/utils/network.dart';
import 'package:flutter_application/utils/page_navigator.dart';
import 'package:flutter_application/utils/save_login_logout.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class SplashScreenPage extends StatefulWidget {
  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  final _tokenSaver = SaveLoginAndLogout();
  final _network = Network();
  String _userToken;
  final int _splashDuration = 5;
  initToken() async{
    _userToken = await _tokenSaver.getUserToken();
  }
  startTime() async {
    _userToken = await _tokenSaver.getUserToken();
    return Timer(
        Duration(seconds: _splashDuration),
            () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          PageNavigator.pushPage(context, _navigateAfterSeconds());
        }
    );
  }
@override
  void setState(fn) {
  super.setState(fn);
  initToken();
  print(_userToken);
  }
  @override
  void initState() {
    super.initState();
    startTime();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("این صفحه اسپلش هست"),
      ),
    );
  }


  Widget _navigateAfterSeconds() {
    return FutureBuilder<bool>(
      future: _network.loginWithUserToken(_userToken),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if(!snapshot.hasData) return Container();
        print(snapshot.data.toString());
        if(snapshot.data) {
          return Home();
        } else {
          return LoginOrRegister();
        }
      },
    );
  }
}


