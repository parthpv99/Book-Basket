import '../model/review.dart';
import '../constants.dart';
import '../model/book.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class BookViewScreen extends StatefulWidget {
  String book_id;
  BookViewScreen({this.book_id});
  @override
  _BookViewScreenState createState() => _BookViewScreenState();
}

class _BookViewScreenState extends State<BookViewScreen> {
  int _current = 0;
  bool isCommentPressed = false;
  var rating = 0.0;
  String comment;
  Book book;
  List<Review> reviewList = [];
  List<String> imgList = [];
  bool _isOwner = false; //fetch this field while you call for book view
  //if its true ill be showing generate code button
  //else ill be showing want to read button

  String name, dp, _bookcode = "";

  Future<String> fetchBookCode(String days) async {
    try {
      var response = await Requests.post(
        "http://52.236.33.218/booksharingsystem/key_generation/",
        json: {"book_id": widget.book_id, "no_of_day": days},
      );
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var bookCodeJson = response.json();

        if (!bookCodeJson["is_error"]) {
          _bookcode = bookCodeJson["code"];
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Your Unique Code"),
                  content: Text(bookCodeJson["key"]),
                );
              });
        } else {
          Fluttertoast.showToast(
              msg: bookCodeJson["message"],
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

  Future<void> verifyCode(String code) async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/key_generation/verify_key.php',
          json: {"book_id": widget.book_id, "key": code});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          Fluttertoast.showToast(
              msg: userJson["message"],
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
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

  Future<void> fetchMyBooks() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/fetch_book_details/',
          json: {"book_id": widget.book_id});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          name = userJson["name"];
          if (userJson["owner_id"] == (await User.fromSharedPreference).id) {
            _isOwner = true;
          }
          dp = userJson["display_picture"];
          book = Book.fromJson(userJson);
          if (book.photoPath1 != null) {
            imgList.add(book.photoPath1);
          }
          if (book.photoPath2 != null) {
            imgList.add(book.photoPath2);
          }
          if (book.photoPath3 != null) {
            imgList.add(book.photoPath3);
          }
          if (book.photoPath4 != null) {
            imgList.add(book.photoPath4);
          }
          setState(() {});
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

  Future<void> addComment() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/review/',
          json: {
            "book_id": book.bookId,
            "book_rating": rating,
            "review": comment
          });
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          Fluttertoast.showToast(
              msg: 'Comment submitted successfully',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          setState(() {
            isCommentPressed = false;
          });
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

  Future<void> sendRequest() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/request/send_request.php',
          json: {"book_id": book.bookId});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          Fluttertoast.showToast(
              msg: 'Request submitted successfully',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
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

  Future<void> fetchReviews() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/review/fetch_review.php',
          json: {"book_id": widget.book_id});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          reviewList.clear();
          for (int i = 0; i < userJson["no_records"]; i++) {
            reviewList.add(Review.fromJson(userJson['$i']));
          }
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
  void initState() {
    fetchMyBooks();
    fetchReviews();
  }

  List<T> mapping<T>(List list, Function handler) {
    List<T> result = [];
    for (int i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    ClipRRect _bookCover(String imgURL) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Image.network(
          imgURL,
          fit: BoxFit.fill,
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          title: Text(
            book?.title?.toUpperCase() ?? '',
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25.0,
                ),
                CarouselSlider(
                  height: 300.0,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index) {
                    setState(() {
                      _current = index;
                    });
                  },
                  items: imgList != null
                      ? imgList.map((imgURL) {
                          return Builder(
                            builder: (context) {
                              return _bookCover(imgURL);
                            },
                          );
                        }).toList()
                      : Container(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: mapping<Widget>(imgList, (index, url) {
                    return Container(
                      width: 7.0,
                      height: 7.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _current == index ? Colors.redAccent : Colors.grey,
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  book?.genre ?? '',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  book?.title ?? '',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 7.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'by ' + (book?.author ?? ''),
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text('|'),
                    SizedBox(
                      width: 15.0,
                    ),
                    SmoothStarRating(
                      starCount: 5,
                      onRatingChanged: (val) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewTab(
                                      book_id: widget.book_id,
                                      reviewList: reviewList,
                                    )));
                      },
                      size: 22.0,
                      spacing: 0.0,
                      rating: double.parse(book?.rating ?? '0'),
                      allowHalfRating: false,
                      color: Colors.amber,
                      borderColor: Colors.amber,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '₹ ' + (book?.price ?? ''),
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                // ===========================================================================
                _isOwner
                    ? RaisedButton(
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String noOfDays;
                              final codeFormKey = GlobalKey<FormState>();
                              void validateForm() {
                                if (codeFormKey.currentState.validate()) {
                                  codeFormKey.currentState.save();
                                  fetchBookCode(noOfDays);
                                  Navigator.pop(context);
                                }
                              }

                              return AlertDialog(
                                title: Text('Select no. of days'),
                                content: Form(
                                  key: codeFormKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: false, signed: false),
                                        validator: (value) {
                                          if (value.trim().isEmpty) {
                                            return 'No.of Days are required';
                                          }
                                          Pattern pattern = r'^[0-9]*$';
                                          RegExp regex = RegExp(pattern);
                                          if (!regex.hasMatch(value)) {
                                            return 'Only numbers are allowed';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) => noOfDays = value,
                                        decoration:
                                            kTextFieldDecoration.copyWith(
                                          labelText: 'No.of Days',
                                          hintText: 'Enter no.of days',
                                          prefixIcon:
                                              Icon(Icons.calendar_today),
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
                                        child: Text('Generate Key'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        shape: kRoundedBorder,
                        textColor: Colors.white,
                        color: Colors.redAccent,
                        child: Text('Generate Book Key'),
                      )
                    : RaisedButton(
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        onPressed: () {
                          sendRequest();
                        },
                        shape: kRoundedBorder,
                        textColor: Colors.white,
                        color: Colors.redAccent,
                        child: Text('Want to Read'),
                      ),
                !_isOwner
                    ? RaisedButton(
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String code;
                              final codeFormKey = GlobalKey<FormState>();
                              void validateForm() {
                                if (codeFormKey.currentState.validate()) {
                                  codeFormKey.currentState.save();
                                  verifyCode(code);
                                  Navigator.pop(context);
                                }
                              }

                              return AlertDialog(
                                title: Text('Enter verification key'),
                                content: Form(
                                  key: codeFormKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value.trim().isEmpty) {
                                            return 'Key is required';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) => code = value,
                                        decoration:
                                            kTextFieldDecoration.copyWith(
                                          labelText: 'Key',
                                          hintText: 'Enter key',
                                          prefixIcon: Icon(Icons.verified_user),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      RaisedButton(
                                        color: Colors.redAccent,
                                        textColor: Colors.white,
                                        onPressed:
                                            validateForm, //on pressed set isAvailable=0,
                                        shape: kRoundedBorder,
                                        child: Text('Verify Key'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        shape: kRoundedBorder,
                        textColor: Colors.white,
                        color: Colors.redAccent,
                        child: Text('Verify Exchange Key'),
                      )
                    : SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                // ==============================================================
                Text('tap on rating to see reviews',
                    style: TextStyle(
                      color: Colors.red,
                    )),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton.icon(
                  icon: Icon(Icons.comment),
                  label: Text('Add Comments'),
                  onPressed: () {
                    setState(() {
                      isCommentPressed = true;
                    });
                  },
                ),
                isCommentPressed
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            SmoothStarRating(
                              starCount: 5,
                              rating: rating,
                              onRatingChanged: (val) {
                                rating = val;
                                setState(() {});
                              },
                              size: 30.0,
                              spacing: 0.0,
                              allowHalfRating: false,
                              color: Colors.amber,
                              borderColor: Colors.amber,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextField(
                              keyboardType: TextInputType.text,
                              maxLines: 4,
                              decoration: kTextFieldDecoration.copyWith(
                                labelText: 'Comment',
                                hintText: 'Enter your valuable view here',
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
                              onChanged: (value) {
                                comment = value;
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            RaisedButton(
                              color: Colors.redAccent,
                              shape: kRoundedBorder,
                              textColor: Colors.white,
                              onPressed: () {
                                addComment();
                              },
                              child: Text('Submit'),
                            )
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 0.0,
                      ),
                Divider(
                  color: Colors.redAccent,
                  indent: 15.0,
                  endIndent: 15.0,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Book Description',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    book?.description ?? '',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: (book?.isbn != null && book?.isbn != "")
                          ? Text(
                              'ISBN: ' + book.isbn,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            )
                          : Container(
                              height: 0.0,
                            ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        'Language: ' + (book?.language ?? ''),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        'Publication: ' + (book?.publication ?? ''),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        'No.of Time Shared: ' + (book?.countShared ?? ''),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        'Edition: ' + (book?.edition ?? ''),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Book Owner:  ',
                        textAlign: TextAlign.start,
                      ),
                      CircleAvatar(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: dp != null ? Image.network(dp) : Container(),
                        ),
                        backgroundColor: Colors.white,
                        radius: 15.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        name != null ? name : '',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class ReviewTab extends StatelessWidget {
  String book_id;
  List<Review> reviewList;
  ReviewTab({this.book_id, this.reviewList});

  Widget _reviewCard(Review r) {
    List<String> dateTime = r.date.split(' ').toList();
    String date = dateTime[0];
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('images/user.png'),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  r.name,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              children: <Widget>[
                SmoothStarRating(
                  rating: double.parse(r.rating),
                  color: Colors.indigo,
                  borderColor: Colors.indigo,
                  spacing: 0.0,
                  allowHalfRating: true,
                  starCount: 5,
                  size: 18.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              r.review,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            Divider(
              indent: 1.0,
              thickness: 0.5,
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: reviewList.length,
          itemBuilder: (context, index) {
            return _reviewCard(reviewList[index]);
          },
        ),
      ),
    );
  }
}