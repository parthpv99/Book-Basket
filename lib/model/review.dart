class Review {
  String name,bookId,review,date,rating,dp;

  Review.fromJson(Map<String, dynamic> json) {
    bookId = json["book_id"];
    name = json["first_name"];
    review = json["review"];
    date = json["review_date"];
    rating = json["book_rating"];
    dp = json["display_picture"];
  }
}