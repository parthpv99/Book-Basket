import 'package:book_sharing_system/screens/payment_gateway_screen.dart';
import 'package:flutter/material.dart';
import 'screens/add_book_screen.dart';
import 'screens/add_wishlist_screen.dart';
import 'screens/book_view_screen.dart';
import 'screens/edit_book_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/manage_screens.dart';
import 'screens/login_screen.dart';
import 'screens/my_library_screen.dart';
import 'screens/my_requests_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/redeem_book_screen.dart';
import 'screens/search_screen.dart';
import 'screens/see_all_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signup_screen.dart';
import 'package:flutter/services.dart';
import 'screens/transaction_screen.dart';
import 'screens/view_book_list_screen.dart';
import 'screens/view_points_screen.dart';
import 'screens/wishlist_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Sharing System',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signUpScreen': (context) => SignUpScreen(),
        '/manageScreen': (context) => ManageScreen(),
        '/forgotPasswordScreen': (context) => ForgotPasswordScreen(),
        '/homeScreen': (context) => HomeScreen(),
        '/wishlistScreen': (context) => WishlistScreen(),
        '/addWishlistScreen': (context) => AddWishlistScreen(),
        '/addBookScreen': (context) => AddBookScreen(),
        '/myLibraryScreen': (context) => MyLibraryScreen(),
        '/transactionScreen': (context) => TransactionScreen(),
        '/myRequestScreen': (context) => MyRequestScreen(),
        '/settingsScreen': (context) => SettingsScreen(),
        '/notificationScreen': (context) => NotificationScreen(),
        '/redeemBookScreen': (context) => RedeemBookScreen(),
        '/viewPointsScreen': (context) => ViewPointsScreen(),
        '/viewBookListScreen': (context) => ViewBookListScreen(),
        '/searchScreen': (context) => SearchScreen(),
        '/editBookScreen': (context) => EditBook(),
        '/bookViewScreen': (context) => BookViewScreen(),
        '/editProfileScreen': (context) => EditProfileScreen(),
        '/seeAllScreen': (context) => SeeAllScreen(),
        '/paymentGatewayScreen': (context) => PaymentGatewayScreen(),
      },
      theme: Theme.of(context).copyWith(
        primaryColor: Colors.redAccent,
        accentColor: Colors.white,
      ),
    );
  }
}