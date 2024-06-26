import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter_app_expenses_income/Authentication/fire_service.dart';
import 'package:flutter_app_expenses_income/Screen/home/Controller/transation_model.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportController extends GetxController {
  final FirestoreService firebaseService = FirestoreService();
  List<TransactionModel> transactions = [];
  List<TransactionModel> selectedTransactions = [];
  var isRefreshing = false;
  bool isAscending = false;
  var showCheckboxes = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchingTransaction();
  }

  void updateState(bool state) {
    isRefreshing = state;
    update();
  }

  void toggleSortOrder() {
    isAscending = !isAscending; // Toggle sort order
    sortTransactionsByDate(); // Re-sort transactions
  }

  Future<void> fetchingTransaction() async {
    try {
      updateState(true);
      List<TransactionModel> fetchedTransaction = await firebaseService
          .fetchTransaction();
      transactions = fetchedTransaction;
      sortTransactionsByDate();
    } catch (e) {
      print('$e');
    } finally {
      updateState(false);
    }
  }

  void sortTransactionsByDate() {
    transactions.sort((a, b) =>
    isAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
    update(); // Notify listeners of the change in transactions
  }

  void selectTransaction(TransactionModel transaction, bool selected) {
    if (selected) {
      selectedTransactions.add(transaction);
    } else {
      selectedTransactions.remove(transaction);
    }
    update();
  }

  void selectAllTransactions(bool selected) {
    if (selected) {
      selectedTransactions.assignAll(transactions);
    } else {
      selectedTransactions.clear();
    }
  }

  void toggleCheckboxes() {
    showCheckboxes = !showCheckboxes; // Toggle checkbox visibility
    if (!showCheckboxes) {
      selectedTransactions
          .clear(); // Clear selected transactions when hiding checkboxes
    }
    update();
  }

  bool isSelected(TransactionModel transaction) {
    return selectedTransactions.contains(transaction);
  }

  Future<void> exportToExcel() async {
    // Prepare Excel content
    var excel = Excel.createExcel();

    var sheet = excel['Transactions'];

    CellStyle cellStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      underline: Underline.Single, // or Underline.Double
    );
    sheet.appendRow([
      TextCellValue('Date'),
      TextCellValue('Category'),
      TextCellValue('Amount'),
      TextCellValue('Currency'),
      TextCellValue('Type'),
      TextCellValue('Note'),
    ]);
    for (var transaction in transactions) {
      sheet.appendRow([
        TextCellValue(transaction.date),
        TextCellValue(transaction.category),
        TextCellValue(transaction.amount.toString()),
        TextCellValue(transaction.currency),
        TextCellValue(transaction.amount < 0
            ? 'Expense'
            : 'Income'),
        TextCellValue(transaction.text ?? ''),
      ]);
    }

    final String excelFileName = 'transactions.xlsx';
    final String excelPath = await _localPath + '/$excelFileName';
    await File(excelPath).writeAsBytes(excel.encode()!);


    // Share Excel file using share_plus
    await Share.shareXFiles([XFile(excelPath)], text: 'Exported transactions.xlsx');
    update();
  }
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }
}