import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Authentication/Authen_Controller/register_controller.dart';
import 'package:flutter_app_expenses_income/Authentication/firestorage_service.dart';
import 'package:flutter_app_expenses_income/Authentication/form.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/darkmode_controller.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final DarkmodeController darkmodeController=Get.put(DarkmodeController());

  // File? imageFile;
  // String? imageUrl;
  //
  // void _selectImage() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     setState(() {
  //       imageFile = File(pickedImage.path);
  //     });
  //
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkmodeController.isDarkMode ? Colors.white: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GetBuilder<RegisterController>(
          init: RegisterController(),
          builder: (controller) {
            return Form(
              key: controller.formkeys,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Create an Account', style: kTitleTextStyle,),
                  const SizedBox(height: 20,),
                  Stack(
                    children: [
                    controller.  imageFile != null ?
                      CircleAvatar(
                        backgroundImage: FileImage(controller.imageFile!),
                        backgroundColor: kButtonColor,
                        radius: 60,

                      ) : CircleAvatar(

                        backgroundColor: kButtonColor,
                        radius: 60,
                        child: Icon(
                          Icons.person, color: Colors.white, size: 60,),
                      ),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: IconButton.filled(
                            style: IconButton.styleFrom(
                                backgroundColor: Colors.grey),
                            onPressed: () {
                              controller.selectImage();
                            },
                            icon: const Icon(Icons.camera_alt),
                          ))
                    ],
                  ),
                  const SizedBox(height: 20,),
                  TextForm(hinhtext: 'Full Name',
                    icon: Icon(Icons.person),
                    controller: controller.nameController,
                    validator: controller.nameValidate,),
                  TextForm(hinhtext: 'Email',
                    icon: Icon(Icons.email),
                    controller: controller.emailController,
                    validator: controller.emailValidate,),
                  TextForm(hinhtext: 'Phone Number',
                    icon: Icon(Icons.phone_android),
                    controller: controller.phoneController,
                    validator: controller.phonevalidator,),
                  TextForm(hinhtext: 'Password',
                    icon: Icon(Icons.key),
                    controller: controller.passwordController,
                    validator: controller.passwordValidate,),
                  TextForm(hinhtext: 'Comfirm Passwod',
                    icon: Icon(Icons.key),
                    controller: controller.confirmPasswordController,
                    validator: controller.passwordComfirmValidator,),

                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      height: 55,
                      width: Get.width,
                      child: ElevatedButton.icon(
                        iconAlignment: IconAlignment.end,
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: kButtonColor,
                            foregroundColor: Colors.white
                        ),
                        onPressed: () {
                          controller.signUp(context);
                        },
                        label: const Text('Register'),
                        icon: const Icon(Icons.login),),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?',style: TextStyle(color: Colors.black),),
                      TextButton(onPressed: () {
                        Get.back();
                      },
                          child: const Text(
                            'Login', style: TextStyle(color: kButtonColor),))
                    ],
                  )
                ],),
            );
          }
      ),
    );
  }
}
