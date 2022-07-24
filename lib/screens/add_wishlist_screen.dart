import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';

class AddWishlistScreen extends StatefulWidget {
  @override
  _AddWishlistScreenState createState() => _AddWishlistScreenState();
}

class _AddWishlistScreenState extends State<AddWishlistScreen> {
  final addWishlistFormKey = GlobalKey<FormState>();
  bool addWishlistFormAutoValidation = false;
  String title = "", author = "";

  String validateTitle(String value) {
    if (value.trim().isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  String validateAuthor(String value) {
    if (value.trim().isEmpty) {
      return 'Author is required';
    }
    if (value.trim().length < 2) {
      return 'Author too short';
    }
    Pattern pattern = r'^[a-zA-Z ]*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Only alphabets are allowed';
    }
    return null;
  }

  void validateForm() {
    if (addWishlistFormKey.currentState.validate()) {
      addWishlistFormKey.currentState.save();
      addWishlist();
    } else {
      setState(() {
        addWishlistFormAutoValidation = true;
      });
    }
  }

  void addWishlist() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/wishlist/add_wishlist.php',
          json: {"book_title": title, "book_author": author});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();
        print(userJson);

        if (!userJson["is_error"]) {
          Fluttertoast.showToast(
              msg: "Added Successfully",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
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
        title: Text('Add Wishlist'),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: addWishlistFormKey,
              autovalidate: addWishlistFormAutoValidation,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/book_wishlist_logo.png',
                      scale: 0.5,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      validator: validateTitle,
                      onSaved: (value) => title = value,
                      decoration: kTextFieldDecoration.copyWith(
                        labelText: 'Title',
                        hintText: 'Enter title',
                        prefixIcon: Icon(Icons.book),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      validator: validateAuthor,
                      onSaved: (value) => author = value,
                      decoration: kTextFieldDecoration.copyWith(
                        labelText: 'Author',
                        hintText: 'Enter author',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    RaisedButton(
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      onPressed: validateForm,
                      shape: kRoundedBorder,
                      child: Text('ADD TO WISHLIST'),
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
