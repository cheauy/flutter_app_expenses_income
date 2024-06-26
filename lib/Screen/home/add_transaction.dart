import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Authentication/fire_service.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/darkmode_controller.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/cate_model.dart';
import 'package:flutter_app_expenses_income/Screen/home/Controller/transaction_controller.dart';
import 'package:flutter_app_expenses_income/Screen/home/Controller/transation_model.dart';
import 'package:flutter_app_expenses_income/Screen/home/dropbutton.dart';
import 'package:flutter_app_expenses_income/Screen/home/formfield.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddTransaction extends StatefulWidget {
  final TransactionModel? transactionModel;

  const AddTransaction({Key? key, this.transactionModel}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {

  FirestoreService firebaseService = FirestoreService();
  bool isOnEditMode = false;
  final TransactionController controller = Get.put(TransactionController());
  final DarkmodeController darkmodeController = Get.put(DarkmodeController());
  String fontFamily = getFontFamily(Get.locale!);

  // void handleToggle(int index) {
  //   setState(() {
  //     controller.toggleIndex = index;
  //   });
  // }

  @override
  void initState() {
     var transcation = widget.transactionModel;
    if (transcation == null) {
      isOnEditMode = false;
      controller.amountController.clear();
      controller.selectedCurrency=null;
      controller.selectedCategory = null;
      controller.dateController.text=DateFormat('yyyy-MM-dd').format(DateTime.now());
      controller.textController.clear();
    } else {
      controller.amountController.text=transcation.amount.toString();
      controller.selectedCurrency=transcation.currency;
      controller.selectedCategory=transcation.category;
      DateTime transactionDate = DateFormat('yyyy-MM-dd').parse(transcation.date);
      controller.dateController.text=DateFormat('yyyy-MM-dd').format(transactionDate);
      controller.textController.text=transcation.text!;
      isOnEditMode=true;
     }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkmodeController .isDarkMode ? CupertinoColors.darkBackgroundGray.withOpacity(0.5): kBackground,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: GetBuilder<TransactionController>(
            init: TransactionController(),
            builder: (controller) {
              return SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Form(
                  key: controller.formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20)),
                        height: 8,
                        width: 80,
                      ),

                 isOnEditMode ?   Column(
                        children: [

                             SizedBox(
                              height: 20,
                            ),
                            Container(child: Text('edit transaction'.tr,style: TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold,fontSize: 24)),),


                        ],
                      ):SizedBox.shrink(),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          decoration: BoxDecoration(color: darkmodeController.isDarkMode? Colors.grey.withOpacity(0.1) : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)),
                            child: isOnEditMode ? null: ToggleButtons(

                              onPressed: (index){
                                controller.toggleCategoryType(index);

                              },
                              isSelected: [
                                controller.toggleIndex == 0,
                                controller.toggleIndex == 1,
                              ],
                              selectedColor: Colors.white,

                              fillColor: Colors.amber,

                              borderRadius: BorderRadius.circular(10),
                              borderColor: Colors.transparent,



                              children: [
                                _buildToggleButton('expense'.tr, Icons.money_off),
                                _buildToggleButton(
                                  'income'.tr, Icons.monetization_on),
                            ], // Sets the b
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: FormFieldScreen(
                                  validator: controller.amountValidator,
                                  hintText: 'amount'.tr,

                                  icon: Icon(
                                    Icons.monetization_on,
                                    color: Colors.amber,
                                  ),
                                  useMaxLines: false,
                                  readyonly: false,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  controller: controller.amountController,


                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                flex: 1,
                                child: DropButton(item: item,
                                  hint: 'currency'.tr,
                                  value: isOnEditMode ? controller.selectedCurrency!:null,
                                  onChanged: (newValue) =>
                                      controller.onCurrencyChanged(newValue),
                                  validator: controller.currencyValidator,),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: DropButton(
                              item: controller.categoryNames,
                              hint: 'choose category'.tr,
                              value: isOnEditMode ? controller.selectedCategory: null,
                              onChanged: (newValue) =>
                                  controller.onCategoryChanged(newValue),
                              validator: controller.categoryValidator,)
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: FormFieldScreen(
                            label: 'date'.tr,
                            controller: controller.dateController,
                            icon: Icon(
                              Icons.date_range,
                              color: Colors.amber,
                            ),
                            useMaxLines: false,
                            readyonly: true,

                            onTap: () {
                              controller.datePicker(context);

                            },


                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: FormFieldScreen(
                           // validator: controller.textValidator,
                            hintText: 'additional notes'.tr,
                            useMaxLines: true,
                            readyonly: false,
                            controller: controller.textController,


                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Container(
                          height: 55,
                          width: Get.width,
                          child: ElevatedButton(
                              iconAlignment: IconAlignment.end,
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.white),
                              onPressed: () {
                                if(isOnEditMode){
                                  if (controller.formkey.currentState!
                                      .validate()) {
                                    controller.updateTransaction(widget.transactionModel!.id).whenComplete((){
                                      controller.handleRefresh();
                                    });
                                    Get.back();
                                  }
                                }else{
                                  if (controller.formkey.currentState!
                                      .validate()) {
                                    controller.addTransaction().whenComplete((){
                                      controller.handleRefresh();
                                    });
                                  }
                                }

                              },
                              child:  Text(isOnEditMode ? 'update transaction'.tr: 'add transaction'.tr,style: TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold),)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}

Widget _buildToggleButton(String label, IconData icon) {
  String fontFamily = getFontFamily(Get.locale!);
  return Container(
    width: Get.width * 0.42,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        SizedBox(width: 8.0),
        Text(label,style: TextStyle(fontFamily: fontFamily),),
      ],
    ),
  );
}
