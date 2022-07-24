import '../constants.dart';
import '../model/book.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'book_view_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> latestBookList = [];
  List<Book> nearByBookList = [];
  List<Book> recommendedList = [];
  List<String> genreList = [
    'Latest Arrivals',
    'Nearby Books',
    'Books You May Like'
  ];

  Future<void> fetchLatestBooks() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/fetch_books_by_latest/',
          json: {"no_of_books": 10});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          latestBookList.clear();
          for (int i = 0; i < userJson["no_records"]; i++) {
            latestBookList.add(Book.fromJson(userJson['$i']));
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
            "no_of_books": 10
          });
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          nearByBookList.clear();
          for (int i = 0; i < userJson["no_records"]; i++) {
            nearByBookList.add(Book.fromJson(userJson['$i']));
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
    final sharedPreference = await SharedPreferences.getInstance();
    String genre = sharedPreference.getString("genre");

    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/fetch_books_by_genre/',
          json: {
            "genre": genre != null ? genre : "Thriller",
            "no_of_books": 10
          });
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          recommendedList.clear();
          for (int i = 0; i < userJson["no_records"]; i++) {
            recommendedList.add(Book.fromJson(userJson['$i']));
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

  @override
  void initState() {
    fetchLatestBooks();
    fetchNearByBooks();
    fetchRecommendedBooks();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: genreList.length,
      itemBuilder: (context, index) => Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    genreList[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  )),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookViewScreen()));
                    },
                    child: Text('See All'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                height: 300.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: latestBookList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookViewScreen(
                                          book_id: latestBookList[index].bookId,
                                        )));
                          },
                          child: Container(
                            height: 180,
                            width: 120,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                            child: Card(
                              shape: kRoundedBorder,
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.network(
                                latestBookList[index].photoPath1,
                                fit: BoxFit.fill,
                              ),
                              elevation: 5,
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Center(
                            child: Text(latestBookList[index].title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .subhead
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    )),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.fromLTRB(
          10.0,
          10.0,
          10.0,
          10.0,
        ),
      ),
      // Card(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       Padding(
      //         padding: const EdgeInsets.all(20.0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: <Widget>[
      //             Expanded(
      //                 child: Text(
      //               'NearBy Books',
      //               style: TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 fontSize: 20.0,
      //               ),
      //             )),
      //             InkWell(
      //               onTap: () {
      //                 Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => BookViewScreen()));
      //               },
      //               child: Text('See All'),
      //             ),
      //           ],
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8),
      //         child: Container(
      //           height: 300.0,
      //           child: ListView.builder(
      //             shrinkWrap: true,
      //             scrollDirection: Axis.horizontal,
      //             itemCount: nearByBookList.length,
      //             itemBuilder: (context, index) {
      //               return Column(
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 children: <Widget>[
      //                   InkWell(
      //                     onTap: () {
      //                       Navigator.push(
      //                           context,
      //                           MaterialPageRoute(
      //                               builder: (context) => BookViewScreen(
      //                                     book_id:
      //                                         nearByBookList[index].bookId,
      //                                   )));
      //                     },
      //                     child: Container(
      //                       height: 180,
      //                       width: 120,
      //                       margin: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
      //                       child: Card(
      //                         shape: kRoundedBorder,
      //                         semanticContainer: true,
      //                         clipBehavior: Clip.antiAliasWithSaveLayer,
      //                         child: Image.network(
      //                           nearByBookList[index].photoPath1,
      //                           fit: BoxFit.fill,
      //                         ),
      //                         elevation: 5,
      //                       ),
      //                     ),
      //                   ),
      //                   Container(
      //                     width: 100,
      //                     child: Center(
      //                       child: Text(nearByBookList[index].title,
      //                           textAlign: TextAlign.center,
      //                           style: Theme.of(context)
      //                               .textTheme
      //                               .subhead
      //                               .copyWith(
      //                                 fontWeight: FontWeight.bold,
      //                               )),
      //                     ),
      //                   ),
      //                 ],
      //               );
      //             },
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      //   shape:
      //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      //   margin: EdgeInsets.fromLTRB(
      //     10.0,
      //     10.0,
      //     10.0,
      //     10.0,
      //   ),
      // ),
      // Card(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       Padding(
      //         padding: const EdgeInsets.all(20.0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: <Widget>[
      //             Expanded(
      //                 child: Text(
      //               'Books You May Like',
      //               style: TextStyle(
      //                 fontWeight: FontWeight.bold,
      //                 fontSize: 20.0,
      //               ),
      //             )),
      //             InkWell(
      //               onTap: () {
      //                 Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => BookViewScreen()));
      //               },
      //               child: Text('See All'),
      //             ),
      //           ],
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8),
      //         child: Container(
      //           height: 300.0,
      //           child: ListView.builder(
      //             shrinkWrap: true,
      //             scrollDirection: Axis.horizontal,
      //             itemCount: recommendedList.length,
      //             itemBuilder: (context, index) {
      //               return Column(
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 children: <Widget>[
      //                   InkWell(
      //                     onTap: () {
      //                       Navigator.push(
      //                           context,
      //                           MaterialPageRoute(
      //                               builder: (context) => BookViewScreen(
      //                                     book_id:
      //                                         recommendedList[index].bookId,
      //                                   )));
      //                     },
      //                     child: Container(
      //                       height: 180,
      //                       width: 120,
      //                       margin: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
      //                       child: Card(
      //                         shape: kRoundedBorder,
      //                         semanticContainer: true,
      //                         clipBehavior: Clip.antiAliasWithSaveLayer,
      //                         child: Image.network(
      //                           recommendedList[index].photoPath1,
      //                           fit: BoxFit.fill,
      //                         ),
      //                         elevation: 5,
      //                       ),
      //                     ),
      //                   ),
      //                   Container(
      //                     width: 100,
      //                     child: Center(
      //                       child: Text(recommendedList[index].title,
      //                           textAlign: TextAlign.center,
      //                           style: Theme.of(context)
      //                               .textTheme
      //                               .subhead
      //                               .copyWith(
      //                                 fontWeight: FontWeight.bold,
      //                               )),
      //                     ),
      //                   ),
      //                 ],
      //               );
      //             },
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      //   shape:
      //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      //   margin: EdgeInsets.fromLTRB(
      //     10.0,
      //     10.0,
      //     10.0,
      //     10.0,
      //   ),
      // ),
    );
  }
}
