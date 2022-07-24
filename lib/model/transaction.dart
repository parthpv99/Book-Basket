import 'dart:convert';

class Transaction
{
  String trans_id, book_id, book_name, owner_id, owner_name, owner_dp, borrower_id, borrower_name, borrower_dp;

  Transaction.fromJson(Map<String, dynamic> json)
  {
    trans_id = json["trans_id"];
    book_id = json["book_id"];
    book_name = json["book_name"];
    owner_id = json["owner_id"];
    owner_name = json["owner_name"];
    owner_dp = json["owner_dp"];
    borrower_id = json["borrower_id"];
    borrower_name = json["borrower_name"];
    borrower_dp = json["borrower_dp"];
  }
}