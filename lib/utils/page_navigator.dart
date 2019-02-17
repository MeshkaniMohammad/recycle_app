import 'package:flutter/material.dart';

class PageNavigator {
  static pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page,
    ));
  }
}
