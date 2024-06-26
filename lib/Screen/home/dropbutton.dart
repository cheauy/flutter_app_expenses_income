import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/darkmode_controller.dart';
import 'package:flutter_app_expenses_income/Screen/home/Controller/transaction_controller.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:get/get.dart';

class DropButton extends StatefulWidget {
  final List<String>item;
  final String hint;
  final String? value;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  const DropButton({super.key,required this.item, this.value,required this.hint,required this.onChanged , this.validator});

  @override
  State<DropButton> createState() => _DropButtonState();
}

class _DropButtonState extends State<DropButton> {



  String? selectedValue;
  String fontFamily = getFontFamily(Get.locale!);
  final DarkmodeController darkmodeController=Get.put(DarkmodeController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionController>(
      init:TransactionController(),
      builder: (controller) {
        return DropdownButtonFormField2<String>(

          isExpanded: true,
          decoration: InputDecoration(
            fillColor: darkmodeController.isDarkMode? Colors.grey.withOpacity(0.1) : Colors.grey[300],
            filled: true,
            // Add Horizontal padding using menuItemStyleData.padding so it matches
            // the menu padding when button's width is not specified.
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            // Add more decoration..
          ),
          hint:  Text(
            widget.hint,
            style: TextStyle(fontSize: 14,fontFamily: fontFamily),
          ),
          value: widget.value,
          items: widget.item
              .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item.tr,
              style:  TextStyle(
                fontSize: 14,
                fontFamily: fontFamily
              ),
            ),
          ))
              .toList(),
          validator: widget.validator,
          onChanged: (newValue) {
            selectedValue = newValue!;
            widget.onChanged(newValue);
            if (newValue == 'Fetch Categories') {
              controller.fetchCategories();
            }
          },


          // onSaved: (value) {
          //  // selectedValue = value.toString();
          // },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 8),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
            iconSize: 24,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          // menuItemStyleData: const MenuItemStyleData(
          //   padding: EdgeInsets.symmetric(horizontal: 16),
          // ),
        );
      }
    );
  }
}
