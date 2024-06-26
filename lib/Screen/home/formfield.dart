import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/darkmode_controller.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FormFieldScreen extends StatefulWidget {
  final String? hintText;
  final String? title;
  final Icon? icon;
  final String? label;
  final bool useMaxLines;
  final bool readyonly;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final String? Function(String?)? validator;


  const FormFieldScreen(
      {Key? key,
        this.title,
      this.hintText,
      this.icon,
      this.label,
      required this.useMaxLines,
      required this.readyonly, this.controller,this.keyboardType,this.onTap,this.validator}): super(key: key);

  @override
  State<FormFieldScreen> createState() => _FormFieldScreenState();
}

class _FormFieldScreenState extends State<FormFieldScreen> {
  final DarkmodeController darkmodeController = Get.put(DarkmodeController());
  String fontFamily = getFontFamily(Get.locale!);

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      validator: widget.validator,
      onTap: widget.onTap,
      keyboardType: widget.keyboardType,
      controller: widget.controller ,
      readOnly: widget.readyonly,
      maxLines: widget.useMaxLines ? 4 : 1,
      decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.amber, width: 2)),
          fillColor: darkmodeController.isDarkMode? Colors.grey.withOpacity(0.1) : Colors.grey[300],
          filled: true,
          border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          hintText: widget.hintText,
          hintStyle: TextStyle(fontFamily: fontFamily),
          labelStyle: TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold),
          labelText: widget.label,
          suffixIcon: widget.icon),
    );
  }
}
