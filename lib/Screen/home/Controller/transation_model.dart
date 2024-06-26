

import 'package:intl/intl.dart';

class TransactionModel {
  final String id;
  final double amount;
  final String currency;
  final String category;
  final String date;
  final String? text;
  final DateTime transactionDate;
   String label="";

  TransactionModel( {
    required this.id,
    required this.amount,
    required this.currency,
    required this.category,
    required this.date,
    this.text,
    required this.transactionDate,
    this.label = '',
  });

  // Convert Category object to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'amount': amount,
      'currency':currency,
      'category': category,
      'date': date,
      'text': text,
      'transactionDate': DateFormat('yyyy-MM-dd').format(transactionDate),

    };
  }
  factory TransactionModel.fromFirestore(Map<String, dynamic> map,String id) {
    return TransactionModel(
      id: id,
      amount: map['amount'] ?? "",
      currency: map['currency'] ?? "",
      category: map['category'] ?? "",
      date: map['date'] ?? "",
      text: map['text'] ?? "",
      transactionDate: DateFormat('yyyy-MM-dd').parse(map['date'] ?? ''),
      label: '',
    );
  }
  }
  List<String> item=['USD','KHR'];