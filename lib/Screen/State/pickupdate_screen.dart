import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Screen/State/Controller/state_controller.dart';
import 'package:flutter_app_expenses_income/Screen/State/state_model.dart';
import 'package:flutter_app_expenses_income/Screen/home/home_screen.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PickupdateScreen extends StatefulWidget {
  const PickupdateScreen({super.key});

  @override
  State<PickupdateScreen> createState() => _PickupdateScreenState();
}

class _PickupdateScreenState extends State<PickupdateScreen> {
  List<DateTime?> _selectedDate = [null, null];
  final controller = Get.put(StateController());
  late TextEditingController _dateController;
  String fontFamily = getFontFamily(Get.locale!);

  Future<void> datePicker(BuildContext context) async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
      ),
      dialogSize: const Size(325, 400),
      value: _selectedDate,
      borderRadius: BorderRadius.circular(15),
    );

    if (results != null && results.isNotEmpty) {
      setState(() {
        _selectedDate = results;
        if (_selectedDate[0] != null && _selectedDate[1] != null) {
          controller.customStartDate = _selectedDate[0];
          controller.customEndDate = _selectedDate[1];
          controller.selectedDateRange = '${DateFormat('dd/MM/yyyy').format(controller.customStartDate!)} - ${DateFormat('dd/MM/yyyy').format(controller.customEndDate!)}';
          controller.fetchTransaction('Custom');
        }
      });
    }
  }

  String _formatDateRange() {
    if (_selectedDate[0] == null && _selectedDate[1] == null) {
      return "";
    }
    final startDate = _selectedDate[0] != null
        ? "${_selectedDate[0]!.day}/${_selectedDate[0]!.month}/${_selectedDate[0]!.year}"
        : "";
    final endDate = _selectedDate[1] != null
        ? "${_selectedDate[1]!.day}/${_selectedDate[1]!.month}/${_selectedDate[1]!.year}"
        : "";
    if (startDate.isEmpty) return endDate;
    if (endDate.isEmpty) return startDate;
    return "$startDate - $endDate";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<StateController>(
          init: StateController(),
          builder: (controller) {
            return ListView.builder(
                itemCount: pickdate.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      if (pickdate[index].text == 'Custom') {
                        datePicker(context).then((_){
                          Get.back();
                        });

                      } else {
                        controller.selectedDateRange = pickdate[index].text;
                        controller
                            .fetchTransaction(controller.selectedDateRange);
                        Get.back();
                      }
                    },
                    leading: Icon(
                      Icons.date_range,
                      color: Colors.amber,
                    ),
                    title: Text(pickdate[index].text.tr,style:  controller.selectedDateRange == pickdate[index].text ? TextStyle(color: Colors.amber,fontWeight: FontWeight.bold,fontFamily: fontFamily):TextStyle(fontFamily: fontFamily),),

                     trailing:  controller.selectedDateRange == pickdate[index].text ? Icon(Icons.done): null,
                  );
                });
          }),
    );
  }
}
