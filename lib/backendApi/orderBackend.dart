import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpHeaders;

import 'package:flutter/material.dart' show BuildContext, ChangeNotifier;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:http/http.dart' as http;
import 'package:restro_app/designs/snakbar.dart';

class OrderBackend extends ChangeNotifier {
  var paycycleerror;
  StreamController _postsController = StreamController();

  String firsturl = 'https://mealtime7399.herokuapp.com';
  Future acceptOrder(orderid, token) async {
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
  Future gettendaysOrder(restroId, token) async {
    var url = Uri.parse("$firsturl/restropay/$restroId");
    EasyLoading.show(status: 'loading...');
    var res = await http.get(
      url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-auth-token': token
      },
    );
    if (res.statusCode == 200) {
      EasyLoading.dismiss();
      print(res.body);
      return jsonDecode(res.body);
    }
    paycycleerror = res.body;
    notifyListeners();

    return;
  }

  Future cancelOrder(orderid, token) async {
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

  getActiveOrders(restroid, token) async {
    var url = Uri.parse("$firsturl/orders/restroActiveorder/$restroid");
    EasyLoading.show(status: 'loading...');
    var res = await http.get(
      url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-auth-token': token
      },
    );
    if(res.statusCode==200){
      //print(res.body);
      EasyLoading.dismiss();
      return jsonDecode(res.body);
    }
    EasyLoading.dismiss();
    return null;
  }
}
