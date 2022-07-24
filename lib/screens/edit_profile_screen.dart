import 'dart:convert';
import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import '../constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../validation.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String> areaList = [];
  User u;
  File _image;

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
      saveEdits();
    } else {
      setState(() {
        signupFormAutoValidation = true;
      });
    }
  }

  void saveEdits() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/update_profile/',
          json: {
            "first_name": firstName,
            "last_name": lastName,
            "mobile_num": contactNo,
            "address": address,
            "area": area,
            "city": "Rajkot",
            "display_picture": _image == null ? null : imageTObase64(_image),
          });
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          u.firstName = firstName;
          u.lastName = lastName;
          u.mobileNo = contactNo;
          u.address = address;
          u.area = area;

          u.jsonString = jsonEncode({
            "user_id": u.id,
            "email_id": u.email,
            "first_name": u.firstName,
            "last_name": u.lastName,
            "mobile_num": u.mobileNo,
            "address": u.address,
            "area": u.area,
            "city": "Rajkot",
            "points": u.points,
          });

          u.setPreference();

          Fluttertoast.showToast(
              msg: 'Saved Successfully',
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

  void getUser() async {
    u = await User.fromSharedPreference;
    area = u.area;
  }

  String imageTObase64(File img) {
    return base64Encode(img.readAsBytesSync());
  }

  @override
  void initState() {
    fetchAreas();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _getImage() async {
      var image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        _image = image;
      });
    }

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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'dp',
                        child: InkWell(
                          onTap: () {
                            _getImage();
                          },
                          child: Stack(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: _image == null
                                    ? AssetImage('assets/user.png')
                                    : FileImage(
                                        _image,
                                      ),
                                radius: 55.0,
                              ),
                              Positioned(
                                bottom: 0.0,
                                child: InkWell(
                                  onTap: () {
                                    _getImage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 20.0,
                                      minHeight: 20.0,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      InkWell(
                        onTap: () {
                          _getImage();
                        },
                        child: Text(
                          'Change Photo',
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
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
                              initialValue: u.firstName,
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
                              initialValue: u.lastName,
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
                              height: 15.0,
                            ),
                            TextFormField(
                              initialValue: u.mobileNo,
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
                              initialValue: u.address,
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 10.0, 0.0, 5.0),
                              child: RaisedButton(
                                color: Colors.redAccent,
                                textColor: Colors.white,
                                onPressed: validateForm,
                                shape: kRoundedBorder,
                                child: Text('Save Edits'),
                              ),
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
