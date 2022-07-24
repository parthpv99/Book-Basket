import '../model/book.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';

import 'book_view_screen.dart';

class SeeAllScreen extends StatefulWidget {
  String title;
  int type;
  SeeAllScreen({this.title, this.type});

  @override
  _SeeAllScreenState createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  
  List<Book> bookList = [];

  Future<void> fetchLatestBooks() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/fetch_books_by_latest/',
          json: {"no_of_books": 100});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          bookList.clear();
          for (int i = 0; i < userJson["no_records"]; i++) {
            bookList.add(Book.fromJson(userJson['$i']));
          }
          setState(() {});
        } else {
          Fluttertoast.showToast(
              msg: userJson["message"],
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pop(context);
        }
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: 'Error. Please try again later',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
    }
  }

  Future<void> fetchNearByBooks() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/fetch_books_by_area/',
          json: {
            "area": (await User.fromSharedPreference).area,
            "no_of_books": 100
          });
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          bookList.clear();
          for (int i = 0; i < userJson["no_records"]; i++) {
            bookList.add(Book.fromJson(userJson['$i']));
          }
          setState(() {});
        } else {
          Fluttertoast.showToast(
              msg: userJson["message"],
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pop(context);
        }
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: 'Error. Please try again later',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
    }
  }

  Future<void> fetchRecommendedBooks() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/fetch_books_by_genre/',
          json: {
            "genre": "Thriller",
            "no_of_books": 10
          });
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          bookList.clear();
          for (int i = 0; i < userJson["no_records"]; i++) {
            bookList.add(Book.fromJson(userJson['$i']));
          }
          setState(() {});
        } else {
          Fluttertoast.showToast(
              msg: userJson["message"],
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pop(context);
        }
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: 'Error. Please try again later',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
    }
  }

  Column _bookCover(int index)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BookViewScreen(book_id: bookList[index].bookId,)));
          },
          child: Container(
            height: 170,
            width: 135,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.network(
                bookList[index].photoPath1,
                fit: BoxFit.fill,
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            ),
          ),
        ),
        Container(
          width: 100,
          child: Text(bookList[index].title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  @override
  void initState() {
    if(widget.type == 1) {
      fetchLatestBooks();
    } else if(widget.type == 2) {
      fetchNearByBooks();
    } else if(widget.type == 3) {
      fetchRecommendedBooks();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.count(
              childAspectRatio: (4 / 5),
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              children: List.generate(bookList.length, (index) {
                return _bookCover(index);
              }),
            );
          },
        ),
      ),
    );
  }
}
