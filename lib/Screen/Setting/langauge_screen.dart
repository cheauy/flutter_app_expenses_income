import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/language_controller.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/setting_screen.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:get/get.dart';

class LangaugeScreen extends StatelessWidget {
  const LangaugeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String fontFamily = getFontFamily(Get.locale!);
    return Scaffold(appBar: AppBar(),
    body:  GetBuilder<LanguageController>(
      init: LanguageController(),
      builder: (controller) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('chooselanuage'.tr,style: TextStyle(fontSize: 24,fontFamily: fontFamily,fontWeight: FontWeight.bold),),

            Container(
              height: Get.height*0.3,
                width: Get.width,
                child: ListView.builder(
                itemCount: controller.languages.length,
                itemBuilder: (context,index){
                  return  Card(
                    margin: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: (){
                        controller.changeLocale(index);
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: controller.languages[index].image)),),
                            ),
                            SizedBox(width: 10,),
                            Text(controller.languages[index].lang,style: TextStyle(fontFamily: fontFamily),),
                          ],
                        ),
                      ),
                    ),
                  );
            }))


          ],),
        );
      }
    ),);
  }
}
