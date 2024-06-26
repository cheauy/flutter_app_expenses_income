import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Authentication/fire_service.dart';
import 'package:flutter_app_expenses_income/Authentication/user_model.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/export_data_screen.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/langauge_screen.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/category_screen.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/profile_screen.dart';
import 'package:get/get.dart';

class SettingModel {
  final Icon icon;
  final String text;
  final String subTitle;
  final Icon trailIcon;

  final void Function(BuildContext context)? onTap;

  SettingModel({
    required this.icon,
    required this.text,
    required this.subTitle,
    required this.trailIcon,
    this.onTap,
  });
}

List<SettingModel> settingModel = [
  SettingModel(
      onTap: (context) {
        Get.to(
            () => ProfileScreen(),
            transition: Transition.leftToRightWithFade);
      },
      icon: const Icon(
        Icons.person,
        color: Colors.amber,
      ),
      subTitle: 'viewyourprofile',
      text: "profile",
      trailIcon: const Icon(Icons.arrow_forward_ios)),
  SettingModel(
      icon: const Icon(
        Icons.category,
        color: Colors.amber,
      ),
      subTitle: 'categorysubtitle',
      text: "category",
      onTap: (context) async {

        Get.to(() => CategoryScreen());
      },
      trailIcon: const Icon(Icons.arrow_forward_ios)),
  SettingModel(
      icon: const Icon(
        Icons.language,
        color: Colors.amber,
      ),
      subTitle: 'English',
      text: "language",
      onTap: (context)  {
        Get.to(() => const LangaugeScreen(),transition: Transition.leftToRightWithFade);
      },
      trailIcon: const Icon(Icons.arrow_forward_ios)),
  SettingModel(
      icon: const Icon(
        Icons.dark_mode,
        color: Colors.amber,
      ),
      text: "theme",
      subTitle: 'darksubtitle',
      trailIcon: const Icon(Icons.arrow_forward_ios)),
  SettingModel(
      icon: const Icon(
        Icons.download,
        color: Colors.amber,
      ),
      subTitle: 'expoersubtitle',
      text: "export",
      onTap: (context)  {
        Get.to(() => ExportDataScreen(),transition: Transition.leftToRightWithFade);
      },
      trailIcon: const Icon(Icons.arrow_forward_ios)),
];
