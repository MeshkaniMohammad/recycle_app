import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/pages/home.dart';
import 'package:flutter_application/pages/login_page.dart';
import 'package:flutter_application/utils/network.dart';
import 'package:flutter_application/utils/page_navigator.dart';
import 'package:flutter_application/utils/save_login_logout.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  final _tokenSaver = SaveLoginAndLogout();
  final _network = Network();
  final int _splashDuration = 3;

  startTime() {
    return Timer(Duration(seconds: _splashDuration), () async {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      PageNavigator.pushPage(
          context, _navigateAfterSeconds(await _tokenSaver.getUserToken()));
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(14, 209, 69, 1),
        ),
        child: Center(
          child: Image.asset("assets/green_earth.jpg"),
        ),
      ),
    );
  }

  Widget _navigateAfterSeconds(String _userToken) {
    return FutureBuilder<bool>(
      future: _userToken != null
          ? _network.loginWithUserToken(_userToken)
          : _network.loginWithUserToken("wrongToken"),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) return Container();
        print("data in snapshot is:" + snapshot?.data.toString());
        if (snapshot.data) {
          Network.sendLog("user token is: $_userToken");
          return Home();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
