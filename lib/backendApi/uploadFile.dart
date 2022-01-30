import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FirebaseApi{
  static UploadTask? uploadTask(String dest,File img){
    EasyLoading.show();
    try {
      
      final ref =FirebaseStorage.instance.ref(dest);
      EasyLoading.dismiss();
      return ref.putFile(img);
      
    } on Exception catch (e) {
      EasyLoading.dismiss();
      print(e);
      return null;
    }
  }
}