import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DarkmodeController extends GetxController{
  final key = 'Darkmode';
  final storage = GetStorage();
  var isDarkMode=false;


  DarkmodeController() {
    readTheme();

  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    writeTheme(isDarkMode);
    update();
  }

  void writeTheme(bool isDark) {
    storage.write(key, isDark);
  }

  void readTheme() {
    bool? writeTheme = storage.read(key);
    if(writeTheme != null){
      isDarkMode=writeTheme;
    }
  }
}