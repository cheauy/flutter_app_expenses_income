import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Authentication/Authen_Controller/authen_controller.dart';
import 'package:flutter_app_expenses_income/Authentication/user_model.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/darkmode_controller.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/language_controller.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/user_controller.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/setting_model.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:get/get.dart';

class SettingScreen extends StatefulWidget {

  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final AuthenController authcontroller=Get.put(AuthenController());
  final UserController userController=Get.put(UserController());
  String fontFamily = getFontFamily(Get.locale!);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'setting'.tr,style: TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold),

        ),
        centerTitle: true,
      ),
      body: GetBuilder<DarkmodeController>(
        init: DarkmodeController(),
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                flex: 8,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: settingModel.length,
                    itemBuilder: (context, index) {
                      final list = settingModel[index];
                      if(list.text=='theme'){
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: controller.isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            height: Get.height * 0.1,
                            width: Get.width,
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: controller.isDarkMode ?  list.icon : Icon(Icons.lightbulb,color: Colors.amber,)
                              ),
                              title: Text(list.text.tr, style: TextStyle(fontSize: 16,fontFamily: fontFamily,fontWeight: FontWeight.bold)),
                              subtitle: Text(!controller.isDarkMode ?'light'.tr: list.subTitle.tr,style: TextStyle(
                                  color: Colors.amber[600],fontFamily: fontFamily)),
                              trailing: Switch(
                                value: controller.isDarkMode,
                                onChanged: (value) {
                                  controller.toggleTheme();
                                },
                              ),

                            ),
                          ),
                        );
                      }
                      else if (list.text == 'language') {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: controller.isDarkMode ? Colors.grey.withOpacity(0.1) :Colors.grey[300],
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            height: Get.height * 0.1,
                            width: Get.width,
                            child: GetBuilder<LanguageController>(
                              init: LanguageController(),
                              builder: (controller) {
                                return ListTile(
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.grey[100],
                                      child: list.icon),
                                  title:  Text(list.text.tr, style: TextStyle(fontSize: 16,fontFamily: fontFamily,fontWeight: FontWeight.bold)),
                                  subtitle: Text(controller.getCurrentLanguage(),style: TextStyle(
                                      color: Colors.amber[600],fontFamily: fontFamily)),
                                  trailing: list.trailIcon,
                                  onTap: () {
                                    if (list.onTap != null) {
                                      list.onTap!(context);
                                    }
                                  },
                                );
                              }
                            ),
                          ),
                        );
                      }
                      else {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color:controller.isDarkMode ? Colors.grey.withOpacity(0.1): Colors.grey[300],
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            height: Get.height * 0.1,
                            width: Get.width,
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Colors.grey[100],
                                  child: list.icon),
                              title: Text(list.text.tr, style: TextStyle(fontSize: 16,fontFamily: fontFamily,fontWeight: FontWeight.bold)),
                              onTap: () {
                                if (list.onTap != null) {
                                  list.onTap!(context);
                                }
                              },
                              subtitle: Text(list.subTitle.tr, style: TextStyle(
                                  color: Colors.amber[600],fontFamily: fontFamily),),
                              trailing: list.trailIcon,
                            ),
                          ),
                        );
                      }
                    }),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 50,
                    width: Get.width,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white
                      ),
                      onPressed: (){
                        authcontroller.alertSignout(context);
                      }, label: Text('signout'.tr,style: TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold),),icon: Icon(Icons.logout_outlined),),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
