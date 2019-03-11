import 'package:flutter/material.dart';
import 'package:flutter_application/utils/network.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:persian_datepicker/persian_datepicker.dart';

class PurgePackage extends StatefulWidget {
  @override
  PurgePackageState createState() {
    return new PurgePackageState();
  }
}

class PurgePackageState extends State<PurgePackage> {
  final TextEditingController textEditingController = TextEditingController();
  String _orderTime;
  String _orderDate;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PersianDatePickerWidget persianDatePicker;

  @override
  void initState() {
    persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      onChange: (String oldText, String newText) {
        print(oldText);
        print(newText);
        setState(() {
          _orderDate = newText;
        });
      },
    ).init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text('درخواست تحویل زباله ها'),
      ),
      body: Builder(builder: (BuildContext context) {
        return Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "انتخاب تاریخ تحویل زباله ها",
                    ),
                    enableInteractiveSelection: false,
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return persianDatePicker;
                          });
                    },
                    controller: textEditingController,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(
                    hintText: "انتخاب زمان تحویل زباله ها",
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    DatePicker.showTimePicker(context,
                        currentTime: DateTime.now(),
                        locale: LocaleType.en, onConfirm: (value) {
                      print("زمان $value  است ");
                      setState(() {
                        _orderTime = value.toString();
                      });
                    }, showTitleActions: true);
                  },
                ),
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
                child: Text(" درخواست تحویل زباله"),
                onPressed: _submitRequest,
              ),
            ),
          ],
        );
      }),
    );
  }

  void _submitRequest() {
    if (_orderTime.isEmpty || _orderDate.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("درخواست با موفقیت ثبت نشد.دوباره تلاش کنید"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      Network.updateOrder(_orderTime, _orderDate);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("درخواست با موفقیت ثبت شد"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}
