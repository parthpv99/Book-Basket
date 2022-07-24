class Book {
  String _bookId,
      _ownerId,
      _title,
      _author,
      _publication,
      _edition,
      _language,
      _description,
      _isbn,
      _address,
      _area,
      _city,
      _price,
      _noOfDay,
      _rating,
      _countShared,
      _photoPath1,
      _photoPath2,
      _photoPath3,
      _photoPath4,
      _genre,
      _isAvailable,
      _isApproved,
      _addedDate;

  Book.fromJson(Map<String, dynamic> json) {
    _bookId = json["book_id"];
    _ownerId = json["owner_id"];
    _title = json["book_title"];
    _author = json["author_name"];
    _publication = json["publication_name"];
    _edition = json["edition"];
    _language = json["book_language"];
    _description = json["book_description"];
    _isbn = json["isbn"];
    _address = json["address"];
    _area = json["area"];
    _city = json["city"];
    _price = json["price"];
    _noOfDay = json["no_of_day"];
    _rating = json["rating"];
    _countShared = json["count_shared"];
    _photoPath1 = json["photo_path1"];
    _photoPath2 = json["photo_path2"];
    _photoPath3 = json["photo_path3"];
    _photoPath4 = json["photo_path4"];
    _genre = json["genre"];
    _isAvailable = json["is_available"];
    _isApproved = json["is_approved"];
    _addedDate = json["added_date"];
  }

  String get bookId => _bookId;
  String get ownerId => _ownerId;
  String get title => _title;
  String get author => _author;
  String get publication => _publication;
  String get edition => _edition;
  String get language => _language;
  String get description => _description;
  String get isbn => _isbn;
  String get address => _address;
  String get area => _area;
  String get city => _city;
  String get price => _price;
  String get noOfDay => _noOfDay;
  String get rating => _rating;
  String get countShared => _countShared;
  String get photoPath1 => _photoPath1;
  String get photoPath2 => _photoPath2;
  String get photoPath3 => _photoPath3;
  String get photoPath4 => _photoPath4;
  String get genre => _genre;
  String get isAvailable => _isAvailable;
  String get isApproved => _isApproved;
  String get addedDate => _addedDate;
}
