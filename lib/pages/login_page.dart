import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/pages/home.dart';
import 'package:flutter_application/utils/input_validation_page.dart';
import 'package:flutter_application/utils/network.dart';
import 'package:flutter_application/utils/page_navigator.dart';
import 'package:flutter_application/utils/validator.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  String _phoneNumber;
  String _password;
  String _name;
  var _responseResult;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: loginForm(),
        ),
      ),
    );
  }

  List<Widget> loginForm() {
    return [
      Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(hintText: "insert phone number"),
              onSaved: (val) {
                setState(() {
                  _phoneNumber = val;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "insert password"),
              onSaved: (val) {
                setState(() {
                  _password = val;
                });
              },
            ),
          ],
        ),
      ),
      RaisedButton(
        onPressed: () {
          final form = formKey.currentState;
          form.save();
          PageNavigator.pushPage(
            context,
            InputValidationPage.phoneNumberChecker(
              title: "confirmation",
              submitText: "submit",
              keyboardType: TextInputType.number,
              inputFormatter: ValidatorInputFormatter(
                editingValidator: PhoneNumberEditingRegexValidator(),
              ),
              submitValidator: PhoneNumberSubmitRegexValidator(),
              onSubmit: (value) => _onSubmit(context, value),
            ),
          );
          setState(() {
            _responseResult = Network.postSmsConfirmation();
          });
        },
        child: Text("register"),
      )
    ];
  }

  void _onSubmit(BuildContext context, String value) {
    Network.getLoginSmsConfirmation(_phoneNumber, _name, _password, _responseResult);
    PageNavigator.pushPage(context, Home());
  }
}

class PhoneNumberEditingRegexValidator extends RegexValidator {
  PhoneNumberEditingRegexValidator() : super(regexSource: "^\d{4}\$");
}

class PhoneNumberSubmitRegexValidator extends StringValidator {
  @override
  bool isValid(String value) {
    try {
      final number = int.parse(value);
      return (number > 999 && number < 10000);
    } catch (e) {
      return false;
    }
  }
}