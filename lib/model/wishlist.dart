class Wishlist
{
  String _id, _title, _author;

  Wishlist.fromJson(Map<String, dynamic> json)
  {
    _id = json["id"];
    _title = json["book_title"];
    _author = json["book_author"];
  }

  String get id => _id;
  String get title => _title;
  String get author => _author;
}