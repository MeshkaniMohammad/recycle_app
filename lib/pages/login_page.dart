import 'package:flutter/material.dart';
import 'package:flutter_application/pages/home.dart';
import 'package:flutter_application/utils/input_validation_page.dart';
import 'package:flutter_application/utils/network.dart';
import 'package:flutter_application/utils/page_navigator.dart';
import 'package:flutter_application/utils/validator.dart';

enum LoginState {
  Login,
  Register,
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String _phoneNumber;
  String _name;
  var _responseResult;
  var _loginOrRegister;
  String _confirmationCode;

  @override
  void initState() {
    super.initState();
    _loginOrRegister = LoginState.Login;
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: loginForm(),
          ),
        ),
      ),
    );
  }

  List<Widget> loginForm() {
    if (_loginOrRegister == LoginState.Login) {
      return [
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    validator: (value) {
                      if (value.length < 11 || !value.startsWith("09")) {
                        return "شماره موبایل شما صحیح نیست";
                      }
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "شماره موبایل",
                    ),
                    onSaved: (val) {
                      setState(() {
                        _phoneNumber = val;
                      });
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 60,
          width: 250,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [
                0.0,
                1.0,
              ],
              tileMode: TileMode.clamp,
              colors: [
                Colors.lightGreenAccent[400],
                Colors.lightGreenAccent[700],
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
          ),
          child: RaisedButton(
            shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            color: Colors.transparent,
            textColor: Colors.black87,
            onPressed: () async {
              final form = _formKey.currentState;
              if (form.validate()) {
                form.save();
                String _loginPhoneNumber =
                    await Network.checkLoginState(_phoneNumber, "ttdkbhg");
                print("شماره ثبت نامی $_loginPhoneNumber");
                if (_loginPhoneNumber == "$_phoneNumber") {
                  PageNavigator.pushPage(
                    context,
                    InputValidationPage.phoneNumberChecker(
                      title: "فعال سازی حساب کاربری",
                      submitText: "تایید",
                      keyboardType: TextInputType.number,
                      inputFormatter: ValidatorInputFormatter(
                        editingValidator: PhoneNumberEditingRegexValidator(),
                      ),
                      submitValidator: PhoneNumberSubmitRegexValidator(),
                      onSubmit: (value) => _onSubmit(context, value),
                    ),
                  );
                  setState(() {
                    _responseResult = Network.postSmsConfirmation(_phoneNumber);
                  });
                } else {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text("شما هنوز ثبت نام نکرده اید"),
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text("ورود"),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        FlatButton(
          onPressed: () {
            _formKey.currentState.reset();
            FocusScope.of(context).requestFocus(new FocusNode());
            setState(() {
              _loginOrRegister = LoginState.Register;
            });
          },
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "عضویت",
              style: TextStyle(color: Colors.green),
            ),
            Text("عضو نیستید؟"),
          ]),
        ),
      ];
    } else {
      return [
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    validator: (value) {
                      if (value.length == 0) {
                        return "این فیلد نباید خالی باشد!";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "نام و نام خانوادگی",
                    ),
                    onSaved: (val) {
                      setState(() {
                        _name = val;
                      });
                    },
                    keyboardType: TextInputType.text,
                    maxLength: 40,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    validator: (value) {
                      if (value.length == 0 || !value.startsWith("09")) {
                        return "شماره موبایل شما صحیح نیست";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "شماره موبایل",
                    ),
                    onSaved: (val) {
                      setState(() {
                        _phoneNumber = val;
                      });
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          width: 250,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [
                0.0,
                1.0,
              ],
              tileMode: TileMode.clamp,
              colors: [
                Colors.lightGreenAccent[400],
                Colors.lightGreenAccent[700],
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
          ),
          child: RaisedButton(
            shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            color: Colors.transparent,
            textColor: Colors.black87,
            onPressed: () {
              final form = _formKey.currentState;
              if (form.validate()) {
                form.save();
                PageNavigator.pushPage(
                  context,
                  InputValidationPage.phoneNumberChecker(
                    title: "فعال سازی حساب کاربری",
                    submitText: "تایید",
                    keyboardType: TextInputType.number,
                    inputFormatter: ValidatorInputFormatter(
                      editingValidator: PhoneNumberEditingRegexValidator(),
                    ),
                    submitValidator: PhoneNumberSubmitRegexValidator(),
                    onSubmit: (value) => _registerOnSubmit(context, value),
                  ),
                );
                setState(() {
                  _responseResult = Network.postSmsConfirmation(_phoneNumber);
                });
              }
            },
            child: Text("عضویت"),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        FlatButton(
            onPressed: () {
              _formKey.currentState.reset();
              FocusScope.of(context).requestFocus(new FocusNode());
              setState(() {
                _loginOrRegister = LoginState.Login;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "ورود",
                  style: TextStyle(color: Colors.green),
                ),
                Text("حساب کاربری دارید؟")
              ],
            )),
      ];
    }
  }

  void _registerOnSubmit(BuildContext context, String value) async {
    _confirmationCode = await Network.getRegisterSmsConfirmation(
        _phoneNumber, _name, "ttdkbhg", _responseResult, value);
    print("value is: $value");
    print("value is: $_confirmationCode");
    if (_confirmationCode == value) {
      PageNavigator.pushPage(context, Home());
    } else {
      InputValidationPageState.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("کد وارد شده صحیح نمی باشد"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }

  }

  void _onSubmit(BuildContext context, String value) async {
    _confirmationCode = await Network.getLoginSmsConfirmation(
        _phoneNumber, "ttdkbhg", _responseResult, value);
    print("value is: $value");
    print("value is: $_confirmationCode");
    if (_confirmationCode == value) {
      PageNavigator.pushPage(context, Home());
    } else {
      InputValidationPageState.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("کد وارد شده صحیح نمی باشد"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }


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
