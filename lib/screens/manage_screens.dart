import '../screens/home_screen.dart';
import '../screens/my_library_screen.dart';
import '../screens/my_requests_screen.dart';
import '../screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import '../components/profile_screen.dart';
import 'transaction_screen.dart';

class ManageScreen extends StatefulWidget {
  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  int _selectedIndex = 0;
  final _pageList = [
    HomeScreen(),
    WishlistScreen(),
    MyLibraryScreen(),
    MyRequestScreen(),
    TransactionScreen(),
  ];

  final List<String> _appBarList = [
    'Home',
    'Wishlist',
    'My Library',
    'See Requests',
    'My Transactions',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _appBarList[_selectedIndex],
          ),
          leading: InkWell(
            child: Hero(
              tag: 'profile',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: new Border.all(
                      width: 2.0,
                      color: Colors.white,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/user.png'),
                    radius: 10.0,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/searchScreen');
              },
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/notificationScreen');
              },
              icon: Icon(Icons.notifications_active),
            ),
          ],
        ),
        backgroundColor: Colors.red[50],
        body: Center(
          child: _pageList.elementAt(_selectedIndex),
        ),
        floatingActionButton: (_selectedIndex == 1 || _selectedIndex == 2)
            ? FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.redAccent,
                onPressed: () {
                  if (_selectedIndex == 1) {
                    Navigator.pushNamed(context, '/addWishlistScreen')
                        .then((value) {
                      setState(() {});
                    });
                  } else if (_selectedIndex == 2) {
                    Navigator.pushNamed(context, '/addBookScreen');
                  }
                },
              )
            : null,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color(0xFFF9EFF3),
          ),
          child: BottomNavigationBar(
            backgroundColor: Color(0xFFF9EFF3),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
                title: Text('Wishlist'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_library),
                title: Text('My Library'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notification_important),
                title: Text('Requests'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                title: Text('Transactions'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.redAccent,
            unselectedItemColor: Colors.black,
            onTap: _onItemTapped,
          ),
        ));
  }
}
