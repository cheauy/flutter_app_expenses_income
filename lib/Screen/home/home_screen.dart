import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/darkmode_controller.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/language_service.dart';
import 'package:flutter_app_expenses_income/Screen/home/Controller/transaction_controller.dart';
import 'package:flutter_app_expenses_income/Screen/home/Controller/transation_model.dart';
import 'package:flutter_app_expenses_income/Screen/home/add_transaction.dart';
import 'package:flutter_app_expenses_income/Screen/home/update_screen.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final darkController=Get.put(DarkmodeController());
  final controller = Get.put(TransactionController());
  String fontFamily = getFontFamily(Get.locale!);
  void showDeletAlert(BuildContext context, TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alert'),
        content: Text('alert message'.tr,style: TextStyle(fontFamily: fontFamily),),
        actions: <Widget>[
          TextButton(
            child: Text('yes'.tr,style: TextStyle(fontFamily: fontFamily)),
            onPressed: ()  {

                controller.deleteTran(transaction.id);
                controller.handleRefresh();
                Get.back();


            }
          ),
          TextButton(
            child: Text('no'.tr,style: TextStyle(fontFamily: fontFamily)),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.fetchTransaction(isDateRange: false);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
      // scrolledUnderElevation:0.0,
        forceMaterialTransparency: true,
        title:  Text(
          'transactions'.tr,style: TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold),

        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GetBuilder<TransactionController>(
                init: TransactionController(),
                builder: (controller) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            controller.previousMonth();
                          },
                          icon: const Icon(Icons.arrow_back)),
                      Expanded(
                        child: Padding(
                          padding: controller.isDateRangeSelected ? EdgeInsets.symmetric(horizontal: 30):EdgeInsets.symmetric(horizontal: 60),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.amber, width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                                onTap: () => controller.dateRange(context),
                                textAlign: TextAlign.center,
                                readOnly: true,
                                controller: TextEditingController(

                                    text: controller.isDateRangeSelected  ? '${DateFormat('dd/MM/yyyy').format(controller.startDate)} - ${DateFormat('dd/MM/yyyy').format(controller.endDate)}' : DateFormat('MMMM yyyy'.tr).format(controller.currentMonth),),
                                style: TextStyle(
                                    color: darkController.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                decoration: const InputDecoration(
                                  hintText: 'Select Dates',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            controller.nextMonth();
                          },
                          icon: const Icon(Icons.arrow_forward))
                    ],
                  );
                }
              ),
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
              child:
              GetBuilder<TransactionController>(
                init: TransactionController(),
                builder: (controller) {
                  if(controller.isRefreshing){
                    return Center(child: CupertinoActivityIndicator(),);
                  }
                 else if(controller.transactions.isEmpty){
                    return Center(child: Text('No transactions available'.tr,style: TextStyle(fontFamily: fontFamily)),);
                  }else {
                    return ListView.builder(
                        itemCount:
                        controller.transactions.keys.length,
                        itemBuilder: (context, index) {
                          DateTime date = controller
                              .transactions.keys
                              .elementAt(index);
                          List<TransactionModel> dailyTransactions =
                          controller.transactions[date]!;
                          double totalAmount = dailyTransactions.fold(0.0, (sum, item) => sum + item.amount);
                          // Determine if the date label should be "Today" or formatted date
                          String dateLabel = controller.formatter.format(date);
                          DateTime now =DateTime.now();
                          if (date.year == now.year &&
                              date.month == now.month &&
                              date.day == now.day) {
                            dateLabel = "today";
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10)),
                                      child: Text(
                                        dateLabel.tr,
                                        style:  TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 16,fontFamily: fontFamily),
                                      ),
                                    ),
                                    const Spacer(),
                                     Text(
                                       '\$ ${totalAmount.toStringAsFixed(1)}',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Column(
                                  children: dailyTransactions
                                      .map((transaction) {
                                    return Slidable(

                                      endActionPane: ActionPane(
                                        extentRatio: 0.2,
                                        motion: BehindMotion(),
                                        children: [
                                         Spacer(flex: 3,),
                                          InkWell(
                                            onTap: ()=>showDeletAlert(context,transaction),
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(10)),
                                              child: Icon(Icons.delete,color: Colors.white,)
                                            ),
                                          ),
                                          Spacer(flex: 2,),

                                        ],
                                      ),
                                      child: GestureDetector(
                                        onTap: (){
                                          showModelUpdate(context,transaction);
                                        },
                                        child: Card(
                                          color: darkController.isDarkMode ? Colors.grey.withOpacity(0.1): Colors.grey[200],
                                          child: ListTile(
                                            title: Text(
                                                transaction.category.tr,style: TextStyle(fontFamily: fontFamily)),
                                            subtitle: Text(
                                                transaction.text!,style: TextStyle(fontFamily: fontFamily)),
                                            trailing: Text(
                                              '${transaction.amount.toString()} ${transaction.currency}',
                                              style:  TextStyle(
                                                fontSize: 14,
                                                  color: transaction.amount < 0 ? Colors.red:
                                                  Colors.green),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          );
                        });
                  }

                }
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          showModelAdd(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}


void showModelUpdate(BuildContext context,TransactionModel trans) {
  final DarkmodeController darkmodeController =Get.put(DarkmodeController());
  showCupertinoModalBottomSheet(
    context: Get.context!,
    builder: (context) => Container(
      color: darkmodeController .isDarkMode ? CupertinoColors.darkBackgroundGray.withOpacity(0.5):  kBackground,
      child: DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.7,
        maxChildSize: 1.0,
        initialChildSize: 0.8,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
              height: Get.height * 0.70, // Make sure the container can expand fully
              child:  AddTransaction(transactionModel: trans,),
            ),
          );
        },
      ),
    ),
  );
}
void showModelAdd(BuildContext context,) {
  final DarkmodeController darkmodeController =Get.put(DarkmodeController());
  final TransactionController transactionController =Get.put(TransactionController());

  showCupertinoModalBottomSheet(
    context: Get.context!,
    builder: (context) => Container(
      color:  darkmodeController .isDarkMode ? CupertinoColors.darkBackgroundGray.withOpacity(0.5): kBackground,
      child: DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.7,
        maxChildSize: 1.0,
        initialChildSize: 0.8,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
              height: Get.height * 0.70, // Make sure the container can expand fully
              child:  AddTransaction(),
            ),
          );
        },
      ),
    ),
  ).whenComplete((){
    transactionController.toggleIndex=-1;
  });
}

