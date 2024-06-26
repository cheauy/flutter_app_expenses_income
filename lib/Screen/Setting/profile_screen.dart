import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Authentication/Authen_Controller/authen_controller.dart';
import 'package:flutter_app_expenses_income/Authentication/fire_service.dart';
import 'package:flutter_app_expenses_income/Authentication/user_model.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/user_controller.dart';
import 'package:flutter_app_expenses_income/Screen/home/Controller/transation_model.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthenController authenController = Get.put(AuthenController());
  final UserController userController = Get.put(UserController());
  final FirestoreService firebaseService = FirestoreService();
  String fontFamily = getFontFamily(Get.locale!);
  void showDeletAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alert'),
        content: Text(
            'Are you sure u want to delete your account your data will be lost!'
                .tr),
        actions: <Widget>[
          TextButton(
              child: Text('yes'.tr),
              onPressed: () {
                authenController.deleteUser(authenController.passwordController.text);
                Get.back();
              }),
          TextButton(
            child: Text('no'.tr),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'profile'.tr,
          style: TextStyle(fontSize: 24,fontFamily: fontFamily,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GetBuilder<UserController>(
            init: UserController(),
            builder: (controller) {
              if(controller.isLoading){
                return Center(child: CupertinoActivityIndicator(),);
              }
              return Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage:
                    NetworkImage(controller.userModel.imageUrl!),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Text('name'.tr,style: TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold),),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            controller.userModel.name,
                            style: kFont16
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('email'.tr,style: TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold),),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.userModel.email,
                          style: kFont16,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('phoneNumber'.tr,style: TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold),),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.userModel.phoneNumber,
                          style: kFont16,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              );
            }
          ),
          Container(
              height: 50,
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      foregroundColor: Colors.white),
                  onPressed: () {
                    showDeletAlert(context);
                  },
                  label: Text('delete account'.tr,style: TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold),),
                  icon: Icon(Icons.delete_forever),
                ),
              )),
        ],
      ),
    );
  }
}
