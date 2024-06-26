// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_expenses_income/Authentication/fire_service.dart';
// import 'package:flutter_app_expenses_income/Screen/Setting/cate_model.dart';
// import 'package:flutter_app_expenses_income/Screen/home/Controller/transaction_controller.dart';
// import 'package:flutter_app_expenses_income/Screen/home/Controller/transation_model.dart';
// import 'package:flutter_app_expenses_income/Screen/home/dropbutton.dart';
// import 'package:flutter_app_expenses_income/Screen/home/formfield.dart';
// import 'package:flutter_app_expenses_income/const.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:toggle_switch/toggle_switch.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
//
// class UpdateTransaction extends StatefulWidget {
//   final TransactionModel transactionModel;
//   const UpdateTransaction({super.key, required this.transactionModel});
//
//   @override
//   State<UpdateTransaction> createState() => _UpdateTransactionState();
// }
//
// class _UpdateTransactionState extends State<UpdateTransaction> {
//
//   FirestoreService firebaseService = FirestoreService();
//   final controller = Get.put(TransactionController());
//
//   void handleToggle(int index) {
//     setState(() {
//       controller.toggleIndex = index;
//     });
//
//
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     if (widget.transactionModel != null){
//       controller.updateTransactionDetails(
//         amount: widget.transactionModel.amount,
//         currency: widget.transactionModel.currency,
//         category: widget.transactionModel.category,
//         date: DateFormat('yyyy-MM-dd').parse(widget.transactionModel.date),
//         text: widget.transactionModel.text,
//       );
//     }
//
//
//   }
//
//   @override
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset : false,
//       backgroundColor: kBackground,
//       body: GestureDetector(
//         onTap: ()=> FocusManager.instance.primaryFocus?.unfocus(),
//         child: GetBuilder<TransactionController>(
//             init:TransactionController(),
//             builder: (controller) {
//               return SingleChildScrollView(
//                 physics: NeverScrollableScrollPhysics(),
//                 child: Form(
//                   key: controller.formkey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                             color: Colors.amber, borderRadius: BorderRadius.circular(20)),
//                         height: 8,
//                         width: 80,
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Container(child: Text('Edit Transaction',style: kTitleTextStyle,),),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 30),
//                         child: Container(
//                           decoration: BoxDecoration(color: Colors.grey[300],borderRadius: BorderRadius.circular(10)),
//                           child: ToggleButtons(
//                             onPressed: handleToggle,
//                             isSelected: [controller.toggleIndex == 0,controller.toggleIndex == 1],
//                             selectedColor: Colors.white, // Sets the background color for selected button
//                             fillColor: Colors.amber, // Sets the color behind the selected button's icon and text
//                             borderRadius: BorderRadius.circular(10),
//                             borderColor: Colors.white,// Sets the border radius for all buttons
//
//
//                             children: [
//                               _buildToggleButton('Expenses', Icons.money_off),
//                               _buildToggleButton('Income', Icons.monetization_on),
//                             ], // Sets the b
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Container(
//                         child:   Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 30),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: FormFieldScreen(
//                                   validator: controller.amountValidator,
//                                   hintText: 'amount',
//                                   icon: Icon(
//                                     Icons.monetization_on,
//                                     color: Colors.amber,
//                                   ),
//                                   useMaxLines: false,
//                                   readyonly: false,
//                                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                                   controller: controller.amountController,
//
//
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               Expanded(
//                                 flex: 1,
//                                 child: DropButton(item: item,hint: 'Currency',onChanged: (newValue)=>controller.onCurrencyChanged(newValue),validator: controller.currencyValidator,),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Container(
//                         child:  Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 30),
//                             child: DropButton(item: controller.categoryNames, hint: 'Please select category',onChanged: (newValue)=> controller.onCategoryChanged(newValue),validator: controller.categoryValidator,)
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//
//                       Container(
//                         child:  Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 30),
//                           child: FormFieldScreen(
//                             label: 'Date of the expense',
//                             controller: controller.dateController,
//                             icon: Icon(
//                               Icons.date_range,
//                               color: Colors.amber,
//                             ),
//                             useMaxLines: false,
//                             readyonly: true,
//
//                             onTap: (){
//                               controller.datePicker(context);
//                             },
//
//
//
//
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Container(
//                         child:  Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 30),
//                           child: FormFieldScreen(
//                             validator: controller.textValidator,
//                             hintText: 'Any additional notes or descriptions',
//                             useMaxLines: true,
//                             readyonly: false,
//                             controller: controller.textController,
//
//
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(30),
//                         child: Container(
//                           height: 55,
//                           width: Get.width,
//                           child: ElevatedButton(
//                               iconAlignment: IconAlignment.end,
//                               style: ElevatedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(15)),
//                                   backgroundColor: Colors.amber,
//                                   foregroundColor: Colors.white),
//                               onPressed: () {
//                                 if(controller.formkey.currentState!.validate()){
//                                   controller.addTransaction();
//                                 }
//
//                               },
//                               child: const Text('Update Transactions')),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//         ),
//       ),
//     );
//   }
// }
// Widget _buildToggleButton(String label, IconData icon) {
//   return Container(
//     width: Get.width*0.42,
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon),
//         SizedBox(width: 8.0),
//         Text(label),
//       ],
//     ),
//   );
// }
