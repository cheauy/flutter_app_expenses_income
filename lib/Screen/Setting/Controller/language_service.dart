import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';

class LangService extends Translations {
  @override

  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'setting': "Setting",
          'transactions': "Transactions",
          //Bottom bar
          'home': 'Home',
          'state': 'State',
          'settings': 'Settings',
          //Setting Screen
          'viewyourprofile': "View your profile",
          'category': "Category",
          'categorysubtitle': "View your categories",
          'language': 'Language',
          'theme': 'Theme',
          'darksubtitle': 'Dark',
          'light': 'Light',
          'export': 'Export Data',
          'expoersubtitle': 'Export data to excel',
          'signout': 'Sign Out',
          'chooselanuage': 'Please select a langauge',
          //Search
          'Search':"Search",
          //Category Screen
          "Taxes": "Taxes",
          "Travel": "Travel",
          "Business Expenses": "Business Expenses",
          "Gifts and Donations": "Gifts and Donations",
          "Utilities": "Utilities",
          "Transportation": "Transportation",
          "Childcare and Education": "Childcare and Education",
          "Personal Care": "Personal Care",
          "Miscellaneous": "Miscellaneous",
          "Salary": "Salary",
          "Investments": "Investments",
          "Sale": "Sale",
          //profile screen
          'name': 'Name',
          'email': 'Email',
          'phoneNumber': 'Phone Number',
          'profile': 'Profile',
          'delete account':'Delete Account',
          'No transactions available':'No transactions available',
          //add transaction
          "expense": "Expenses",
          "income": "Income",
          "amount": "amount",
          "balance": "Balance",
          "data empty":"Data Empty",
          "choose category": "Please select category",
          "date": "Date of the expenses",
          "additional notes": "Any additional notes or descriptions",
          "currency":"Currency",
          "add transaction":"Add Transaction",
  "edit transaction": "Edit Transcation",
          "update transaction":"Update Transaction",
          //state screen
          'today': 'Today',
          'this week': 'This Week',
          'this month': 'This Month',
          'this year': 'This Year',
          //delete alert
          'alert message': 'Are you sure want to Delete ?',
          'yes': 'Yes',
          'no': 'No',
          //Category type
          'Income': 'Income',
          'Expenses': 'Expenses',
          'Saving': 'Saving',
          'Loan': 'Loan',
          'Debt': 'Debt',
          'Investment': 'Investment',
          'Others': 'Others',


        },
        'km_KH': {
          'setting': "ការកំណត់",
          'transactions': "ប្រតិបត្តិការ",
          //Bottom bar
          'home': 'ទំព័រដើម',
          'state': 'របាយការណ៏',
          'settings': 'ការកំណត់',
          //Setting Screen
          'viewyourprofile': "មើលប្រវត្តិរូបរបស់អ្នក",
          'category': "ប្រភេទ",
          'categorysubtitle': "មើលប្រភេទរបស់អ្នក",
          'language': 'ភាសា',
          'theme': 'រចនាប័ទ្ម',
          'darksubtitle': 'ងងិត',
          'light': 'ស្រស់',
          'export': 'ទាញទិន្នន័យ',
          'expoersubtitle': 'ទាញទិន្នន័យទៅក្នុង Excel',
          'signout': 'ចាកចេញ',
          'chooselanuage': 'សូមជ្រើសរើសភាសា',
          //Category Screen
          "Taxes": "ពន្ធ",
          "Travel": "ការធ្វើដំណើរ",
          "Business Expenses": "ការចំណាយអាជីវកម្ម",
          "Gifts and Donations": "អំណោយ និង ការបរិច្ចាគ",
          "Utilities": "សេវាកម្ម",
          "Transportation": "ការដឹកជញ្ជូន",
          "Childcare and Education": "ការថែទាំកុមារ និង ការអប់រំ",
          "Personal Care": "ការថែទាំផ្ទាល់ខ្លួន",
          "Miscellaneous": "ផ្សេងៗ",
          "Salary": "ប្រាក់ខែ",
          "Investments": "ការវិនិយោគ",
          "Sale": "ការលក់",
          'Search':'ស្វែងរក',
          //profile screen
          'name': 'ឈ្មោះ',
          'email': 'អ៊ីម៉ែល',
          'phoneNumber': 'លេខទូរស័ព្ទ',
          'profile': 'ប្រវត្តិរូប',
          'delete account':'លុប គណនី',
           'No transactions available':'គ្នានប្រតិបត្តិការ',
          //add screen
          "expense": "ចំណាយ",
          "income": "ចំណូល",
          "amount": "ចំនួនទឹកប្រាក់",
          "data empty":"គ្នានទិន្នន័យ",
          "choose category": "ជ្រើសប្រភេទ",
          "date": "កាលបរិច្ឆេទ",
          "additional notes": "កំណត់ចំណាំបន្ថែម",
          "currency": "រូបិយប័ណ្ណ",
          "balance": "សមតុល្យ",
          "add transaction":"បន្ថែមប្រតិបត្តិការណ៍",
          "states": "ស្ថានភាព",
"edit transaction": "កែប្រែប្រតិបត្តិការណ៍",
          "update transaction":"អាប់ដេតប្រតិបត្តិការណ៍",
          //state screen
          'today': 'ថ្ងៃនេះ',
          'this week': 'សប្តាហ៍នេះ',
          'this month': 'ខែនេះ',
          'this year': 'ឆ្នាំនេះ',
          //delete alert
          'alert message': 'តើអ្នកប្រាកដជាចង់លុបមែនទេ ?',
          'yes': 'បាទ/ចាស',
          'no': 'ទេ',
          //category type
          'Income': 'ចំណូល',
          'Expenses': 'ចំណាយ',
          'Saving': 'សន្សំ',
          'Loan': 'ប្រាក់កម្ចី',
          'Debt': 'បំណុល',
          'Investment': 'ការវិនិយោគ',
          'Others': 'ផ្សេងៗ',


        }
      };

}
