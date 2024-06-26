import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/export_controller.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({super.key});

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  final ExportController exportController = Get.put(ExportController());
  bool sortAscending = true; // Track current sort order
  int sortColumnIndex =
      0; // Track which column is currently sorted (0 for Date)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GetBuilder<ExportController>(
            init: ExportController(),
            builder: (controller) {
              return AppBar(
                title: Text('Export Data'),
                centerTitle: true,
                actions: [
                  TextButton(
                      onPressed: () {
                        controller.toggleCheckboxes();
                      },
                      child: Text(
                          !controller.showCheckboxes ? 'Select' : 'Close')),
                ],
              );
            }),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: (){
          exportController.exportToExcel();
                },child: Text('Export'),),
        ),),
      body: GetBuilder<ExportController>(
          init: ExportController(),
          builder: (controller) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: 0,
                sortAscending: controller.isAscending,
                columns: [
                  DataColumn(
                      label: GestureDetector(
                          onTap: () {
                            controller.toggleSortOrder();
                          },
                          child: Row(
                            children: [
                              Text('Date'),
                              Icon(
                                controller.isAscending
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                              ),
                            ],
                          ))),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Currency')),
                  DataColumn(label: Text('Note')),
                ],
                rows: controller.transactions
                    .map((transaction) => DataRow(
                            selected: controller.isSelected(transaction),
                            onSelectChanged: controller.showCheckboxes
                                ? (selected) {
                                    controller.selectTransaction(
                                        transaction, selected!);
                                  }
                                : null,
                            cells: [
                              DataCell(Text(transaction.date)),
                              DataCell(Text(transaction.category)),
                              DataCell(Text('${transaction.amount}')),
                              DataCell(Text(transaction.amount < 0
                                  ? 'Expense'
                                  : 'Income')),
                              DataCell(Text(transaction.currency)),
                              DataCell(Text(transaction.text!))
                            ]))
                    .toList(),
              ),
            );
          }),
    );
  }
}
