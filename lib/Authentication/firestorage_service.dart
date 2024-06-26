import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static Future<String> uploadImage(File imageFile, String uid) async {
    try {
      // Create a reference to the Firebase Storage path
      Reference storageReference = FirebaseStorage.instance.ref().child('user_images/$uid.jpg');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();

    } catch (e) {
      print('Failed to upload image to Firebase Storage: $e');
      return''; // You can choose to handle exceptions differently
    }
  }

}
