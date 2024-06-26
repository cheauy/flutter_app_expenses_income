import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Screen/home/home_screen.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/setting_screen.dart';
import 'package:flutter_app_expenses_income/Screen/State/state_screen.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int currentIndex=0;
  String fontFamily = getFontFamily(Get.locale!);


  List<Widget>get screen {
    return [
    const HomeScreen(),
    const StateScreen(),
      const SettingScreen()
    ];
}




  List<TabItem> items = [
      TabItem(
      icon: Ionicons.home,
      title: 'home'.tr,
    ),
     TabItem(
      icon: Ionicons.bar_chart,
      title: 'state'.tr,
    ),
     TabItem(
      icon: Ionicons.settings,
      title: 'settings'.tr,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[currentIndex],
      bottomNavigationBar: BottomBarInspiredInside(
        itemStyle: ItemStyle.circle,titleStyle: TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold),

        iconSize: 24,
        items: items,
        backgroundColor: Colors.amber,
        color: Colors.white,
        colorSelected: Colors.white,
        height: 50,
        indexSelected: currentIndex,
        chipStyle: const ChipStyle(
            notchSmoothness: NotchSmoothness.softEdge,
            background: Colors.amber),
        onTap: (int index) => setState(() {
          currentIndex = index;
        }),
      ),
    );
  }
}
