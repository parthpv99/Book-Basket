import '../model/book.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import 'book_view_screen.dart';

class MyLibraryScreen extends StatefulWidget {
  @override
  _MyLibraryScreenState createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  List<Book> bookList = [];
  
  Future<void> fetchMyBooks() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/my_library/');
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          bookList.clear();
          int count = userJson["count"];
          for(int i = 0; i < count; i++) {
            bookList.add(Book.fromJson(userJson['$i']));
          }
          setState(() {
            
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
    fetchMyBooks();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
