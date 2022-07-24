import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';

class MyRequestScreen extends StatefulWidget {
  @override
  _MyRequestScreenState createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  List<String> transactionIdList = [];
  List<String> bookIdList = [];
  List<String> bookNameList = [];
  List<String> borrowerIdList = [];
  List<String> borrowerNameList = [];
  List<String> borrowerImageList = [];
  List<String> titleList = [
    "Parth Pansuriya Photography",
    "Title 2",
    "Title 3"
  ];
  List<String> requesterList = ["Requester 1", "Requester 2", "Requester 3"];

  Future<void> fetchRequest() async {
    try {
      var response = await Requests.post(
        'http://52.236.33.218/booksharingsystem/request/display_request.php',
      );
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          transactionIdList.clear();
          bookIdList.clear();
          bookNameList.clear();
          borrowerIdList.clear();
          borrowerNameList.clear();
          borrowerImageList.clear();
          for (int i = 0; i < userJson["count"]; i++) {
            transactionIdList.insert(0, userJson['$i']['id']);
            bookIdList.insert(0, userJson['$i']['book_id']);
            bookNameList.insert(0, userJson['$i']['book_title']);
            borrowerIdList.insert(0, userJson['$i']['borrower_id']);
            borrowerNameList.insert(0, userJson['$i']['borrower_name']);
            borrowerImageList.insert(0, userJson['$i']['display_picture']);
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

  Future<void> acceptRequest(int index) async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/request/accept_request.php',
          json: {"id": transactionIdList[index]});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          transactionIdList.removeAt(index);
          bookIdList.removeAt(index);
          bookNameList.removeAt(index);
          borrowerIdList.removeAt(index);
          borrowerNameList.removeAt(index);
          borrowerImageList.removeAt(index);
          setState(() {});
        }
        Fluttertoast.showToast(
            msg: userJson["message"],
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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

  Future<void> deleteRequest(int index) async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/request/delete_request.php',
          json: {"id": transactionIdList[index]});
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          transactionIdList.removeAt(index);
          bookIdList.removeAt(index);
          bookNameList.removeAt(index);
          borrowerIdList.removeAt(index);
          borrowerNameList.removeAt(index);
          borrowerImageList.removeAt(index);
          setState(() {});
        }
        Fluttertoast.showToast(
            msg: userJson["message"],
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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
    fetchRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: transactionIdList.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                color: Color(0xFFF9EFF3),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Image.network(borrowerImageList[index]),
                    ),
                    radius: 25.0,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      bookNameList[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                    child: Text(
                      borrowerNameList[index],
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                  trailing: SizedBox(
                    width: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            acceptRequest(index);
                          },
                          icon: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteRequest(index);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
