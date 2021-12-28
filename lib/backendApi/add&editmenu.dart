import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart' show ChangeNotifier;
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
  String firsturl = 'http://192.168.0.103:5000';
  Future editItms(
      itmnam, price, itmdetails, typid, itmid, restroId, token) async {
    try {
      var url = Uri.parse("$firsturl/product/$typid/$itmid/$restroId");
      var res = await http.put(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
            'x-auth-token': token
          },
          body: json.encode(
              {'itemName': itmnam, 'price': price, 'itmDetails': itmdetails}));
      if (res.statusCode == 200) {
        errorMsg = null;
        sucessMsg = res.body.toUpperCase();
        // userDetails = res.headers['x-auth-token'];
        notifyListeners();
        return res.body;
      }
      errorMsg = res.body;
      notifyListeners();
      return null;
    } catch (ex) {
      print(ex);
    }
  }

  Future editInStock(typid, itmid, restroId, token, inStock) async {
    try {
      var url = Uri.parse("$firsturl/product/$typid/$itmid/$restroId");
      var res = await http.put(url,
          headers: <String, String>{
            HttpHeaders.contentTypeHeader: 'application/json',
            //"Content-Type": "application/x-www-form-urlencoded",
            'x-auth-token': token
          },
          body: json.encode({'inStock': inStock}));
      if (res.statusCode == 200) {
        itminStockFail = null;
        itminstocSucess = res.body.toUpperCase();
        // userDetails = res.headers['x-auth-token'];
        notifyListeners();
        print(itminstocSucess ?? itminStockFail);
        return res.body;
      }
      itminStockFail = res.body;
      notifyListeners();
      return null;
    } catch (e) {
      print(e);
    }
  }

  Future addItems(token, id, itemName, bool isveg, File file, price, foodtype,
      itmDetails, category) async {
    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    try {
      var url = Uri.parse("$firsturl/product");
      // var res = await http.post(url,
      //     headers: <String, String>{
      //       HttpHeaders.contentTypeHeader: 'application/json',
      //       'x-auth-token': token
      //     },
      var res = await http.MultipartRequest('POST', url);

      res.fields.addAll({
        'restroId': id,
        'itemName': itemName,
        'isveg': isveg.toString(),
        'price': price,
        'foodtype': foodtype,
        'category': category
      });
      var multipartFile = http.MultipartFile('itmImg', stream, length,
          filename: basename(file.path));
      res.files.add(multipartFile);
      res.headers.addAll(
          {"Content-type": "multipart/form-data", 'x-auth-token': token});
      try {
        var response = await http.Response.fromStream(await res.send());
        ;
        if (response.statusCode == 200) {
          uploadedSucess = response.body;
          uploadedFail = null;
          notifyListeners();
          print(uploadedSucess);
          return response;
        }
        uploadedSucess = null;
        uploadedFail = response.body.toUpperCase();
        notifyListeners();
        print(uploadedFail);
        return null;
      } on Exception catch (e) {
        print(e);
      }

      //     body: json.encode({
      //       'restroId': id,
      //       'itemName': itemName,
      //       'isveg': isveg,
      //       'itmImg': file,
      //       'price': price,
      //       'inStock': inStock,
      //       'foodtype': foodtype,
      //       'itmDetails': itmDetails,
      //       'category': category
      //     }));
      // if (res.statusCode == 200) {
      //   uploadedSucess = res.body;
      //   uploadedFail = null;
      //   notifyListeners();
      //   return res.body;
      // }
      // uploadedFail = res.body;
      // notifyListeners();
      // return null;
    } catch (e) {
      print(e);
    }
  }
}
