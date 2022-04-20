import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class AddnEditMenu extends ChangeNotifier { 
  var sucessMsg;
  var errorMsg;
  var itminstocSucess;
  var itminStockFail;
  var uploadedSucess;
  var uploadedFail;
  String firsturl = 'https://mealtime7399.herokuapp.com';
  Future editItms(
      itmnam, price, itmdetails, typid, itmid, restroId, token) async {
    try {

      var url = Uri.parse("$firsturl/product/$typid/$itmid/$restroId");
      EasyLoading.show(status: 'loading...');
      var res = await http.put(url, 
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
            'x-auth-token': token
          },
          body: json.encode(
              {'itemName': itmnam, 'price': price, 'itmDetails': itmdetails}));
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        errorMsg = null;
        sucessMsg = res.body.toUpperCase();
        // userDetails = res.headers['x-auth-token'];
        notifyListeners();
        return res.body;
      }
      EasyLoading.dismiss();
      errorMsg = res.body;
      notifyListeners();
      return null;
    } catch (ex) {
      EasyLoading.dismiss();
      print(ex);
    }
  }

  Future editInStock(typid, itmid, restroId, token, inStock) async {
    try {
      var url = Uri.parse("$firsturl/product/$typid/$itmid/$restroId");
      EasyLoading.show(status: 'loading...');
      var res = await http.put(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
            //"Content-Type": "application/x-www-form-urlencoded",
            'x-auth-token': token
          },
          body: json.encode({'inStock': inStock}));
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        itminStockFail = null;
        itminstocSucess = res.body.toUpperCase();
        // userDetails = res.headers['x-auth-token'];
        notifyListeners();
        print(itminstocSucess ?? itminStockFail);
        return res.body;
      }
      EasyLoading.dismiss();
      itminStockFail = res.body;
      notifyListeners();
      return null;
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
  }

  Future addItems(token, id, itemName, bool isveg, imgUrl, price, foodtype,
      itmDetails, category) async {
    try {
      var url = Uri.parse("$firsturl/product");
      EasyLoading.show(status: 'loading...');
        var res = 
    await http.post(url,
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'x-auth-token': token
        },
        body: json.encode({
          'restroId':id,
          'itemName': itemName,
          'isveg': isveg,
          'foodtype':foodtype,
          'category':category,
          'itmImg':imgUrl,
          'price':price,
          'itmDetails':itmDetails 
        }));

        if (res.statusCode == 200) {
          EasyLoading.dismiss();
          uploadedSucess = res.body;
          uploadedFail = null;
          notifyListeners();
          print(uploadedSucess);
          return res.body;
        }
        EasyLoading.dismiss();
        uploadedSucess = null;
        uploadedFail = res.body;
        notifyListeners();
        print(uploadedFail);
        return null;
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      return;
    }
  }
}
