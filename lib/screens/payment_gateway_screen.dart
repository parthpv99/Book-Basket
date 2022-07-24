import '../constants.dart';
import '../validation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';

class PaymentGatewayScreen extends StatefulWidget {
  @override
  _PaymentGatewayScreenState createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  final paymentGatewayFormKey = GlobalKey<FormState>();
  bool paymentGatewayFormAutoValidation = false;
  String otp = '';

  void validateForm() {
    if (paymentGatewayFormKey.currentState.validate()) {
      paymentGatewayFormKey.currentState.save();
      // paymentGateway();
      Navigator.pushNamed(context, '/spinnerScreen').then((context) {
        Fluttertoast.showToast(
          msg: 'Deposit paid successfully',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
        Navigator.pop(context);
      });
      
    } else {
      setState(() {
        paymentGatewayFormAutoValidation = true;
      });
    }
  }

  // Future<void> paymentGateway() async {
  //   try {
  //     var response = await Requests.post(
  //         'https://booksharingsystem.000webhostapp.com/otp_validation/',
  //         json: {"otp": otp});
  //     response.raiseForStatus();

  //     if (response.statusCode == 200) {
  //       var userJson = response.json();

  //       if (!userJson["is_error"]) {
  //         Fluttertoast.showToast(
  //             msg: 'Deposit paid successfully',
  //             toastLength: Toast.LENGTH_LONG,
  //             backgroundColor: Colors.green,
  //             textColor: Colors.white,
  //             fontSize: 16.0);

  //         Navigator.pushNamed(context, '/spinnerScreen');
  //         Navigator.pop(context);
  //       } else {
  //         Fluttertoast.showToast(
  //             msg: userJson["message"],
  //             toastLength: Toast.LENGTH_LONG,
  //             backgroundColor: Colors.red,
  //             textColor: Colors.white,
  //             fontSize: 16.0);
  //       }
  //     }
  //   } on Exception catch (e) {
  //     Fluttertoast.showToast(
  //         msg: 'Error. Please try again later',
  //         toastLength: Toast.LENGTH_LONG,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Card(
                color: Colors.yellow[50],
                shape: kRoundedBorder,
                margin: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'Payment Gateway',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Authenticate your online transaction with One Time Password',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'Mechant: RMC',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Amount: Rs 500.00',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Form(
                      key: paymentGatewayFormKey,
                      autovalidate: paymentGatewayFormAutoValidation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    validator: validateOTP,
                                    onSaved: (value) => otp = value,
                                    decoration: kTextFieldDecoration.copyWith(
                                      labelText: 'OTP',
                                      hintText: 'Enter your otp',
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
                                    child: Text('PAY AMOUNT'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}