import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import '../constants.dart';
import '../validation.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final forgotPasswordFormKey = GlobalKey<FormState>();
  bool forgotPasswordFormAutoValidation = false;
  String email = '';

  void validateForm() {
    if (forgotPasswordFormKey.currentState.validate()) {
      forgotPasswordFormKey.currentState.save();
      forgotPassword();
    } else {
      setState(() {
        forgotPasswordFormAutoValidation = true;
      });
    }
  }

  void forgotPassword() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/forgot_password/',
          json: {"email_id": email});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          Fluttertoast.showToast(
              msg: 'Check email for the new password',
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
      backgroundColor: Colors.red[50],
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: forgotPasswordFormKey,
              autovalidate: forgotPasswordFormAutoValidation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'book',
                        child: Image.asset(
                          'assets/book_logo.png',
                          scale: 0.8,
                        ),
                      ),
                    ],
                  ),
                  Hero(
                    tag: 'title',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'Book Sharing System',
                        style: kTextTitle,
                      ),
                    ),
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
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail,
                              onSaved: (value) => email = value,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                prefixIcon: Icon(Icons.person),
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
                              child: Text('SEND PASSWORD'),
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