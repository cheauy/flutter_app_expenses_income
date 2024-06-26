import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/darkmode_controller.dart';
import 'package:flutter_app_expenses_income/Screen/State/Controller/state_controller.dart';
import 'package:flutter_app_expenses_income/Screen/State/pickupdate_screen.dart';
import 'package:flutter_app_expenses_income/Screen/State/state_model.dart';
import 'package:flutter_app_expenses_income/Screen/home/home_screen.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pie_chart/pie_chart.dart';

class StateScreen extends StatefulWidget {
  const StateScreen({Key? key}) : super(key: key);

  @override
  State<StateScreen> createState() => _StateScreenState();
}

class _StateScreenState extends State<StateScreen> {
  final statecontroller = Get.put(StateController());
  final darkController = Get.put(DarkmodeController());
  String fontFamily = getFontFamily(Get.locale!);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    statecontroller.fetchTransaction(statecontroller.selectedDateRange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'states'.tr,
          style: TextStyle(
              fontSize: 24,
              fontFamily: fontFamily,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(10)),
              height: 50,
              width: 40,
              child: IconButton(
                onPressed: () {
                  statecontroller.onRefresh();
                },
                icon: Icon(
                  CupertinoIcons.refresh,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: GetBuilder<StateController>(
              init: StateController(),
              builder: (controller) {
                return GestureDetector(
                  onTap: () => showModelDate(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber, width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: TextEditingController(
                              text: controller.selectedDateRange.tr),
                          enabled: false,
                          // Disable editing of the TextField
                          style: TextStyle(
                              color: darkController.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          decoration: const InputDecoration(
                            hintText: 'Select Dates',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        )),
                  ),
                );
              }
          ),
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          height: 100,
          child: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            child: GetBuilder<StateController>(
                init: StateController(),
                builder: (controller) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child:
                          Column(
                            children: [
                              Text(
                                'income'.tr,
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$ ${controller.totalIncome.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blueAccent),
                              )
                            ],
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child
                              : Column(
                            children: [
                              Text(
                                'expense'.tr,
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$ ${controller.totalExpense.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.redAccent),
                              )
                            ],
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child
                              : Column(
                            children: [
                              Text(
                                'balance'.tr,
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$ ${controller.totalBalance.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color:
                                    statecontroller.totalBalance >=
                                        0
                                        ? Colors.green
                                        : Colors.red),
                              )
                            ],
                          )),
                    ],
                  );
                }),
          ),
        ),
      ),

      body: GetBuilder<StateController>(
          init: StateController(),
          builder: (controller) {
            if(controller.isRefreshing){
              return Center(child: CupertinoActivityIndicator(),);
            }else if(controller.categoryTotal.isEmpty){
              return Center(child: Text('data empty'.tr,style: TextStyle(fontFamily: fontFamily),),);
            }
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    dataMap: controller.dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 20,
                    chartRadius: MediaQuery.of(context).size.width * 0.8,
                    // colorList: colorList,
                    chartType: ChartType.disc,
                    centerText:
                    "Expenses: ${statecontroller.totalExpense.toStringAsFixed(2)} \n Income: ${statecontroller.totalIncome.toStringAsFixed(2)}"
                        .tr,
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      // legendShape: _BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: controller.categoryTotal.length,
                    itemBuilder: (context, index) {
                      String categoryName = controller
                          .categoryTotal.keys
                          .elementAt(index);
                      double totalAmount = controller
                          .categoryTotal.values
                          .elementAt(index);
                      return ListTile(
                        title: Text(categoryName.tr,
                            style: TextStyle(
                                fontSize: 16, fontFamily: fontFamily)),
                        trailing: Text(
                            '${totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 14)),
                      );
                    },
                  ),
                ),
              ],
            );
          }
      )
    );
  }
}

void showModelDate(
  BuildContext context,
) {
  showCupertinoModalBottomSheet(
    context: Get.context!,
    builder: (context) => Container(
      color: kBackground,
      child: Container(
        height: Get.height * 0.40,
        child: PickupdateScreen(),
      ),
    ),
  );
}
