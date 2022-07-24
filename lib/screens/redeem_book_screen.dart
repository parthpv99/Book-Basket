import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import '../validation.dart';

class RedeemBookScreen extends StatefulWidget {
  @override
  _RedeemBookScreenState createState() => _RedeemBookScreenState();
}

class _RedeemBookScreenState extends State<RedeemBookScreen> {
  final redeemBookFormKey = GlobalKey<FormState>();
  bool redeemBookFormAutoValidation = false;
  String code = '';

  void validateForm() {
    if (redeemBookFormKey.currentState.validate()) {
      redeemBookFormKey.currentState.save();
      redeemBook();
    } else {
      setState(() {
        redeemBookFormAutoValidation = true;
      });
    }
  }

  void redeemBook() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/redeem_book/',
          json: {"redeem_code": code});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          Fluttertoast.showToast(
              msg: 'Book redeemed successfully',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(
              msg: userJson["message"],
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: 'Error. Please try again later',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Redeem Book'),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: redeemBookFormKey,
              autovalidate: redeemBookFormAutoValidation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Card(
                      shape: kRoundedBorder,
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              validator: validateCode,
                              onSaved: (value) => code = value,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Redeem Code',
                                hintText: 'Enter your redeem code',
                                prefixIcon: Icon(Icons.vpn_key),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            RaisedButton(
                              color: Colors.redAccent,
                              textColor: Colors.white,
                              onPressed: validateForm,
                              shape: kRoundedBorder,
                              child: Text('REDEEM BOOK'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
