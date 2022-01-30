

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/loginRestro.dart';
import 'package:restro_app/designs/snakbar.dart';
import 'package:restro_app/screens/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Updatepassword extends StatefulWidget {
  var token;
  Updatepassword({this.token});

  @override
  _UpdatepasswordState createState() => _UpdatepasswordState();
}

class _UpdatepasswordState extends State<Updatepassword> {
  var newpass, confirmpass, er;
  @override
  Widget build(BuildContext context) {
    var updatePass = Provider.of<LoginRestro>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    newpass = val;
                  });
                },
                obscureText: true,
                decoration: InputDecoration(hintText: 'Enter new password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    confirmpass = val;
                  });
                },
                decoration: InputDecoration(hintText: 'Confirm password'),
              ),
            ),
            MaterialButton(child: Text('Update password'),
            color: Colors.green,
              onPressed: () async {
              if (newpass == confirmpass) {
                if(confirmpass.length<6){
                  snackBar('Password must be atleast 6Digit', context);
                }
                await updatePass.updatePassword(confirmpass, widget.token);
                if (updatePass.passwordupdated) {
                  snackBar('Password updated', context);
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setBool('isUser', true);
                  await sharedPreferences.setString(
                      'Account Details', widget.token);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (con) {
                    return FetchLoc();
                  }));
                }
                snackBar('Try again', context);
              }
            })
          ],
        ),
      ),
    );
  }
}
