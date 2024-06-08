import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:tour/utils/file_utils.dart';
import 'package:tour/utils/firebase.dart';


abstract class Service {

  //function to upload images to firebase storage and retrieve the url.
  Future<String> uploadImage(Reference ref, File file) async {
    try {
      String ext = file.path.split('.').last;
      Reference storageReference = ref.child("${uuid.v4()}.$ext");
      UploadTask uploadTask = storageReference.putFile(file);
      
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String fileUrl = await taskSnapshot.ref.getDownloadURL();
      
      print("----------${storageReference.toString()}-----------");
      print("---------${fileUrl}-----------");
      
      return fileUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return "error while uploading image";
      // rethrow;
      
    }
  }
}