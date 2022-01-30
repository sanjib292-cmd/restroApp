import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/loginRestro.dart';
import 'package:restro_app/backendApi/orderBackend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ActiveOrders extends StatefulWidget {
  var userDetails;
  ActiveOrders({this.userDetails});

  @override
  _ActiveOrdersState createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends State<ActiveOrders>
    with WidgetsBindingObserver {
  bool inForground = true;

  getrestroActiveOrder(id) async {
    var restroDetails = Provider.of<LoginRestro>(context, listen: false);

    var activeordr = await restroDetails.getRestroDetails(id);
    return activeordr;
  }

  Stream getRandomNumberFact(id) async* {
    yield* Stream.periodic(Duration(seconds: 2), (_) {
      return getrestroActiveOrder(id);
    }).asyncMap((event) async => await event);
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat.yMMMMd('en_US').add_jm();
    var payload = Jwt.parseJwt(widget.userDetails);

    return Scaffold(
      body: Column(
        children: [
          StreamBuilder(
            stream: getRandomNumberFact(payload['id']),
            //initialData: {'null':'null'},
            builder: (con, AsyncSnapshot snp) {
              if (snp.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[300]!,
                      child: Card(
                        elevation: 15,
                        child: ClipPath(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color: Colors.grey, width: 4))),
                          ),
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3))),
                        ),
                      ),
                    );
                  },
                );
              } else if (snp.connectionState == ConnectionState.none) {
                return Center(
                  child: Text(
                    'No active orders',
                    style: GoogleFonts.poppins(),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                    itemCount: snp.data['activeOrders'].length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (con, ind) {
                      final List activeOrder = snp.data['activeOrders'];
                      activeOrder.sort((a, b) => dateFormat
                          .format(DateTime.parse(b['dateOrderd']))
                          .compareTo(dateFormat
                              .format(DateTime.parse(a['dateOrderd']))));
                      return Container(
                        height: MediaQuery.of(context).size.height / 4,
                        // width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Order id: ${activeOrder[ind]['shortOrderid']}',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Number of orders: ${activeOrder[ind]['orderItems'].length}',
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                child: Container(
                                  //height:
                                  // MediaQuery.of(context).size.height / 9,
                                  //width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          activeOrder[ind]['orderItems'].length,
                                      itemBuilder: (con, indx) {
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Stack(
                                            children: [
                                              activeOrder[ind]['orderStatus'] ==
                                                      "Ready"
                                                  ? Positioned(
                                                      top: 0,
                                                      right: -4,
                                                      // bottom: 5,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 55,
                                                                right: 50),
                                                        child: Banner(
                                                          color: Colors.green,
                                                          message: "Ready",
                                                          location:
                                                              BannerLocation
                                                                  .topStart,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              OutlineButton(
                                                borderSide: BorderSide(
                                                  width: 2.0,
                                                  color: Colors.orange,
                                                  style: BorderStyle.solid,
                                                ),
                                                onPressed: () {},
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        //MaterialBanner(backgroundColor: Colors.indigo, content: Text('order status'), actions: [TextButton(onPressed: (){}, child: Text('lol'))]),
                                                        Text(
                                                          'Item: ${activeOrder[ind]['orderItems'][indx]['item']['itemName']}',
                                                          style: GoogleFonts
                                                              .poppins(),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            'qty: ${activeOrder[ind]['orderItems'][indx]['quantity'].toString()}',
                                                            style: GoogleFonts
                                                                .poppins(),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                            'price: ${activeOrder[ind]['orderItems'][indx]['price'].toString()}',
                                                            style: GoogleFonts
                                                                .poppins()),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          '${dateFormat.format(DateTime.parse(activeOrder[ind]['dateOrderd']).toLocal())}',
                                                          style: GoogleFonts
                                                              .poppins(),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),

                              activeOrder[ind]['orderStatus'] ==
                                          "Preapration" ||
                                      activeOrder[ind]['orderStatus'] ==
                                          "Canceled" ||
                                      activeOrder[ind]['orderStatus'] ==
                                          "Accepted by delivery partner" ||
                                      activeOrder[ind]['orderStatus'] ==
                                          "Delivery partner reached at Restraunt" ||
                                      activeOrder[ind]['orderStatus'] ==
                                          "Delivered"
                                  ? Text(
                                      "${activeOrder[ind]['orderStatus']}",style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MaterialButton(
                                          onPressed: () async {
                                            FlutterRingtonePlayer.stop();
                                            final pref = await SharedPreferences
                                                .getInstance();
                                            final token = pref
                                                .getString('Account Details');
                                            print(
                                                '${payload['id']} ${snp.data['activeOrders'][ind]['_id']}');
                                            var orderAccept =
                                                Provider.of<OrderBackend>(
                                                    context,
                                                    listen: false);
                                            await orderAccept.acceptOrder(
                                                activeOrder[ind]['_id'], token);
                                          },
                                          child: Text(
                                            'Accept',
                                            style: GoogleFonts.poppins(
                                                color: Colors.white),
                                          ),
                                          color: Colors.green,
                                        ),
                                        // CircularCountDownTimer(
                                        //   duration: 300,
                                        //   initialDuration: 5,
                                        //   controller:
                                        //       CountDownController(),
                                        //   width: 25,
                                        //   height: 25,
                                        //   ringColor: Colors.blueGrey,
                                        //   ringGradient: null,
                                        //   fillColor: Colors.purpleAccent,
                                        //   fillGradient: null,
                                        //   backgroundColor:
                                        //       Colors.purple[500],
                                        //   backgroundGradient: null,
                                        //   strokeWidth: 5.0,
                                        //   strokeCap: StrokeCap.round,
                                        //   textStyle: TextStyle(
                                        //       fontSize: 15.0,
                                        //       color: Colors.white,
                                        //       fontWeight:
                                        //           FontWeight.bold),
                                        //   textFormat:
                                        //       CountdownTextFormat.S,
                                        //   isReverse: true,
                                        //   isReverseAnimation: false,
                                        //   isTimerTextShown: true,
                                        //   autoStart: true,
                                        //   onStart: () {
                                        //     FlutterRingtonePlayer.play(
                                        //       android:
                                        //           AndroidSounds.alarm,
                                        //       ios: IosSounds.glass,
                                        //       looping:
                                        //           false, // Android only - API >= 28
                                        //       volume:
                                        //           1, // Android only - API >= 28
                                        //       asAlarm:
                                        //           true, // Android only - all APIs
                                        //     );
                                        //   },
                                        //   onComplete: () async {
                                        //     final pref =
                                        //         await SharedPreferences
                                        //             .getInstance();
                                        //     final token = pref.getString(
                                        //         'Account Details');
                                        //     FlutterRingtonePlayer.stop();
                                        //     var orderAccept =
                                        //         Provider.of<OrderBackend>(
                                        //             context,
                                        //             listen: false);
                                        //     await orderAccept.cancelOrder(
                                        //         activeOrder[ind]['_id'],
                                        //         token);
                                        //   },
                                        // ),
                                        MaterialButton(
                                          onPressed: () async {
                                            final pref = await SharedPreferences
                                                .getInstance();
                                            final token = pref
                                                .getString('Account Details');
                                            print(
                                                '${payload['id']} ${activeOrder[ind]['_id']}');
                                            var orderAccept =
                                                Provider.of<OrderBackend>(
                                                    context,
                                                    listen: false);
                                            await orderAccept.cancelOrder(
                                                activeOrder[ind]['_id'], token);
                                            FlutterRingtonePlayer.stop();
                                          },
                                          child: Text('Cancel',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white)),
                                          color: Colors.red,
                                        ),
                                      ],
                                    )
                              // Text('Address :${geoCode.reverseGeocoding(latitude: snp.data['activeOrders'][ind]['cord']['lat'], longitude: snp.data['activeOrders'][ind]['cord']['lon'])}')
                            ],
                          ),
                        ),
                      );
                    }),
              );
            },
          ),
          //Text('hlo'),
        ],
      ),
      //body:
      //     StreamBuilder(
      //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      //     return ListView.builder(itemBuilder: (con,ind){
      //       return Container();
      //     });
      //   },
      // )
    );
  }
}
