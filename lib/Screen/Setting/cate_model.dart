import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final String? icon;
  final IconData? iconDefualt;
  final bool isCustom;

  Category({
     this.id,
    required this.name,
    this.namekh,
    this.icon,
    required this.type,
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

List<Category> defaultExpenseCategories = [
  Category(name: 'Taxes', type: 'Expenses',isCustom: false,iconDefualt: Icons.receipt ,),
  Category(name: 'Travel', type: 'Expenses',isCustom: false,iconDefualt:Icons.directions_car,),
  Category(name: 'Business Expenses', type: 'Expenses',isCustom: false,iconDefualt: Icons.business_center,),
  Category(name: 'Gifts and Donations', type: 'Expenses',isCustom: false,iconDefualt:CupertinoIcons.creditcard,),
  Category(name: 'Utilities', type: 'Expenses',isCustom: false,iconDefualt: Icons.lightbulb,),
  Category(name: 'Transportation', type: 'Expenses',isCustom: false,iconDefualt: Icons.directions_bus,),
  Category(name: 'Childcare and Education', type: 'Expenses',isCustom: false,iconDefualt: Icons.school,),
  Category(name: 'Personal Care', type: 'Expenses',isCustom: false,iconDefualt: Icons.person,),
  Category(name: 'Miscellaneous', type: 'Expenses',isCustom: false,iconDefualt: Icons.account_box,)
];


List<Category> defaultIncomeCategories=[
  Category(name: 'Salary', type: 'Income', isCustom: false,),
  Category(name: 'Investments', type: 'Income',isCustom: false,),
  Category(name: 'Sale', type: 'Income',isCustom: false,),
];