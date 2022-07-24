import '../components/profile_screen.dart';
import '../constants.dart';
import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<String> genreList = [];
  List<bool> genreTick = [];
  int genreCount = 0;
  String genre = "";

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  void addPreferredGenre() async {
    try {
      var response = await Requests.post(
        'http://52.236.33.218/booksharingsystem/add_preferred_genres/',
        json: {
          "genre": genre,
        },
      );
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var bookJson = response.json();

        if (!bookJson["is_error"]) {
          Fluttertoast.showToast(
              msg: 'Genres added successfully',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(
              msg: bookJson["message"],
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

  void popModal() async {
    for (int i = 0; i < genreList.length; i++) {
      if (genreTick[i]) {
        genre += "${genreList[i]},";
      }
    }
    final sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setString("genre", genre);
    // addPreferredGenre();
    Navigator.pop(context);
  }

  void fetchGenres() async {
    try {
      var response = await Requests.post(
        'http://52.236.33.218/booksharingsystem/book_genre/',
      );
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var genreJson = response.json();

        if (genreJson['count'] > 0) {
          genreCount = genreJson['count'];
          for (int i = 0; i < genreCount; i++) {
            genreList.add(genreJson['genre$i']);
            genreTick.add(false);
          }

          setState(() {});
        } else {
          Fluttertoast.showToast(
              msg: 'Unable to fetch data. Please try again later',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        }
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: 'Unable to fetch data. Please try again later',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Select Preferred Genre',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              flex: 8,
              child: SizedBox(
                child: ListView.builder(
                    itemCount: genreList.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: <Widget>[
                          Checkbox(
                            value: genreTick[index],
                            onChanged: (value) {
                              setState(() {
                                genreTick[index] = value;
                              });
                            },
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(genreList[index]),
                        ],
                      );
                    }),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Colors.redAccent,
                  shape: kRoundedBorder,
                  textColor: Colors.white,
                  child: Text('SUBMIT'),
                  onPressed: popModal,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
