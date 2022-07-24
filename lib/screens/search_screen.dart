import '../model/book.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';

import 'book_view_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Book> searchList = [];

  void searchBooks(String title) async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/searching/',
          json: {"book_title": title});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          searchList.clear();
          int count = userJson["no_records"];
          for (int i = 0; i < count; i++) {
            searchList.add(Book.fromJson(userJson['$i']));
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

  InkWell _bookCover(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookViewScreen(
              book_id: searchList[index].bookId,
            ),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Container(
            height: 170,
            width: 135,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.network(
                searchList[index].photoPath1,
                fit: BoxFit.fill,
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
            ),
          ),
          Wrap(children: <Widget>[
            Text(searchList[index].title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(fontWeight: FontWeight.bold)),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new TextField(
          style: new TextStyle(
            color: Colors.white,
          ),
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, color: Colors.white),
              hintText: "Search",
              hintStyle: new TextStyle(color: Colors.white)),
          onSubmitted: searchBooks,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.count(
              childAspectRatio: (4 / 5),
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              children: List.generate(searchList.length, (index) {
                return _bookCover(index);
              }),
            );
          },
        ),
      ),
    );
  }
}