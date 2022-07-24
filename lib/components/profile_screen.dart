import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userName = '';

  void getUser() async {
    User user = await User.fromSharedPreference;
    userName = user.firstName + " " + user.lastName;
    setState(() {
      
    });
  }

  @override
  void initState() {
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            Hero(
              tag: 'profile',
              child: Container(
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipRRect(borderRadius: BorderRadius.circular(50.0),child: Image.asset('assets/user.png'),),
                  radius: 50.0,
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Text(
              userName.toUpperCase(),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
            SizedBox(
              height: 15.0,
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/editProfileScreen');
              },
              leading: Icon(Icons.edit),
              title: Text(
                'Edit Profile',
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/settingsScreen');
              },
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/redeemBookScreen');
              },
              leading: Icon(Icons.redeem),
              title: Text(
                'Redeem Code',
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/viewPointsScreen');
              },
              leading: Icon(Icons.stars),
              title: Text(
                'View Points',
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            ListTile(
              onTap: () {
                Requests.clearStoredCookies(Requests.getHostname('http://52.236.33.218/booksharingsystem'));
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
