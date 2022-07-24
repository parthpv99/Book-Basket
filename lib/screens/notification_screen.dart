import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<String> messageTypeList = [];
  List<String> notificationList = [];

  Future<void> fetchMyNotification() async {
    try {
      var response = await Requests.post(
          'http://52.236.33.218/booksharingsystem/fetch_notification/');
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var userJson = response.json();

        if (!userJson["is_error"]) {
          messageTypeList.clear();
          notificationList.clear();
          int count = userJson["no_records"];
          for(int i = 0; i < count; i++) {
            messageTypeList.insert(0, userJson['$i']["description"]);
            notificationList.insert(0, userJson['$i']["notification_type"]);
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

  @override
  void initState() {
    fetchMyNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
          itemCount: notificationList.length,
          itemBuilder: (context, index) {
            if (notificationList[index] == 'approvedbook') {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  color: Colors.green[100],
                  child: ListTile(
                    onTap: () {
                    },
                    title: Text(
                      messageTypeList[index],
                      style: TextStyle(fontSize: 18.0),
                    ),
                    leading: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                ),
              );
            }
            else if(notificationList[index] == 'rejectedbook') {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  color: Colors.red[100],
                  child: ListTile(
                    onTap: () {},
                    title: Text(
                      messageTypeList[index],
                      style: TextStyle(fontSize: 18.0),
                    ),
                    leading: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            }
            else if(notificationList[index] == 'rejectedrequest') {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  color: Colors.blue[100],
                  child: ListTile(
                    onTap: () {},
                    title: Text(
                      messageTypeList[index],
                      style: TextStyle(fontSize: 18.0),
                    ),
                    leading: Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              );
            }
            else if(notificationList[index] == 'acceptedrequest') {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  color: Colors.yellow[100],
                  child: ListTile(
                    onTap: () {},
                    title: Text(
                      messageTypeList[index],
                      style: TextStyle(fontSize: 18.0),
                    ),
                    leading: Icon(
                      Icons.alternate_email,
                      color: Colors.amber,
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}