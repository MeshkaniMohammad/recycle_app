import 'package:flutter/material.dart';
import 'package:flutter_application/pages/purge_package.dart';
import 'package:flutter_application/pages/request_package.dart';
import 'package:flutter_application/utils/network.dart';
import 'package:flutter_application/utils/page_navigator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<BottomNavigationBarItem> tabItems = List.of(
    [
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance_wallet),
        title: Text("سفارشات"),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text("خانه"),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.event_note),
        title: Text("کیف پول"),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final _widgetOptions = [
      Center(child: Text("سفارشات")),
      homeItem(context),
      Center(child: Text("کیف پول")),
    ];
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("بازیافتچی"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.green,
        ),
        body: _widgetOptions.elementAt(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: tabItems,
          currentIndex: _currentIndex,
          fixedColor: Colors.green,
          onTap: _itemOnTap,
        ),
        resizeToAvoidBottomPadding: false,
        endDrawer: _drawer(),
      ),
    );
  }

  Widget homeItem(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Card(
            margin: EdgeInsets.only(bottom: 0),
            elevation: 4,
            child: Container(
              color: Colors.grey[100],
              child: Image.asset(
                "assets/earth.jpg",
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  color: Colors.green,
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/garbege_truck.svg",
                        height: 126,
                        width: 80,
                      ),
                      Text(
                        "تخلیه پکیج",
                        style: TextStyle(color: Colors.black54, fontSize: 22),
                      ),
                    ],
                  )),
                ),
                onTap: _purgePackage,
              ),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  color: Colors.orange,
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Image.asset("assets/recycle_bin.png"),
                      Text(
                        "درخواست پکیج",
                        style: TextStyle(color: Colors.black54, fontSize: 22),
                      ),
                    ],
                  )),
                ),
                onTap: _requestPackage,
              ),
            ],
          ),
          flex: 1,
        )
      ],
    );
  }

  void _itemOnTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _requestPackage() {
    PageNavigator.pushPage(context, RequestPackage());
  }

  void _purgePackage() async {
    final String _address = await Network.checkAddress();
    print("address is: $_address");
    if (_address == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("شما اول باید درخواست پکیج دهید!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          action: SnackBarAction(label: "فهمیدم", onPressed: (){
            _scaffoldKey.currentState.removeCurrentSnackBar();
          }),
        ),
      );
    } else {
      PageNavigator.pushPage(context, PurgePackage());
    }
  }

  Widget _drawer() {
    return Drawer(
      elevation: 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Flexible(
            child: Image.asset("assets/icon.png"),
          ),
          SizedBox(
            height: 40,
          ),
          Divider(
            indent: 4,
          ),
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  onPressed: () {},
                  child: Text("قوانین و مقررات"),
                ),
                Divider(
                  indent: 4,
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text("پیشنهادات و انتقادات"),
                ),
                Divider(
                  indent: 4,
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text("تماس با ما"),
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  child: SvgPicture.asset(
                    "assets/telegram.svg",
                    height: 100,
                    width: 100,
                  ),
                   //_launchURL,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*_launchURL() async {
    const url = 'https://t.me/MohammadMeshkani';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/
}
