import 'package:flutter/material.dart';

class ViewPointsScreen extends StatefulWidget {
  @override
  _ViewPointsScreenState createState() => _ViewPointsScreenState();
}

class _ViewPointsScreenState extends State<ViewPointsScreen> {
  final int point = 30;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('View Points'),
      ),
      body: Center(
        child: Text(
          'Your Points: $point',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
