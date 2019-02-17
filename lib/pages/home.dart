import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BottomNavigationBarItem> tabItems = List.of([
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
  ]);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("اپلیکشن بازیافت"),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.green,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.grey[100],
                child: Image.asset(
                  "assets/earth.jpg",
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    splashColor: Colors.green,
                    highlightColor: Colors.green,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.green,
                      child: Center(
                        child: Text(
                          "تخلیه پکیج",
                          style: TextStyle(color: Colors.black54, fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.orange,
                      child: Center(
                        child: Text(
                          "درخواست پکیج",
                          style: TextStyle(color: Colors.black54, fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              flex: 1,
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: tabItems,
          currentIndex: 1,
          fixedColor: Colors.green,
        ),
        resizeToAvoidBottomPadding: false,
      endDrawer: Drawer(),),
    );
  }
}
