import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import '../constants.dart';
import '../validation.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  List<String> areaList = [];
  final int deposit = 500;
  bool isDeposited = false;
  bool isChecked = false;
  final signupFormKey = GlobalKey<FormState>();
  final passwordFieldKey = GlobalKey<FormFieldState>();
  bool signupFormAutoValidation = false;
  String firstName,
      lastName,
      email,
      password,
      contactNo,
      address,
      area,
      city = "Rajkot";

  String validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Confirm password is required';
    }
    if (passwordFieldKey.currentState.value != value) {
      return 'Password not matching';
    }
    return null;
  }

  void validateForm() {
    if (signupFormKey.currentState.validate()) {
      signupFormKey.currentState.save();
      signup();
    } else {
      setState(() {
        signupFormAutoValidation = true;
      });
    }
  }

  void signup() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/signup/',
          json: {
            "email_id": email,
            "password": password,
            "first_name": firstName,
            "last_name": lastName,
            "mobile_num": contactNo,
            "address": address,
            "area": area,
            "city": city
          });
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          User user = User.fromJson(userJson);
          user.setPreference();
          Fluttertoast.showToast(
              msg: 'Sign up successful',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pushReplacementNamed(context, '/');
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
          msg: 'Unable to sign up. Please try again later',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void fetchAreas() async {
    try {
      var response = await Requests.post(
        'http://52.236.33.218/booksharingsystem/user_area/',
      );
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var areaJson = response.json();

        if (areaJson['count'] > 0) {
          int count = areaJson['count'];
          for (int i = 0; i < count; i++) {
            areaList.add(areaJson['area$i']);
          }

          setState(() {});
        } else {
          Fluttertoast.showToast(
              msg: 'Unable to fetch data. Please try again later',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pushReplacementNamed(context, '/');
        }
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: 'Unable to fetch data. Please try again later',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void paymentGateway() {
    Navigator.pushNamed(context, '/paymentGatewayScreen');
    setState(() {
      isDeposited = true;
    });
  }

  void _showModal() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setCheckboxState) {
            return Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    height: 300.0,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'By using our Book Sharing Mobile Application or any other Application services, you are agreeing to be bound by the following terms and conditions.\n\n==> Our updated Terms and Privacy Policy are easier to understand and reflect new updated features.\n\n==> We will explore ways for you to communicate with each other using the Book sharing application, such as through order, transaction, and appointment information, delivery, and returning notifications, and updates for products and services.\n\n==>You are responsible for keeping your device and your Application account safe and secure.\n\n==> You must register first for our Services using accurate data, provide your current mobile phone number, and, if you change it, update this mobile phone number using our in-app update profile feature.\n\n==> Your deposit amount will be deducted if you haven\'t submitted the book and the Admin get a complaint about no book return from your side.\n\n==> You must access and use our Services only for legal, authorized, and acceptable purposes.\n\n==> Our Services may allow you to access, use, or interact with third-party websites, apps, content, and other products and services.\n\n==> Please note that when you use third-party services, their own terms and privacy policies will govern your use of those services.\n\n==> We own all copyrights, trademarks, domains, logos, trade dress, trade secrets, patents, and other intellectual property rights associated with our Services. You are not allowed to use it directly without permission.\n\n==> We may collect, use, preserve, and share your information if we have a good-faith belief that it is reasonably necessary to respond pursuant to applicable law or regulations, to legal process, or to government requests.',
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        child: Text('Reject'),
                        onPressed: () {
                          setState(() {
                            isChecked = false;
                          });
                          Navigator.pop(context);
                        },
                        color: Colors.grey[200],
                      ),
                      RaisedButton(
                        child: Text('Accept'),
                        onPressed: () {
                          setState(() {
                            isChecked = true;
                          });
                          Navigator.pop(context);
                        },
                        color: Colors.redAccent,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  @override
  void initState() {
    fetchAreas();
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
              key: signupFormKey,
              autovalidate: signupFormAutoValidation,
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
                              keyboardType: TextInputType.text,
                              validator: validateFirstName,
                              onSaved: (value) => firstName = value,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'First Name',
                                hintText: 'Enter your first name',
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              validator: validateLastName,
                              onSaved: (value) => lastName = value,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Last Name',
                                hintText: 'Enter your last name',
                                prefixIcon: Icon(Icons.edit),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail,
                              onSaved: (value) => email = value,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              key: passwordFieldKey,
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
                              height: 20.0,
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: validateConfirmPassword,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Confirm Password',
                                hintText: 'Enter your password again',
                                prefixIcon: Icon(Icons.check),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: false, signed: false),
                              validator: validateContactNo,
                              onSaved: (value) => contactNo = value,
                              maxLength: 10,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Contact No.',
                                hintText: 'Enter your contact number',
                                prefixIcon: Icon(Icons.call),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              maxLines: 4,
                              validator: validateAddress,
                              onSaved: (value) => address = value,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Address',
                                hintText: 'Enter your address',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.redAccent, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.redAccent, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            DropdownButtonFormField<String>(
                              value: area,
                              validator: validateArea,
                              onSaved: (value) => area = value,
                              isExpanded: true,
                              hint: Text('Select area'),
                              items: areaList.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  area = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              enabled: false,
                              validator: validateCity,
                              onSaved: (value) => city = 'Rajkot',
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Rajkot',
                                prefixIcon: Icon(Icons.location_city),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  'Deposit: ₹ $deposit',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 10.0, 0.0, 5.0),
                                  child: RaisedButton(
                                    color: Colors.redAccent,
                                    textColor: Colors.white,
                                    onPressed: !isDeposited
                                        ? () {
                                            paymentGateway();
                                          }
                                        : null,
                                    shape: kRoundedBorder,
                                    child: Text('PAY'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  onChanged: (bool value) {
                                    setState(() {
                                      _showModal();
                                    });
                                  },
                                  value: isChecked,
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                                Text(
                                  'Agree Terms & Condition',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 10.0, 0.0, 5.0),
                              child: RaisedButton(
                                color: Colors.redAccent,
                                textColor: Colors.white,
                                onPressed: isChecked && isDeposited
                                    ? validateForm
                                    : null,
                                shape: kRoundedBorder,
                                child: Text('SIGNUP'),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, '/');
                              },
                              child: Text('LOGIN'),
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