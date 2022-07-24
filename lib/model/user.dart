import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class User
{
  String jsonString, id, email, firstName, lastName, mobileNo, address, area, city, points;

  User.fromJson(Map<String, dynamic> json)
  {
    jsonString = jsonEncode(json);
    id = json["user_id"];
    email = json["email_id"];
    firstName = json["first_name"];
    lastName = json["last_name"];
    mobileNo = json["mobile_num"];
    address = json["address"];
    area = json["area"];
    city = json["city"];
    points = json["points"];
  }

  static Future<User> get fromSharedPreference async
  {
    final sharedPreference = await SharedPreferences.getInstance();
    return User.fromJson(jsonDecode(sharedPreference.getString("user")));
  }
  
  void setPreference() async
  {
    final sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setString("user", jsonString);
  }
}