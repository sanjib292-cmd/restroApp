import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class LoginRestro extends ChangeNotifier {
  var msg;
  var errorMsg;
  var userDetails;
  bool varifiedUser = false;
  var restrDetails;
  String firsturl = 'http://192.168.0.103:5000';
  Future loginRestro(phone, password,fcmToken) async {
    try {
      EasyLoading.show(status: 'loading...');
      var url = Uri.parse("$firsturl/loginrestro");
      var res = await http.post(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode({
            'password': password,
            'phone': phone,
            'fcmToken':fcmToken
          }));
      // EasyLoading.show(status: 'loading...');

      if (res.statusCode == 200) {
        EasyLoading.showSuccess('Great Success!');

        errorMsg = null;
        msg = res.body.toUpperCase();
        userDetails = res.headers['x-auth-token'];
        varifiedUser = true;
        notifyListeners();
        EasyLoading.dismiss();
        return res.body;
      }
      errorMsg = res.body;
      varifiedUser = false;
      notifyListeners();
      return null;
    } catch (ex) {
      print(ex);
    }
  }

  Future<Object> getRestroDetails(id) async {
    var url = Uri.parse("$firsturl/registerRestro/$id");
    var res = await http.get(
      url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    if (res.statusCode == 200) {
      restrDetails = res.body;
      notifyListeners();
      final Map parsed = json.decode(res.body);
      print(parsed.runtimeType);

      return parsed;
    }
    print('res.body e');
    return '404';
  }
}
