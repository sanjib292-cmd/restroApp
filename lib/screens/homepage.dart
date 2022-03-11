
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/loginRestro.dart';
import 'package:restro_app/backendApi/orderBackend.dart';
import 'package:restro_app/designs/customAlertdilog.dart';
import 'package:restro_app/designs/snakbar.dart';
import 'package:restro_app/screens/activeOrders.dart';
import 'package:restro_app/screens/addoreditmenu.dart';
import 'package:restro_app/screens/loginscreen.dart';
import 'package:restro_app/screens/pastOrders.dart';
import 'package:restro_app/screens/paymentspage.dart';
import 'package:restro_app/screens/restroAccount.dart';
import 'package:restro_app/screens/restroMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  var userDetails;
  HomePage({this.userDetails});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  checkInernetonnection()async{
  //final bool isConnected = await InternetConnectionChecker().hasConnection;
  final StreamSubscription<InternetConnectionStatus> listener =
      InternetConnectionChecker().onStatusChange.listen(
    (InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          break;
        case InternetConnectionStatus.disconnected:
          return snackBar('Internet not connected', context);

      }
    },
  );

  // close listener after 30 seconds, so the program doesn't run forever
  await Future<void>.delayed(const Duration(seconds: 30));
  await listener.cancel();
  }
  
  // ignore: unused_field
  // var userDetails;
  // getUserdetails() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   var userdetails = sharedPreferences.getString('Account Details');
  //   //print('rnd $userdetails');
  //   setState(() {
  //     userDetails = userdetails;
  //   });
  // }

  Future ifTokennull() async {
    //print('this2');
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (sharedPreferences.getString('Account Details') == 'null') {
      //print('this trig');
      showDialog(
          context: context,
          builder: (con) {
            return CustomDialogBox(
              title: "Token expired",
              descriptions:
                  """Please login to acess your account and manage orders...""",
             // text: "Login",
              img: '${Jwt.parseJwt(widget.userDetails)['imgurl']}',
            );
          });
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ChangeNotifierProvider(
              create: (BuildContext context) {
                return LoginRestro();
              },
              child: LoginScreen());
        }));
      });
    }
  }

  // checkIftokenExp() async {
  //   print('this3');
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   // print(JwtDecoder.getExpirationDate(
  //   //     sharedPreferences.getString('Account Details').toString()));
  //   if (JwtDecoder.isExpired(
  //       sharedPreferences.getString('Account Details').toString())) {
  //     //final pref = await SharedPreferences.getInstance();
  //     await sharedPreferences.clear();
  //     showDialog(
  //         context: context,
  //         builder: (con) {
  //           return CustomDialogBox(
  //             title: "Session timeout",
  //             descriptions:
  //                 """Please login to acess your account and manage orders...""",
  //            // text: "Login",
  //           );
  //         });
  //     Future.delayed(Duration(seconds: 1), () {
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context) {
  //         return ChangeNotifierProvider(
  //             create: (BuildContext context) {
  //               return LoginRestro();
  //             },
  //             child: LoginScreen());
  //       }));
  //     });

  //     //valueNotifier.value = _pcm; //provider
  //     //setState

  //   }
  // }

  int currentIndex = 0;
  @override
  void initState() {
    //getUserdetails();
    ifTokennull();
    //ifTokennull();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkInernetonnection();
    ifTokennull();
    //print('weare in home $userDetails');
   
    //checkIftokenExp();

    final restroLogin = Provider.of<LoginRestro>(context, listen: false);
    Map<String, dynamic> payload = Jwt.parseJwt(widget.userDetails);
    final List<Widget> _children = [
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (BuildContext context) {
              return LoginRestro();
            }),
            ChangeNotifierProvider(create: (BuildContext context) {
              return OrderBackend();
            })
          ],
          //child: ChangeNotifierProvider(create: (BuildContext context) { return LoginRestro(); },
          child: ActiveOrders(
            userDetails: widget.userDetails,
          )),
      ChangeNotifierProvider(
        create: (BuildContext context) { return LoginRestro(); },
        child: AddorEditMenu(
          token: widget.userDetails,
          //payload: payload,
        ),
      ),
      ChangeNotifierProvider(
          create: (BuildContext context) {
            return LoginRestro();
          },
          child: RestroMenu(payLoad: payload, token: widget.userDetails)),
    //  Pastorders(),
      ChangeNotifierProvider(
          create: (BuildContext context) {
            return LoginRestro();
          },
          child: ProfileApp(userDetails: widget.userDetails,)),
    ];
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backwardsCompatibility: false,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(
                            "Accept Order",
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        
                 
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Transform.scale(
                                scale: 1.5,
                                child: FutureBuilder(
                                  future:
                                      restroLogin.getRestroDetails(payload['id']),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.data != null) {
                                      print(snapshot.data['name']);
                                      return Switch(
                                          activeColor: Colors.blue,
                                          activeTrackColor: Colors.green,
                                          inactiveThumbColor: Colors.white60,
                                          inactiveTrackColor: Colors.red,
                                          onChanged: (value) async{
                                           await restroLogin.updateStatus(payload['id'],value,widget.userDetails);
                                            setState(() {});
                                          },
                                          value: snapshot.data['isOpen']);
                                    }
                                     return Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator());
                                  },
                                ),
                              ))
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (con){
                        return ChangeNotifierProvider(create: (BuildContext context) { return OrderBackend(); },
                        child: Paymentspage(restroId: payload['id'],token: widget.userDetails,));
                      }));
                        },
                        child: Text('Payments',style: GoogleFonts.poppins(color: Colors.blue,fontWeight: FontWeight.w600),)),

                      // MaterialButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (con){
                      //   return ChangeNotifierProvider(create: (BuildContext context) { return OrderBackend(); },
                      //   child: Paymentspage(restroId: payload['id'],token: widget.userDetails,));
                      // }));},child: Text('Payments',style: GoogleFonts.poppins(color: Colors.blue,fontWeight: FontWeight.bold),),)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
              ],
            ),
            elevation: 2,
            backgroundColor: Colors.white,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: (int indx) {
            setState(() {
              currentIndex = indx;
            });
          },
          currentIndex: currentIndex,
          items: [
            bottomappbarItms(FontAwesomeIcons.utensils, 'Active Orders'),
            bottomappbarItms(FontAwesomeIcons.calendarAlt, 'Add New'),
            bottomappbarItms(FontAwesomeIcons.edit, 'Edit Item'),
            //bottomappbarItms(FontAwesomeIcons.pizzaSlice, 'Past Orders'),
            bottomappbarItms(FontAwesomeIcons.user, 'Account'),
          ],
        ),
        body: _children[currentIndex]);
  }

  BottomNavigationBarItem bottomappbarItms(IconData icn, String txt) {
    return BottomNavigationBarItem(
        icon: FaIcon(
          icn,
          size: 20,
        ),
        label: txt);
  }
}
