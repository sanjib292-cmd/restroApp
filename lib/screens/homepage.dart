import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/loginRestro.dart';
import 'package:restro_app/backendApi/orderBackend.dart';
import 'package:restro_app/designs/customAlertdilog.dart';
import 'package:restro_app/screens/activeOrders.dart';
import 'package:restro_app/screens/addoreditmenu.dart';
import 'package:restro_app/screens/loginscreen.dart';
import 'package:restro_app/screens/pastOrders.dart';
import 'package:restro_app/screens/restroAccount.dart';
import 'package:restro_app/screens/restroMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  var userDetails;
  getUserdetails() async {
    print('this1');
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var userdetails = sharedPreferences.getString('Account Details');
    print('rnd $userdetails');
    setState(() {
      userDetails = userdetails;
    });
  }

  Future ifTokennull() async {
    print('this2');
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (sharedPreferences.getString('Account Details') == null) {
      print('this trig');
      showDialog(
          context: context,
          builder: (con) {
            return CustomDialogBox(
              title: "Token expired",
              descriptions:
                  """Please login to acess your account and manage orders...""",
             // text: "Login",
              img: '${Jwt.parseJwt(userDetails)['imgurl']}',
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

  checkIftokenExp() async {
    print('this3');
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    print(JwtDecoder.getExpirationDate(
        sharedPreferences.getString('Account Details').toString()));
    if (JwtDecoder.isExpired(
        sharedPreferences.getString('Account Details').toString())) {
      //final pref = await SharedPreferences.getInstance();
      await sharedPreferences.clear();
      showDialog(
          context: context,
          builder: (con) {
            return CustomDialogBox(
              title: "Session timeout",
              descriptions:
                  """Please login to acess your account and manage orders...""",
             // text: "Login",
            );
            // AlertDialog(
            //     title: Text('Token Expired Please Log in..'),
            //     content: TextButton(
            //       child: Text('Login'),
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //     ));
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

      //valueNotifier.value = _pcm; //provider
      //setState

    }
  }

  int currentIndex = 0;
  @override
  void initState() {
    getUserdetails();
    //ifTokennull();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('weare in home $userDetails');
    ifTokennull();
    checkIftokenExp();

    final restroLogin = Provider.of<LoginRestro>(context, listen: false);
    Map<String, dynamic> payload = Jwt.parseJwt(userDetails);

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
            userDetails: userDetails,
          )),
      AddorEditMenu(
        token: userDetails,
        payload: payload,
      ),
      ChangeNotifierProvider(
          create: (BuildContext context) {
            return LoginRestro();
          },
          child: RestroMenu(payLoad: payload, token: userDetails)),
      Pastorders(),
      ChangeNotifierProvider(
          create: (BuildContext context) {
            return LoginRestro();
          },
          child: ProfileApp(userDetails: userDetails,)),
    ];
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: AppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        "Restaurent is",
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      const SizedBox(
                        width: 5,
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
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      value: snapshot.data['isOpen']);
                                }
                                print('${snapshot.data}tht');
                                return CircularProgressIndicator();
                              },
                            ),
                          ))
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
            bottomappbarItms(FontAwesomeIcons.calendarAlt, 'Add New Item'),
            bottomappbarItms(FontAwesomeIcons.edit, 'Edit Item'),
            bottomappbarItms(FontAwesomeIcons.pizzaSlice, 'Past Orders'),
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
        title: Text(txt));
  }
}
