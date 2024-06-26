import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Authentication/Authen_Controller/authen_controller.dart';
import 'package:flutter_app_expenses_income/Authentication/register_screen.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/darkmode_controller.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final DarkmodeController darkmodeController=Get.put(DarkmodeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkmodeController.isDarkMode ? Colors.white: Colors.white,
      body: GetBuilder<AuthenController>(
          init: AuthenController(),
          builder: (controller) {
            return Form(
              key: controller.formkey,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      child: Image.network(
                          'https://icon-library.com/images/income-icon/income-icon-3.jpg'),
                    ),
                    const Text(
                      'Welcome back to Login Screen',
                      style: kTitleTextStyle,
                    ),
                    const Text(
                      'Track your expenses and income here.',
                      style: kSubtitleTextStyle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      cursorColor: Colors.black,
                      onChanged: (value) =>

                      controller.emailController.text = value,
                      controller: controller.emailController,
                      dragStartBehavior: DragStartBehavior.start,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber,width: 2),borderRadius: BorderRadius.circular(20)),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.mail)),
                      style: TextStyle(color: Colors.black),

                      validator: controller.emailValidator,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      cursorColor: Colors.black,
                      onChanged: (value) =>
                      controller.passwordController.text = value,
                      controller: controller.passwordController,
                      decoration: InputDecoration(

                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber,width: 2),borderRadius: BorderRadius.circular(20)),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: Icon(
                            Icons.remove_red_eye,
                            color: kButtonColor,
                          ),
                          prefixIcon: Icon(Icons.lock)),
                      style: TextStyle(color: Colors.black),
                      validator: controller.passwordValidator,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                      const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                    Text(
                    'Forgot Password?',
                    style: kSubtitleTextStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                controller.isLoading ? Center(child: CircularProgressIndicator()) :
                Container(
                  height: 55,
                  width: Get.width,
                  child: ElevatedButton.icon(
                    iconAlignment: IconAlignment.end,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: kButtonColor,
                        foregroundColor: Colors.white),
                    onPressed: () {

                      controller.signIn(controller.emailController.text.trim(),
                          controller.passwordController.text.trim(), context);
                    },
                    label: Text('Login'),
                    icon: Icon(Icons.login),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Dont have an account?',style: TextStyle(color: Colors.black),),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const RegisterScreen());
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: kButtonColor),
                      ),
                    )
                  ],
                )
                ],
              ),
            ),);
          }),
    );
  }
}
