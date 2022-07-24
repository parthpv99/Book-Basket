import 'package:flutter/material.dart';
import '../model/book.dart';

class ViewBookListScreen extends StatefulWidget {
  @override
  _ViewBookListScreenState createState() => _ViewBookListScreenState();
}

class _ViewBookListScreenState extends State<ViewBookListScreen> {
  List<Book> bookList=[];

  Column _bookCover(String imgURL)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/viewBookScreen');
          },
          child: Container(
            height: 170,
            width: 135,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.network(
                'https://placeimg.com/640/480/any',
                fit: BoxFit.fill,
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            ),
          ),
        ),
        Container(
          width: 100,
          child: Text('Operating System',
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: OrientationBuilder(
          builder: (context,orientation){
            return GridView.count(
              childAspectRatio: (4/5),
                crossAxisCount: orientation == Orientation.portrait ? 2:3,
              children: List.generate(15, (index){
                  return _bookCover('assets/book1.jpg');
                }),
            );
          },
        ),
      ),
    );
  }
}