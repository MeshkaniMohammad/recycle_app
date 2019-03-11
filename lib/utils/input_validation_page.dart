import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/utils/validator.dart';

class InputValidationPage extends StatefulWidget {
  InputValidationPage({
    @required this.title,
    this.inputDecoration = const InputDecoration(),
    this.textFieldStyle,
    this.textAlign = TextAlign.start,
    @required this.submitText,
    @required this.keyboardType,
    @required this.inputFormatter,
    @required this.submitValidator,
    this.onSubmit,
    this.flag,
  });

  InputValidationPage.phoneNumberChecker({
    @required this.title,
    this.inputDecoration = const InputDecoration(),
    this.textFieldStyle,
    this.textAlign = TextAlign.start,
    @required this.submitText,
    @required this.keyboardType,
    @required this.inputFormatter,
    @required this.submitValidator,
    this.onSubmit,
    this.flag,
  });

  final String title;
  final InputDecoration inputDecoration;
  final TextStyle textFieldStyle;
  final TextAlign textAlign;
  final String submitText;
  final TextInputType keyboardType;
  final TextInputFormatter inputFormatter;
  final StringValidator submitValidator;
  final ValueChanged<String> onSubmit;
  final bool flag; //true == LoginPage and false == RegisterPage
  @override
  InputValidationPageState createState() => InputValidationPageState();
}

class InputValidationPageState extends State<InputValidationPage>
    with SingleTickerProviderStateMixin {
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = FocusNode();
  String _value = '';



  @override
  void initState() {
    super.initState();

  }

  void _submit() async {
    bool valid = widget.submitValidator.isValid(_value);
    if (valid) {
      _focusNode.unfocus();
      widget.onSubmit(_value);
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title, style: TextStyle(fontSize: 24.0)),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildTextField() {
    return TextField(
      decoration: widget.inputDecoration,
      style: widget.textFieldStyle,
      textAlign: widget.textAlign,
      keyboardType: widget.keyboardType,
      autofocus: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        widget.inputFormatter,
      ],
      focusNode: _focusNode,
      onChanged: (value) {
        setState(() => _value = value);
      },
      onEditingComplete: _submit,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
          child: Center(child: _buildTextField()),
        ),
        Text("تا یک دقیقه منتظر کد تایید پیامکی بمانید"),
        Expanded(child: Container()),
        _buildDoneButton(context),
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    bool valid = widget.submitValidator.isValid(_value);
    return Opacity(
      opacity: valid ? 1.0 : 0.0,
      child: Container(
        constraints:
            BoxConstraints.expand(width: double.infinity, height: 60.0),
        child: FlatButton(
          color: Colors.green[500],
          child: Text(widget.submitText, style: TextStyle(fontSize: 20.0)),
          onPressed: _submit,
        ),
      ),
    );
  }
}
