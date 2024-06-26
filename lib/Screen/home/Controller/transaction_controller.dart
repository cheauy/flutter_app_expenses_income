import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Authentication/fire_service.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/language_service.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/cate_model.dart';
import 'package:flutter_app_expenses_income/Screen/home/Controller/transation_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionController extends GetxController {
  final FirestoreService firebaseService = FirestoreService();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController cateController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final formkey = GlobalKey<FormState>();

  List<Category> categories = [];
  List<String> categoryNames = [];
  List<TransactionModel> filteredTransactions  = [];
  List<DateTime?> _selectedDate = [null, null];
  Map<DateTime, List<TransactionModel>> transactions = {};
  Map<String, double> dailyTransactionSums = {};
  DateTime currentMonth = DateTime.now();
  DateTime startDate = DateTime.now().subtract(Duration(days: DateTime.now().day - 1));
  DateTime endDate = DateTime.now();


  var isRefreshing = false;
  int toggleIndex = -1;
  bool isDateRangeSelected = false;


  late DateTime selectedDate;
  late TextEditingController dateController;

  String? selectedCategory;
  String? selectedCurrency;

  final doc = DocumentReference;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    selectedDate = DateTime.now();
    dateController = TextEditingController(
        text: '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}');
    fetchCategories();


  }


  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  void updateState(bool state) {
    isRefreshing = state;
    update();
  }

  Future<void> handleRefresh() async {
    await fetchTransaction();
  }
  void toggleCategoryType(int index) {
    toggleIndex = index;
    fetchCategories();
    update();
  }

  Future<void> fetchCategories() async {
    List<Category> fetchedCategories = await firebaseService.fetchCategories();
    List<Category> mergedCategories = [
      ...defaultExpenseCategories,
      ...defaultIncomeCategories,
      ...fetchedCategories
    ];


    categoryNames = mergedCategories.map((category) => category.name).toList();

    update();


  }





  Future<void> fetchTransaction({bool isDateRange = true}) async {
    try {
      updateState(true);
      List<TransactionModel> fetch = await firebaseService.fetchTransaction();
      List<TransactionModel> filteredTransactions = fetch.where((transaction) {
        DateTime transactionDate = parseDate(transaction.date);
        if (isDateRange) {
          return transactionDate.isAfter(startDate.subtract(Duration(days: 1))) &&
              transactionDate.isBefore(endDate.add(Duration(days: 1)));
        } else {
          return transactionDate.year == currentMonth.year &&
              transactionDate.month == currentMonth.month;
        }
      }).toList();

      // Group transactions by date
      Map<DateTime, List<TransactionModel>> groupedTransactions = {};
      filteredTransactions.forEach((transaction) {
        DateTime date = parseDate(transaction.date);
        DateTime simpleDate = DateTime(date.year, date.month, date.day);
        if (groupedTransactions.containsKey(simpleDate)) {
          groupedTransactions[simpleDate]!.add(transaction);
        } else {
          groupedTransactions[simpleDate] = [transaction];
        }
      });
      // Sort dates in descending order
      List<DateTime> sortedDates = groupedTransactions.keys.toList();
      sortedDates.sort((a, b) => b.compareTo(a));  // Descending order

      // Sort transactions within each date group in descending order
      Map<DateTime, List<TransactionModel>> sortedGroupedTransactions = {};
      for (var date in sortedDates) {
        var transactionsList = groupedTransactions[date]!;
        transactionsList.sort((a, b) {
          DateTime dateA = parseDate(a.date);
          DateTime dateB = parseDate(b.date);
          return dateB.compareTo(dateA);  // Descending order
        });
        sortedGroupedTransactions[date] = transactionsList;
      }


      transactions.assignAll(sortedGroupedTransactions);


    } catch (e) {
      print('$e');
    }finally{
      updateState(false);
    }
  }

  DateTime parseDate(String dateStr) {
    List<String> parts = dateStr.split('-');

    // Ensure correct format with leading zeros for month and day
    String year = parts[0];
    String month = parts[1].padLeft(2, '0'); // Pad with leading zero if necessary
    String day = parts[2].padLeft(2, '0');   // Pad with leading zero if necessary

    String formattedDateStr = '$year-$month-$day';

    return DateTime.parse(formattedDateStr);
  }

  Future<void> dateRange(BuildContext context) async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
      ),
      dialogSize: const Size(325, 400),
      value: _selectedDate,
      borderRadius: BorderRadius.circular(15),
    );

    if (results != null && results.isNotEmpty) {
      startDate = results[0] ?? startDate;
      endDate = results[1] ?? endDate;
      isDateRangeSelected=true;
      fetchTransaction();
      update();
    }
  }

  String formatDateRange() {
    if (_selectedDate[0] == null && _selectedDate[1] == null) {
      return "";
    }
    final startDate = _selectedDate[0] != null
        ? "${_selectedDate[0]!.day}/${_selectedDate[0]!.month}/${_selectedDate[0]!.year}"
        : "";
    final endDate = _selectedDate[1] != null
        ? "${_selectedDate[1]!.day}/${_selectedDate[1]!.month}/${_selectedDate[1]!.year}"
        : "";
    if (startDate.isEmpty) return endDate;
    if (endDate.isEmpty) return startDate;
    return "$startDate - $endDate";
  }


  void previousMonth() {

    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    isDateRangeSelected=false;
    fetchTransaction(isDateRange: false);
      update();

  }

  void nextMonth() {

    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    isDateRangeSelected=false;
    fetchTransaction(isDateRange: false);
      update();

  }



  Future<void> datePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      // Refer to the selectedDate defined above
      firstDate: DateTime(2000),
      // Optional: Restrict date range
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Head color
              onPrimary: Colors.white, // Text color
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      }, // Optional: Restrict date range
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
      dateController.text =
          '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';

    }
  }

  void onCategoryChanged(String newValue) {
    selectedCategory = newValue;
    update();
  }

  void onCurrencyChanged(String newValue) {
    selectedCurrency = newValue;
    update();
  }
  double validateAndAdjustAmount() {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount == 0.0) {
      throw 'Invalid amount';
    }

    if (toggleIndex == 0) {
      amount = -amount; // Make amount negative for expenses
    }
    return amount;
  }
  Future<void> addTransaction() async {
    double amount = validateAndAdjustAmount();
    if (selectedCategory != null && selectedCurrency != null) {
      await firebaseService
          .addTransaction(
              amount: amount,
              currency: selectedCurrency!,
              category: selectedCategory!,
              date: dateController.text,
              text: textController.text)
          .then((_) {
        Get.back();
        toggleIndex = -1;
        amountController.clear();
        selectedCategory = null;
        selectedCurrency = null;
        textController.clear();
        // print('Transaction added with ID: $transactionId');
      }).catchError((error) {
        print('Error adding category: $error');
      });
    }
  }

  Future<void> updateTransaction(String id) async {
    try
    {
      double amount = validateAndAdjustAmount();
      await firebaseService.updateTransaction(
          id: id,
          amount: amount,
          currency: selectedCurrency!,
          category: selectedCategory!,
          date: dateController.text,
          text: textController.text);
    }catch(e){
      print('$e');
    }
  }

  void deleteTran(String id) async {
    await firebaseService.deleteTransaction(id);
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text('Transaction deleted successfully')),
    );
    update();
  }




  String? amountValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter amount';
    }
    return null;
  }

  String? categoryValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please choose category';
    }
    return null;
  }
  String? currencyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Select currency';
    }
    return null;
  }
}
