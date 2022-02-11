import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/loginRestro.dart';
import 'package:restro_app/screens/forgotpassword.dart';
import 'package:restro_app/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Timer? _timer;
  late double _progress;
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    // EasyLoading.removeCallbacks();
  }

  var phone;
  var password;
  bool _obsecure = true;


  void _toggle() {
    setState(() {
      _obsecure = !_obsecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    var fcmToken;
    final restroLogin = Provider.of<LoginRestro>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
          child: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
                image: DecorationImage(image: AssetImage('images/LOGO.png'))),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    // ignore: prefer_const_literals_to_create_immutables
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, .2),
                          blurRadius: 20.0,
                          offset: Offset(0, 10))
                    ]),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      child: TextField(
                        onChanged: (val) {
                          setState(
                            () {
                              phone = val;
                            },
                          );
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone number",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (val) =>
                            val!.length < 5 ? 'Password too short.' : null,
                        obscureText: _obsecure,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _obsecure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.purpleAccent,
                              ),
                              onPressed: () {
                                _toggle();
                              },
                            ),
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () async {
  
    String? token = await _firebaseMessaging.getToken();

 
                      await restroLogin.loginRestro(phone, password,token);
                      if (restroLogin.msg != null) {
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setBool(
                            'isUser', restroLogin.varifiedUser);
                        await sharedPreferences.setString(
                            'Account Details', restroLogin.userDetails);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (con) {
                            return ChangeNotifierProvider(
                              create: (BuildContext context) {
                                return LoginRestro();
                              },
                              child: HomePage(userDetails: restroLogin.userDetails,),
                            );
                          }));
                       
                      } else {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('${restroLogin.errorMsg}'),
                              );
                            });
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              // ignore: prefer_const_literals_to_create_immutables
                              colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ])),
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ChangeNotifierProvider(create: (BuildContext context) { return LoginRestro(); },
                      child: Forgotpass());
                    }));
                  }, child: Text('Forgot password?'))
                ],
              ),
            ],
          )
        ]),
      )),
    );
  }
}
