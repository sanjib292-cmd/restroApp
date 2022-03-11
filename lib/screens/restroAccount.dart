import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/loginRestro.dart';
import 'package:restro_app/screens/loginscreen.dart';
import 'package:restro_app/screens/privicypolicy.dart';
import 'package:restro_app/screens/terms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileApp extends StatefulWidget {
  var userDetails;
  ProfileApp({this.userDetails});
  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  Future getRestroById(id) async {
    var restroByid = Provider.of<LoginRestro>(context, listen: false);
    var restrodetails = await restroByid.getRestroDetails(id);
    print(id);
    return restrodetails;
  }

  Future todaysOrder(data) async {
    var formatter = new DateFormat('yyyy-MM-dd');
    List numbers = [];
    for (var i in data) {
      var orderDate = DateTime.parse(i['dateOrderd']);
      var currentDate = DateTime.now();
      print(i['dateOrderd']);
      if (orderDate.day == currentDate.day &&
          orderDate.month == currentDate.month &&
          orderDate.year == currentDate.year) {
        numbers.add(i);
      }
    }
    return numbers;
  }

   Future<void> launchsite(String url) async {
    if (!await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future totalearning(data) async {
    List numbers = [];
    for (var itm in data) {
      for (var x in itm['orderItems']) {
        numbers.add(x['price']);
      }
    }
    //print(numbers);
    return numbers;
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat.yMMMMd('en_US').add_jm();
    var formatter = new DateFormat('yyyy-MM-dd');
    var payload = Jwt.parseJwt(widget.userDetails);
    var totatEarn;

    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getRestroById(payload['id']),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            }
//print(snapshot.data);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.redAccent, Colors.pinkAccent])),
                    child: Container(
                      width: double.infinity,
                      height: 350.0,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 52,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  snapshot.data['imgurl'],
                                ),
                                radius: 50.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              snapshot.data['name'],
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.white,
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 22.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Complete",
                                            style: GoogleFonts.poppins(
                                              color: Colors.redAccent,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            '${snapshot.data['completedOrders'].length}',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.pinkAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Canceled",
                                            style: GoogleFonts.poppins(
                                              color: Colors.redAccent,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            '${snapshot.data['canceledOrder'].length}',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.pinkAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Active",
                                            style: GoogleFonts.poppins(
                                              color: Colors.redAccent,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // dateFormat.format(DateTime.parse(activeOrder[ind]['dateOrderd']).toLocal())
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            snapshot.data['activeOrders'].length
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.pinkAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16.0),
                    child: ExpansionTile(
                                          //initiallyExpanded: true,
                                          tilePadding: EdgeInsets.zero,
                                          //childrenPadding: ,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return Privicypolicy();
                                                }));
                                              },
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text('Privacy policy',
                                                      style: GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600))),
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return Termscondition();
                                                }));
                                              },
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text('Terms & Conditions',
                                                      style: GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600))),
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                launchsite(
                                                    'https://www.chefoo.in/');
                                              },
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text('About us',
                                                      style: GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600))),
                                            )
                                          ],
                                          title: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Explore',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w800),
                                              )),
                                        ),
                  ),
                ),
                Container(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 16.0),
                      child: Column(
                        children: [
                          ExpansionTile(
                                      //initiallyExpanded: true,
                                      title: Text(
                                        'Delivered orders',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green)),
                                      ),
                                      children: [
                                        Container(
                                          //height: MediaQuery.of(context).size.height,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              reverse: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: snapshot
                                                  .data['completedOrders']
                                                  .length,
                                              itemBuilder: (con, ind) {
                                                if (snapshot
                                                        .data['completedOrders']
                                                        .length ==
                                                    0) {
                                                  return Text(
                                                      'No past orders..');
                                                }
                                                //print(snp.data['activeOrders'][0]['shortOrderid']);
                                                final List activeOrder =
                                                    snapshot.data[
                                                        'completedOrders'];
                                                // activeOrder.sort((a, b) => dateFormat
                                                //     .format(DateTime.parse(b['dateOrderd']))
                                                //     .compareTo(dateFormat.format(
                                                //         DateTime.parse(a['dateOrderd']))));
                                                print(snapshot
                                                    .data['completedOrders']);
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            5,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    decoration: BoxDecoration(
                                                      border:
                                                          Border.all(width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      //color: Colors.orange[100],
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                              child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            4.0,
                                                                        left:
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6),
                                                                        image: DecorationImage(
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            image: NetworkImage('${activeOrder[ind]['restroName']['imgurl']}')),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            '${activeOrder[ind]['restroName']['name']}',
                                                                            style:
                                                                                GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                50,
                                                                          ),
                                                                          Text(
                                                                            '${activeOrder[ind]['shortOrderid']}',
                                                                            style:
                                                                                GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        '${activeOrder[ind]['orderStatus']}',
                                                                        style: GoogleFonts.poppins(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.green),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )),
                                                          //flex: 4,
                                                        ),
                                                        // Divider(thickness: 1,),
                                                        Expanded(
                                                            //flex: 5,
                                                            child: Container(
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child: ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: activeOrder[ind]['orderItems'].length > 1 ? null : NeverScrollableScrollPhysics(),
                                                                      // scrollDirection:
                                                                      //     Axis.vertical,
                                                                      itemCount: activeOrder[ind]['orderItems'].length,
                                                                      itemBuilder: (con, indx) {
                                                                        return Padding(
                                                                          padding:
                                                                              EdgeInsets.all(4),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 15,
                                                                                    width: 15,
                                                                                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage(activeOrder[ind]['orderItems'][indx]['item']['isveg'] ? 'images/veg.png' : 'images/non-veg.png'))),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    '${activeOrder[ind]['orderItems'][indx]['quantity'].toString()}x ',
                                                                                    style: GoogleFonts.poppins(),
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                  Text(
                                                                                    '${activeOrder[ind]['orderItems'][indx]['item']['itemName']}',
                                                                                    style: GoogleFonts.poppins(),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }),
                                                                ),
                                                              ),
                                                              Divider(
                                                                thickness: 0.5,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            6.0,
                                                                        right:
                                                                            6.0),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          '${dateFormat.format(DateTime.parse(activeOrder[ind]['dateOrderd']).toLocal())}',
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 12,
                                                                              color: Colors.black.withOpacity(0.6)),
                                                                        ),
                                                                        // Row(
                                                                        //   children: [
                                                                        //      Text(
                                                                        //             'Earn: ',
                                                                        //             style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.green),
                                                                        //           ),
                                                                        //     SizedBox(
                                                                        //       width: 5,
                                                                        //     ),
                                                                        //     Text(
                                                                        //       '₹${activeOrder[ind]['delboyCharge']}',
                                                                        //       style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.green),
                                                                        //     ),
                                                                        //   ],
                                                                        // ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                        ],
                      )),
                ),
                Container(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 16.0),
                      child: Column(
                        children: [
                          ExpansionTile(
                                      //initiallyExpanded: true,
                                      title: Text(
                                        'Canceled orders',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red)),
                                      ),
                                      children: [
                                        Container(
                                          //height: MediaQuery.of(context).size.height,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              reverse: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: snapshot
                                                  .data['canceledOrder'].length,
                                              itemBuilder: (con, ind) {
                                                if (snapshot
                                                        .data['canceledOrder']
                                                        .length ==
                                                    0) {
                                                  return Text(
                                                      'No past orders..');
                                                }
                                                final List activeOrder =
                                                    snapshot
                                                        .data['canceledOrder'];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            5,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    decoration: BoxDecoration(
                                                      border:
                                                          Border.all(width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      //color: Colors.orange[100],
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                              child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            4.0,
                                                                        left:
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6),
                                                                        image: DecorationImage(
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            image: NetworkImage('${activeOrder[ind]['restroName']['imgurl']}')),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            '${activeOrder[ind]['restroName']['name']}',
                                                                            style:
                                                                                GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                50,
                                                                          ),
                                                                          Text(
                                                                            '${activeOrder[ind]['shortOrderid']}',
                                                                            style:
                                                                                GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        'Canceled',
                                                                        style: GoogleFonts.poppins(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.red),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )),
                                                          //flex: 4,
                                                        ),
                                                        // Divider(thickness: 1,),
                                                        Expanded(
                                                            //flex: 5,
                                                            child: Container(
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child: ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: activeOrder[ind]['orderItems'].length > 1 ? null : NeverScrollableScrollPhysics(),
                                                                      // scrollDirection:
                                                                      //     Axis.vertical,
                                                                      itemCount: activeOrder[ind]['orderItems'].length,
                                                                      itemBuilder: (con, indx) {
                                                                        return Padding(
                                                                          padding:
                                                                              EdgeInsets.all(4),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 15,
                                                                                    width: 15,
                                                                                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage(activeOrder[ind]['orderItems'][indx]['item']['isveg'] ? 'images/veg.png' : 'images/non-veg.png'))),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    '${activeOrder[ind]['orderItems'][indx]['quantity'].toString()}x ',
                                                                                    style: GoogleFonts.poppins(),
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                  Text(
                                                                                    '${activeOrder[ind]['orderItems'][indx]['item']['itemName']}',
                                                                                    style: GoogleFonts.poppins(),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }),
                                                                ),
                                                              ),
                                                              Divider(
                                                                thickness: 0.5,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            6.0,
                                                                        right:
                                                                            6.0),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          '${dateFormat.format(DateTime.parse(activeOrder[ind]['dateOrderd']).toLocal())}',
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 12,
                                                                              color: Colors.black.withOpacity(0.6)),
                                                                        ),
                                                                       
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      padding: EdgeInsets.all(8),
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              //times.reduce((a, b) => a + b, 0)
                              Text(
                                'Total sell on app:',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              FutureBuilder(
                                  future: totalearning(
                                      snapshot.data['completedOrders']),
                                  builder: (context, AsyncSnapshot snap) {
                                    if (snap.data == null) {
                                      return CircularProgressIndicator();
                                    }
                                    totatEarn = snap.data
                                        .reduce((val, ele) => val + ele);
                                    return Text(
                                      '₹' + totatEarn.toString(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    );
                                  })
                            ],
                          ),
                          Row(
                            children: [
                              Text('Total complete orders: ',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Text(
                                snapshot.data['completedOrders'].length
                                    .toString(),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              )
                            ],
                          ),
                          Row(
                            //dateFormat.format(DateTime.parse(activeOrder[ind]['dateOrderd']).toLocal())
                            children: [
                              Text("Today's orders: ",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              //ListView.builder(itemBuilder: (con,ind){})
                              FutureBuilder(
                                  future: todaysOrder(
                                      snapshot.data['completedOrders']),
                                  builder: (context, AsyncSnapshot snip) {
                                    print(snip.data);
                                    if (snip.data == null) {
                                      return CircularProgressIndicator();
                                    }
                                    print(snip.data);
                                    return Text(
                                      '${snip.data.length}',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    );
                                  })
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Ratings: ',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Text(
                                  '${snapshot.data['rating'].fold(0, (avg, ele) => avg + ele / snapshot.data['rating'].length).toStringAsFixed(1)}(${snapshot.data['rating'].length})',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22))
                            ],
                          )
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () async {
//SharedPreferences sp=await SharedPreferences.getInstance();
                      final SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setBool('isUser', false);
                      await sharedPreferences.remove('Account Details');
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider(
                            create: (BuildContext context) {
                              return LoginRestro();
                            },
                            child: LoginScreen());
                      }));
                    },
                    child: Text('LOGOUT',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    color: Colors.red,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
