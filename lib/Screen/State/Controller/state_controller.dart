import 'package:flutter_app_expenses_income/Authentication/fire_service.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/cate_model.dart';
import 'package:flutter_app_expenses_income/Screen/home/Controller/transation_model.dart';
import 'package:get/get.dart';

class StateController extends GetxController {
  final FirestoreService firebaseService = FirestoreService();
  List<TransactionModel> transaction = [];
  Map<String, double> categoryTotal={};
  bool isRefreshing = false;
  bool isDateRangeSelected = false;
  String selectedDateRange = 'this week';
  var dataMap = <String, double>{};
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double totalBalance=0.0;
  DateTime? customStartDate;
  DateTime? customEndDate;



  void updateState(bool state) {
    isRefreshing = state;
    update();
  }
  Future<void> onRefresh() async {
    await fetchTransaction(selectedDateRange);
  }

  Future<void> fetchTransaction(String selectedDateRange) async {
    try{
      updateState(true);
      List<TransactionModel> fetchtransaction = await firebaseService.fetchTransaction();
      transaction=filterTransactionsByDate(fetchtransaction, selectedDateRange);
      calculateCategoryTotal(transaction);
      totalIncome = sumIncome(transaction);
      totalExpense=sumExpenses(transaction);
      totalBalance=sumTotal(transaction);

    }catch(e){
      print('$e');
    }finally{
      updateState(false);
    }

  }
  List<TransactionModel> filterTransactionsByDate(List<TransactionModel> transactions, String selectedDateRange) {

    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;
    updateState(true);
    switch (selectedDateRange) {
      case 'today':
        startDate = DateTime(now.year, now.month, now.day);
        endDate = startDate.add(Duration(days: 1)).subtract(Duration(seconds: 1));
        break;
      case 'this week':
        startDate = now.subtract(Duration(days: 6));
        break;
      case 'this month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 1).subtract(Duration(seconds: 1));
        break;
      case 'this year':
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year + 1, 1, 1).subtract(Duration(seconds: 1));
        break;
      case 'Custom':
        startDate = customStartDate ?? now;
        endDate = customEndDate ?? now;
        break;
      default:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = startDate.add(Duration(days: 7)).subtract(Duration(seconds: 1));
        break;
    }

    // Filter transactions by date range
    List<TransactionModel> filteredTransactions = transactions.where((transaction) {
      DateTime transactionDate = parseDate(transaction.date);
      return transactionDate.isAfter(startDate.subtract(Duration(days: 1))) &&
          transactionDate.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
    updateState(false);
    return filteredTransactions;

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

  void calculateCategoryTotal(List<TransactionModel> transactions) {
    Map<String, double> totalAmount = {};
    for (var transaction in transactions) {
      double amountToAdd = transaction.amount;
      if (totalAmount.containsKey(transaction.category)) {
        totalAmount[transaction.category] = totalAmount[transaction.category]! + amountToAdd;
      } else {
        totalAmount[transaction.category] = amountToAdd;
      }
    }

    categoryTotal.assignAll(totalAmount);
    // Checking if any value in dataMap is negative and converting it to positive
    totalAmount.forEach((key, value) {
      if (value < 0) {
        totalAmount[key] = value.abs();
      }
    });

    // Assigning totalAmount to dataMap
    dataMap.assignAll(totalAmount);
  }
  double sumIncome(List<TransactionModel> transactions) {
    double total = 0.0;
    for (TransactionModel transaction in transaction) {
      if(transaction.amount>0){
        total += transaction.amount;
      }


    }
    update();
    return total;
  }
  double sumExpenses(List<TransactionModel> transactions) {
    double total = 0.0;
    for (TransactionModel transaction in transaction) {
      if(transaction.amount<1){
        total += transaction.amount;

      }


    }
    return total;
  }
  double sumBalance(List<TransactionModel> transactions) {
    double total = 0.0;
    for (TransactionModel transaction in transaction) {
        total += transaction.amount;

    }
    return total;
  }
  double sumTotal(List<TransactionModel> transactions) {
    double totalExpenses = sumExpenses(transactions);
    double totalIncome = sumIncome(transactions);
    return totalExpenses + totalIncome;

  }

}

