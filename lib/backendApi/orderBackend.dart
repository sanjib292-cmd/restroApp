import 'dart:async';
import 'dart:io' show HttpHeaders;

import 'package:flutter/material.dart' show ChangeNotifier;

import 'package:http/http.dart' as http;

class OrderBackend extends ChangeNotifier {
  StreamController _postsController=StreamController();

  String firsturl = 'http://192.168.0.103:5000';
  Future acceptOrder( orderid,token) async {
    var url = Uri.parse("$firsturl/orders/$orderid");
    var res = await http.put(
      url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-auth-token': token
      },
    );
    if (res.statusCode == 200) {
      print('${res.body} ordr');
      return res.body;
    } else {
      print('err');
      return null;
    }
  }


  Future cancelOrder( orderid,token) async {
    var url = Uri.parse("$firsturl/orders/cancel/$orderid");
    var res = await http.put(
      url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-auth-token': token
      },
    );
    if (res.statusCode == 200) {
      print('${res.body} ordr');
      return res.body;
    } else {
      print('err');
      return null;
    }
  }

}
