import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import '../model/user.dart';
import '../validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:requests/requests.dart';
import '../constants.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  List<String> areaList = [];
  List<String> genreList = [];
  List<bool> genreTick = [];

  final addBookFormKey = GlobalKey<FormState>();
  bool addBookFormAutoValidation = false;
  int _count = 0, i = 0, genreCount = 0;
  String email,
      title,
      author,
      publication,
      edition,
      language,
      description,
      isbn,
      address,
      area,
      city = "Rajkot",
      price,
      noOfdays,
      path1,
      path2,
      path3,
      path4,
      pathname1,
      pathname2,
      pathname3,
      pathname4,
      genre = "";

  List<File> _imageFile = [];

  void validateForm() {
    if (addBookFormKey.currentState.validate()) {
      addBookFormKey.currentState.save();
      addBook();
    } else {
      setState(() {
        addBookFormAutoValidation = true;
      });
    }
  }

  void addBook() async {
    try {
      var response = await Requests.post(
        'http://52.236.33.218/booksharingsystem/add_books/',
        json: {
          "owner_id": (await User.fromSharedPreference).email,
          "book_title": title,
          "author_name": author,
          "publication_name": publication,
          "edition": edition,
          "book_language": language,
          "book_description": description,
          "isbn": isbn,
          "address": address,
          "area": area,
          "city": city,
          "price": price,
          "no_of_day": noOfdays,
          "photo_path1": path1,
          "photo_name1": pathname1,
          "photo_path2": path2,
          "photo_name2": pathname2,
          "photo_path3": path3,
          "photo_name3": pathname3,
          "photo_path4": path4,
          "photo_name4": pathname4,
          "genre": genre,
        },
      );
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var bookJson = response.json();

        if (!bookJson["is_error"]) {
          Fluttertoast.showToast(
              msg: 'Book added successfully',
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

  Future<List<int>> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 240,
      minHeight: 300,
      quality: 80,
      rotate: 0,
    );
    return result;
  }

  void imageToBase64(File image, int i) async {
    if (i == 0) {
      path1 = base64Encode(Uint8List.fromList(await testCompressFile(image)));
      pathname1 = '1.jpg';
    } else if (i == 1) {
      path2 = base64Encode(Uint8List.fromList(await testCompressFile(image)));
      pathname2 = '2.jpg';
    } else if (i == 2) {
      path3 = base64Encode(Uint8List.fromList(await testCompressFile(image)));
      pathname3 = '3.jpg';
    } else if (i == 3) {
      path4 = base64Encode(Uint8List.fromList(await testCompressFile(image)));
      pathname4 = '4.jpg';
    }
  }

  void _getImage(ImageSource source) {
    ImagePicker.pickImage(
      source: source,
      maxWidth: 400.0,
    ).then((File image) {
      if(image != null) {
        setState(() {
        imageToBase64(image, i++);
        _imageFile.add(image);
        _count++;
      });
      }
    });
  }

  void fetchAreas() async {
    try {
      var response = await Requests.post(
        'http://52.236.33.218/booksharingsystem/user_area/',
      );
      response.raiseForStatus();

      if (response.statusCode == 200) {
        var areaJson = response.json();

        if (areaJson['count'] > 0) {
          int count = areaJson['count'];
          for (int i = 0; i < count; i++) {
            areaList.add(areaJson['area$i']);
          }

          setState(() {});
        } else {
          Fluttertoast.showToast(
              msg: 'Unable to fetch data. Please try again later',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          Navigator.pushReplacementNamed(context, '/myLibraryScreen');
        }
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: 'Unable to fetch data. Please try again later',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pushReplacementNamed(context, '/myLibraryScreen');
    }
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

          Navigator.pushReplacementNamed(context, '/myLibraryScreen');
        }
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: 'Unable to fetch data. Please try again later',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pushReplacementNamed(context, '/myLibraryScreen');
    }
  }

  void _showModal() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setCheckboxState) {
            return Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: Wrap(
                children: <Widget>[
                  SizedBox(
                    height: 350.0,
                    child: ListView.builder(
                        itemCount: genreList.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: <Widget>[
                              Checkbox(
                                value: genreTick[index],
                                onChanged: (value) {
                                  setCheckboxState(() {
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
                  Center(
                    child: RaisedButton(
                      child: Text('SUBMIT GENRES'),
                      onPressed: popModal,
                      color: Colors.redAccent,
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  void popModal() {
    for (i = 0; i < genreCount; i++) {
      if (genreTick[i]) {
        genre += "${genreList[i]},";
      }
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    fetchAreas();
    fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Enter Book Details'),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: addBookFormKey,
              autovalidate: addBookFormAutoValidation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: validateTitle,
                          onSaved: (value) => title = value,
                          decoration: kTextFieldDecoration.copyWith(
                            labelText: 'Title',
                            hintText: 'Enter title',
                            prefixIcon: Icon(Icons.book),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: validateAuthor,
                          onSaved: (value) => author = value,
                          decoration: kTextFieldDecoration.copyWith(
                            labelText: 'Author',
                            hintText: 'Enter author name',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: validatePublication,
                          onSaved: (value) => publication = value,
                          decoration: kTextFieldDecoration.copyWith(
                            labelText: 'Publication',
                            hintText: 'Enter publication',
                            prefixIcon: Icon(Icons.public),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          validator: validateEdition,
                          onSaved: (value) => edition = value,
                          decoration: kTextFieldDecoration.copyWith(
                            labelText: 'Edition',
                            hintText: 'Enter edition',
                            prefixIcon: Icon(Icons.format_list_numbered),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: validateLanguage,
                          onSaved: (value) => language = value,
                          decoration: kTextFieldDecoration.copyWith(
                            labelText: 'Language',
                            hintText: 'Enter language',
                            prefixIcon: Icon(Icons.language),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: validateDescription,
                          onSaved: (value) => description = value,
                          decoration: kTextFieldDecoration.copyWith(
                            labelText: 'Description',
                            hintText: 'Enter description',
                            prefixIcon: Icon(Icons.short_text),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: validateISBN,
                          onSaved: (value) => isbn = value,
                          maxLength: 13,
                          decoration: kTextFieldDecoration.copyWith(
                            labelText: 'ISBN',
                            hintText: 'Enter ISBN',
                            prefixIcon: Icon(Icons.info_outline),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          maxLines: 4,
                          validator: validateAddress,
                          onSaved: (value) => address = value,
                          decoration: kTextFieldDecoration.copyWith(
                            labelText: 'Address',
                            hintText: 'Enter your address',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.redAccent, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.redAccent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        DropdownButtonFormField<String>(
                          value: area,
                          validator: validateArea,
                          onSaved: (value) => area = value,
                          isExpanded: true,
                          hint: Text('Select area'),
                          items: areaList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              area = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          enabled: false,
                          validator: validateCity,
                          onSaved: (value) => city = 'Rajkot',
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Rajkot',
                            prefixIcon: Icon(Icons.location_city),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          validator: validatePrice,
                          onSaved: (value) => price = value,
                          decoration: kTextFieldDecoration.copyWith(
                            labelText: 'Price',
                            hintText: 'Enter price',
                            prefixIcon: Icon(Icons.payment),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          validator: validateNoOfDays,
                          onSaved: (value) => noOfdays = value,
                          decoration: kTextFieldDecoration.copyWith(
                            labelText: 'No. of days',
                            hintText: 'Enter no. of days',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        OutlineButton(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                            width: 2.0,
                          ),
                          onPressed: _count < 4
                              ? () {
                                  _getImage(ImageSource.camera);
                                }
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                color:
                                    _count < 4 ? Colors.redAccent : Colors.grey,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Add Images',
                                style: TextStyle(
                                  color: _count < 4
                                      ? Colors.redAccent
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        _imageFile.length == 0
                            ? Text('Add atleast one Image')
                            : SizedBox(
                                height: 180.0,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _imageFile.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        _imageFile[index],
                                        fit: BoxFit.cover,
                                        height: 160.0,
                                        width: 100.0,
                                      ),
                                    );
                                  },
                                ),
                              ),
                        RaisedButton(
                          child: Text('GENRES'),
                          color: Colors.redAccent,
                          shape: kRoundedBorder,
                          textColor: Colors.white,
                          onPressed: _showModal,
                        ),
                        RaisedButton(
                          child: Text('ADD BOOK'),
                          color: Colors.redAccent,
                          shape: kRoundedBorder,
                          textColor: Colors.white,
                          onPressed: validateForm,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}