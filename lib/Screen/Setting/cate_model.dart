import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/language_service.dart';
import 'package:get/get.dart';
class Filter {
  final Icon icon;
  final String title;

  Filter({required this.icon, required this.title});
}
List<Filter> filter = [
  Filter(icon: Icon(Icons.monetization_on), title: 'Income'),
  Filter(icon: Icon(Icons.money_off), title: 'Expenses'),
  Filter(icon: Icon(Icons.savings), title: 'Saving'),
  Filter(icon: Icon(Icons.credit_card), title: 'Loan'),
  Filter(icon: Icon(Icons.money), title: 'Debt'),
  Filter(icon: Icon(Icons.inventory_2_sharp), title: 'Investment'),
  Filter(icon: Icon(Icons.note), title: 'Others'),
];
class Category {
  final String? id;
  final String name;
  final String? namekh;
  final String type;
  final String icon;
  final IconData? iconDefualt;
  final bool isCustom;

  Category({
     this.id,
    required this.name,
    this.namekh,
    required this.type,
    required this.icon,
    this.iconDefualt,
    required this.isCustom,
  });

  // Convert Category object to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'name': name,
      'name_kh': namekh,
      'type': type,
      'icon': icon,

    };
  }
  factory Category.fromFirestore(Map<String, dynamic> map,String id) {
    return Category(
        id: id,
      name: map['name'],
      namekh: map['name_kh'] ?? "",
      type: map['type'] ?? "",
      icon: map['icon'] ?? "",
      isCustom: true

    );
  }

}
IconData getIconFromString(String iconString) {
  if (iconString.isEmpty)
    return Icons.error; // Handle empty or null iconString

  List<String> parts = iconString.split(',');
  if (parts.length != 2) return Icons.error; // Handle unexpected format

  int codePoint = int.tryParse(parts[0].trim()) ?? Icons.error.codePoint;
  String fontFamily = parts[1].trim();

  return IconData(
    codePoint,
    fontFamily: fontFamily,
    fontPackage: CupertinoIcons
        .iconFontPackage, // Specify the CupertinoIcons font package
  );
}
List<Category> defaultExpenseCategories = [
  Category(name: 'Taxes', type: 'Expenses',isCustom: false,iconDefualt: Icons.receipt ,icon: 'sad'),
  Category(name: 'Travel', type: 'Expenses',isCustom: false,iconDefualt:Icons.directions_car,icon: 'sad'),
  Category(name: 'Business Expenses', type: 'Expenses',isCustom: false,iconDefualt: Icons.business_center,icon: 'asd'),
  Category(name: 'Gifts and Donations', type: 'Expenses',isCustom: false,iconDefualt:CupertinoIcons.creditcard,icon: 'asd'),
  Category(name: 'Utilities', type: 'Expenses',isCustom: false,iconDefualt: Icons.lightbulb,icon: 'asd'),
  Category(name: 'Transportation', type: 'Expenses',isCustom: false,iconDefualt: Icons.directions_bus,icon: 'sad'),
  Category(name: 'Childcare and Education', type: 'Expenses',isCustom: false,iconDefualt: Icons.school,icon: 'asd'),
  Category(name: 'Personal Care', type: 'Expenses',isCustom: false,iconDefualt: Icons.person,icon: 'asd'),
  Category(name: 'Miscellaneous', type: 'Expenses',isCustom: false,iconDefualt: Icons.account_box,icon: 'asd')
];


List<Category> defaultIncomeCategories=[
  Category(name: 'Salary', type: 'Income', isCustom: false,iconDefualt: Icons.monetization_on,icon: 'asd'),
  Category(name: 'Investments', type: 'Income',isCustom: false,iconDefualt: Icons.show_chart,icon: 'asd'),
  Category(name: 'Sale', type: 'Income',isCustom: false,iconDefualt: Icons.point_of_sale,icon: 'asd'),
];