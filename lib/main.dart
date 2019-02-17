import 'package:flutter/material.dart';
import 'package:flutter_application/pages/splash_screen_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(accentColor: Colors.green[500]),
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
    );
  }
}