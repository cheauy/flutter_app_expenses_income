import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Authentication/login_screen.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/user_controller.dart';
import 'package:flutter_app_expenses_income/Screen/Tabbar/tabbar.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CupertinoActivityIndicator());
        }
        if (snapshot.hasData) {
          // User is signed in
          return TabScreen();
        }
        // User is not signed in
        return LoginScreen();
      },
    );
  }
}
