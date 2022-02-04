import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class LoginRestro extends ChangeNotifier {
  var msg;
  var errorMsg;
  var userDetails;
  var forgotfail,forgotsucess;
  bool otpVarified=false;
  bool passwordupdated=false;
  bool varifiedUser = false;
  var restrDetails;
  String firsturl = 'https://mealtime7399.herokuapp.com';
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
      EasyLoading.dismiss();
      errorMsg = res.body;
      varifiedUser = false;
      notifyListeners();
      return null;
    } catch (ex) {
      print(ex);
    }
  }

  Future<Object> getRestroDetails(id) async {
    //print('rund');
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
      // final Map parsed = json.decode(res.body);
      // print(parsed.runtimeType);

      return jsonDecode(res.body);
    }
    print('${res.body}');
    return '404';
  }


    Future forGotpassword(phone) async {
    try {
      EasyLoading.show(status: 'loading...');
      var url = Uri.parse("$firsturl/loginrestro/forgotPassword/$phone");
      var res = await http.post(url);
      // EasyLoading.show(status: 'loading...');

      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        forgotfail = null;
        forgotsucess = res.body.toUpperCase();
        notifyListeners();
        EasyLoading.dismiss();
        return res.body;
      }
      forgotfail = res.body;
      notifyListeners();
      return null;
    } catch (ex) {
      print(ex);
    }
  }

    Future verifyOtp(phone,otp) async {
    try {
      EasyLoading.show(status: 'loading...');
      var url = Uri.parse("$firsturl/loginrestro/verifyOtp/$otp/$phone");
      var res = await http.post(url);
      // EasyLoading.show(status: 'loading...');

      if (res.statusCode == 200) {
        print(res.body);
        EasyLoading.dismiss();
        userDetails=res.body;
        otpVarified=true;
        notifyListeners();
        EasyLoading.dismiss();
        return res.body;
      }
      print(res.body);
      EasyLoading.dismiss();
      otpVarified=false;
      notifyListeners();
      return null;
    } catch (ex) {
      print(ex);
    }
  }

  Future updatePassword(password,token) async {
    try {
      EasyLoading.show(status: 'loading...');
      var url = Uri.parse("$firsturl/loginrestro/updatePassword");
      var res = await http.post(url,  headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
             'x-auth-token': token
          },
          body: json.encode({
            'password': password,
          })
          );

      if (res.statusCode == 200) {
        print(res.body);
        EasyLoading.dismiss();
        passwordupdated=true;
        userDetails=res.body;
        notifyListeners();
        return res.body;
      }
      print(res.body);
      EasyLoading.dismiss();
      passwordupdated=false;
      notifyListeners();
      return null;
    } catch (ex) {
      EasyLoading.dismiss();
      print(' excpnwa $ex');
    }
  }

Future updateStatus(id,val,token)async{
var url = Uri.parse("$firsturl/registerRestro/changeStatus/$id/$val");
  EasyLoading.show(status: 'loading...');
     // var url = Uri.parse("$firsturl/loginrestro/updatePassword");
      var res = await http.post(url,  headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
             'x-auth-token': token
          },);
        if(res.statusCode==200){
          EasyLoading.dismiss();
          return res.body;
        }
        EasyLoading.dismiss();
        return null;

  }
}
