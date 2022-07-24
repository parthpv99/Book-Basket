import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import '../constants.dart';
import '../validation.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginFormKey = GlobalKey<FormState>();
  bool loginFormAutoValidation = false;
  String email = '', password = '';

  void validateForm() {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      login();
    } else {
      setState(() {
        loginFormAutoValidation = true;
      });
    }
  }

  void login() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/signin/',
          json: {"email_id": email, "password": password});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          User user = User.fromJson(userJson);
          user.setPreference();
          Navigator.pushReplacementNamed(context, '/manageScreen');
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
          msg: 'Unable to login. Please try again later',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void checkSession() async {
    try {
      var response = await Requests.post(
        'http://52.236.33.218/booksharingsystem/session/',
      );
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          User user = await User.fromSharedPreference;
          if (user.email.length > 0) {
            Navigator.pushReplacementNamed(context, '/manageScreen');
          }
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
  void initState() {
    checkSession();
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
              key: loginFormKey,
              autovalidate: loginFormAutoValidation,
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
                          scale: 1.0,
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
                            TextFormField(
                              obscureText: true,
                              validator: validatePassword,
                              onSaved: (value) => password = value,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/forgotPasswordScreen');
                              },
                              child: Text('Forgot Password?'),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 10.0, 0.0, 5.0),
                              child: RaisedButton(
                                color: Colors.redAccent,
                                textColor: Colors.white,
                                onPressed: validateForm,
                                shape: kRoundedBorder,
                                child: Text('LOGIN'),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/signUpScreen');
                              },
                              child: Text('SIGNUP'),
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