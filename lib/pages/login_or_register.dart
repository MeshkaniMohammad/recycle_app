import 'package:flutter/material.dart';
import 'package:flutter_application/pages/login_page.dart';
import 'package:flutter_application/pages/register_page.dart';
import 'package:flutter_application/utils/page_navigator.dart';

class LoginOrRegister extends StatefulWidget {
  _LoginOrRegisterState createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Login"),
              onPressed: ()=>PageNavigator.pushPage(context, LoginPage()),
            ),
            RaisedButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  ),
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
