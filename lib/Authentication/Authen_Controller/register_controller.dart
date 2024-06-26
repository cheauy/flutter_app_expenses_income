import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_expenses_income/Authentication/fire_service.dart';
import 'package:flutter_app_expenses_income/Authentication/firestorage_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController =
      TextEditingController(text: 'cheauy');
  final TextEditingController emailController =
      TextEditingController(text: 'admin@gmail.com');
  final TextEditingController phoneController =
      TextEditingController(text: '012365998');
  final TextEditingController passwordController =
      TextEditingController(text: '123456');
  final TextEditingController confirmPasswordController =
      TextEditingController(text: "123456");

  final formkeys = GlobalKey<FormState>();
  var errorMessage = '';
  bool isLoading = false;
  File? imageFile;

  final FirestoreService firestoreService = FirestoreService();


  void updateState(bool state) {
    isLoading = state;
    update();
  }
  void setLoading(bool value) {
    isLoading = value;
    if (value) {
      EasyLoading.show(status: 'loading...');
    } else {
      EasyLoading.dismiss();
    }
  }
  void selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      imageFile = File(pickedImage.path);
      update(); // Update GetX state
    }
  }


  void _showErrorDialogRes(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign up failed'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> signUp(BuildContext context) async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String phone = phoneController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();


    if (password != confirmPassword) {
      _showErrorDialogRes(context, 'Passwords do not match');
      return;
    }
    if (formkeys.currentState!.validate()) {
      try {
        setLoading(true);
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String? imageUrl;
        if (imageFile !=null ) {
          imageUrl = await FirebaseStorageService.uploadImage(imageFile!, userCredential.user!.uid);
        }else {
          imageUrl= await uploadDefaultImage(userCredential.user!.uid);
        }
        await firestoreService.createUser(
          uid: userCredential.user!.uid,
          name: name,
          email: email,
          phoneNumber: phone,
          imageUrl: imageUrl,
        );

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: 'Success',
          desc: 'Your account created successfully',
          btnOkOnPress: () {
            Get.back();
            Get.back();
          },
        )..show();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          errorMessage = 'Error: The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The email already exists please try agian.';
        }
        _showErrorDialogRes(context, errorMessage);
      } catch (e) {
        errorMessage = 'An error occurred';
        _showErrorDialogRes(context, errorMessage);
      }finally{
        setLoading(false);
      }
    }

  }
  Future<String> uploadDefaultImage(String uid) async {
    final ByteData bytes = await rootBundle.load('assets/images/profile.png');
    final Uint8List imageData = bytes.buffer.asUint8List();

    final Reference storageReference = FirebaseStorage.instance.ref().child('user_images/$uid.jpg');
    final UploadTask uploadTask = storageReference.putData(imageData);
    final TaskSnapshot downloadUrl = await uploadTask;
    final String url = await downloadUrl.ref.getDownloadURL();

    return url;
  }

  String? emailValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? nameValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? phonevalidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    return null;
  }

  String? passwordComfirmValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? passwordValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
