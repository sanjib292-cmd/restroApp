import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/loginRestro.dart';
import 'package:restro_app/screens/homepage.dart';
import 'package:restro_app/screens/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchLoc extends StatefulWidget {
  var token;
  FetchLoc({this.token});

  @override
  _FetchLocState createState() => _FetchLocState();
}

class _FetchLocState extends State<FetchLoc> {
  @override
  void initState() {
    print('init');
    onStart();
    super.initState();
  }

  void onStart() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var userdetails = sharedPreferences.getString('Account Details');
    // print('fuking $userdetails');
    if (userdetails != null) {
      Future.delayed(Duration(seconds: 5), () {
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (con) {
          return ChangeNotifierProvider(
            create: (BuildContext context) {
              return LoginRestro();
            },
            child: HomePage(userDetails:userdetails,),
          );
        }));
      });
    } else {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (con) {
          return ChangeNotifierProvider(
              create: (BuildContext context) {
                return LoginRestro();
              },
              child: LoginScreen());
        }));
      });
    }
    // print('null');
  }

  @override
  Widget build(BuildContext context) {
    // final locService = Provider.of<Location>(context);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('images/LOGO.png'),
              // height: 180,
              // width: 180,
              // decoration: BoxDecoration(
              //     image: DecorationImage(image: AssetImage('images/LOGO.png'))),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       'Delivering To',
            //       style: GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.w800),
            //     ),
            //     Hero(
            //       tag: 'icon',
            //       child: Icon(
            //         Icons.location_on,
            //         color: Colors.orange,
            //         size: 28,
            //       ),
            //     )
            //   ],
            // ),
            SizedBox(
              height: 25,
            ),
            // locService.adrs == null
            //     ? er == null
            //         ? Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Center(child: Text('Locating', style: GoogleFonts.poppins())),
            //               SizedBox(
            //                 width: 20,
            //               ),
            //               CircularProgressIndicator(),
            //             ],
            //           )
            //         : AlertDialog(
            //             title: Text(er),
            //           )
            //     : Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text(
            //                 locService.adrs?.subLocality ?? toString(),
            //                 style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 20),
            //               ),
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Text(
            //               locService.adrs?.addressLine ?? toString(),
            //               style: GoogleFonts.poppins(
            //                   fontSize: 16,
            //                   color: Colors.black.withOpacity(0.5)),
            //             ),
            //           ],
            //         ),
            //       ),
          ],
        )),
      ),
    );
  }
}
