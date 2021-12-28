import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/loginRestro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestroAccount extends StatefulWidget {
  var user;
  RestroAccount({this.user});

  @override
  _RestroAccountState createState() => _RestroAccountState();
}

class _RestroAccountState extends State<RestroAccount> {
  TextStyle accPage =
      GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    var payload = Jwt.parseJwt(widget.user);
    final restroLogin = Provider.of<LoginRestro>(context, listen: false);
    // Future getInf() async {
    //   await restroLogin.getRestroDetails(payload['id']);
    // }

    print('res acc');
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
                child: Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 57,
              child: CircleAvatar(
                backgroundImage: NetworkImage('${payload['imgurl']}'),
                radius: 55,
              ),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Text('Name: ${payload['name']}', style: accPage)),
          Align(
              alignment: Alignment.center,
              child: Text('Address: ${payload['address']['city']}',
                  style: accPage)),
          Align(
              alignment: Alignment.center,
              child: Text('All Orders: ', style: accPage)),
          Padding(
            padding: const EdgeInsets.only(left: 45.0),
            child: Text('Preaption Time: ${payload['preaprationTime']}',
                style: accPage),
          ),
          Text('Active Orders: ', style: accPage),
          SizedBox(height: 50),
          Container(
            height: 40,
            width: 120,
            color:Colors.red,
            child: TextButton(
              child: Text('Logout',style: GoogleFonts.poppins(color: Colors.white)),
              onPressed: () async {
                final pref = await SharedPreferences.getInstance();
                print(pref.getBool('isUser'));
                await pref.clear();
                
              },
            ),
          )
        ],
      ),
    ))));
  }
}
