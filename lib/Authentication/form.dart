import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final String hinhtext;
  final Icon icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const TextForm({super.key,required this.hinhtext , required this.icon,required this.controller,required this.validator});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 30,right: 30,top: 15),
      child: TextFormField(
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.black),
        validator: validator,
        controller: controller,

          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber,width: 2),borderRadius: BorderRadius.circular(20)),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintStyle: TextStyle(color: Colors.grey),
              hintText: hinhtext,
              prefixIcon: icon)),
    );
  }
}
