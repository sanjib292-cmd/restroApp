import 'dart:async';
import 'dart:io' show HttpHeaders;

import 'package:flutter/material.dart' show BuildContext, ChangeNotifier;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:http/http.dart' as http;
import 'package:restro_app/designs/snakbar.dart';

class OrderBackend extends ChangeNotifier {
  StreamController _postsController=StreamController();

  String firsturl = 'http://192.168.0.103:5000';
  Future acceptOrder( orderid,token) async {
    EasyLoading.show(status: 'loading...');
    var url = Uri.parse("$firsturl/orders/$orderid");
    var res = await http.put(
      url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-auth-token': token
      },
    );
    if (res.statusCode == 200) {
      EasyLoading.dismiss();
      print('${res.body} ordr');
      return res.body;
    } else {
      EasyLoading.dismiss();
      print('err');
      return null;
    }
  }

  // Future orderIsready(orderid,token,BuildContext context)async{
  //    var url = Uri.parse("$firsturl/orders/ready/$orderid");
  //   var res = await http.put(
  //     url,
  //     headers: <String, String>{
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       'x-auth-token': token
  //     },
  //   );
  //   if (res.statusCode == 200) {
  //     print('${res.body} ordr');
  //     snackBar('${res.body}', context);
  //     return res.body;
  //   } else {
  //     print('err');
  //     return null;
  //   }
  // }


  Future cancelOrder( orderid,token) async {
    var url = Uri.parse("$firsturl/orders/cancel/$orderid");
    EasyLoading.show(status: 'loading...');
    var res = await http.put(
      url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-auth-token': token
      },
    );
    if (res.statusCode == 200) {
      EasyLoading.dismiss();
      print('${res.body} ordr');
      return res.body;
    } else {
      EasyLoading.dismiss();
      print('err');
      return null;
    }
  }

}
