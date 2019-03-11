import 'package:flutter/material.dart';
import 'package:flutter_application/utils/network.dart';

class RequestPackage extends StatefulWidget {
  @override
  RequestPackageState createState() {
    return new RequestPackageState();
  }
}

class RequestPackageState extends State<RequestPackage> {
  String _address;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("ثبت آدرس"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50,),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "آدرس دقیق",
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return "آدرس وارد نشده است";
                    }
                  },
                  onSaved: (val){
                    setState(() {
                      _address = val;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 40,),
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
                child: Text("درخواست"),
                onPressed: _submitAddress,
              ),
            ),
            SizedBox(height: 40,),
            Text("نکته: آدرس باید کاملا دقیق باشد"),
          ],
        ),
      ),
    );
  }

  _submitAddress()async {
    final state = _formKey.currentState;
    if(state.validate()){
      print('chizzzzzzzzzzz');
      state.save();
      print(_address);
      Network.updateAddress(_address);
      _scaffoldKey.currentState.
      showSnackBar(SnackBar(
        content: Text("آدرس با موفقیت ثبت شد"),
        backgroundColor: Colors.green,duration: Duration(seconds: 2),),);
    }else{
      _scaffoldKey.currentState.
      showSnackBar(SnackBar(
        content: Text("آدرس با موفقیت ثبت نشد"),
        backgroundColor: Colors.red,duration: Duration(seconds: 2),),);
    }

    Future.delayed(Duration(seconds: 2),(){
      Navigator.pop(context);
    });
  }
}
