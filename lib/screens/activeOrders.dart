import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/loginRestro.dart';
import 'package:restro_app/backendApi/orderBackend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveOrders extends StatefulWidget {
  var userDetails;
  ActiveOrders({this.userDetails});

  @override
  _ActiveOrdersState createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends State<ActiveOrders>
    with WidgetsBindingObserver {
  bool inForground = true;

  Future getrestroActiveOrder(restroid, token) async {
    var orderAccept = Provider.of<OrderBackend>(context, listen: false);
    return await orderAccept.getActiveOrders(restroid, token);
  }

   Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+91'+phoneNumber,
    );
    await launch(launchUri.toString());
  }

  // Stream<int> getActiveorder(restroid, token) async* {
  //   var orderAccept = Provider.of<OrderBackend>(context, listen: false);
  //   yield* Stream.periodic(Duration(seconds: 15), (_) {
  //     //return orderAccept.getActiveOrders(restroid, token);
  //   }).asyncMap(
  //     (value)
  //      async {

  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat.yMMMMd('en_US').add_jm();
    var payload = Jwt.parseJwt(widget.userDetails);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          return await getrestroActiveOrder(payload['id'], widget.userDetails);
        },
        child: Container(
          child: ListView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: getrestroActiveOrder(
                          payload['id'], widget.userDetails),
                      //initialData: {'null':'null'},
                      builder: (con, AsyncSnapshot<dynamic> snp) {
                        if (snp.connectionState == ConnectionState.waiting) {
                          return ListView.builder(
                            reverse: true,
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
                                      height:
                                          MediaQuery.of(context).size.height /
                                              6,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 4))),
                                    ),
                                    clipper: ShapeBorderClipper(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3))),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (snp.connectionState ==
                            ConnectionState.none) {
                          return Center(
                            child: Text(
                              'No active orders',
                              style: GoogleFonts.poppins(),
                            ),
                          );
                        }else if(snp.data==null){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        // print(snp.data);

                        return Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                reverse: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: snp.data.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (con, ind) {
                                    final List activeOrder = snp.data;
                                    // activeOrder.sort((a, b) => dateFormat
                                    //     .format(DateTime.parse(b['dateOrderd']))
                                    //     .compareTo(dateFormat.format(
                                    //         DateTime.parse(a['dateOrderd']))));
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Order id: ${activeOrder[ind]['shortOrderid']}',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'Number of orders: ${activeOrder[ind]['orderItems'].length}',
                                                            style: GoogleFonts
                                                                .poppins(),
                                                          ),
                                                        ],
                                                      )),
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            7,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: activeOrder[
                                                                    ind]
                                                                ['orderItems']
                                                            .length,
                                                        itemBuilder:
                                                            (con, indx) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Stack(
                                                              children: [
                                                                activeOrder[ind]
                                                                            [
                                                                            'orderStatus'] ==
                                                                        "Preapration"
                                                                    ? Positioned(
                                                                        top: 0,
                                                                        right:
                                                                            -4,
                                                                        // bottom: 5,
                                                                        child:
                                                                            Container(
                                                                          padding: EdgeInsets.only(
                                                                              top: 55,
                                                                              right: 50),
                                                                          child:
                                                                              Banner(
                                                                            color:
                                                                                Colors.green,
                                                                            message:
                                                                                "${activeOrder[ind]['orderStatus']}",
                                                                            location:
                                                                                BannerLocation.topStart,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                                TextButton(
                                                                  
                                                                  onPressed:
                                                                      () {},
                                                                  child:
                                                                      Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              //MaterialBanner(backgroundColor: Colors.indigo, content: Text('order status'), actions: [TextButton(onPressed: (){}, child: Text('lol'))]),
                                                                              Text(
                                                                                'Item: ${activeOrder[ind]['orderItems'][indx]['item']['itemName']}',
                                                                                style: GoogleFonts.poppins(),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Align(
                                                                                alignment: Alignment.topLeft,
                                                                                child: Text(
                                                                                  'qty: ${activeOrder[ind]['orderItems'][indx]['quantity'].toString()}',
                                                                                  style: GoogleFonts.poppins(),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Text('price: ${activeOrder[ind]['orderItems'][indx]['price'].toString()}', style: GoogleFonts.poppins()),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Text(
                                                                                '${dateFormat.format(DateTime.parse(activeOrder[ind]['dateOrderd']).toLocal())}',
                                                                                style: GoogleFonts.poppins(),
                                                                              ),
                                                                            ],
                                                                          )),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                  ),

                                                  activeOrder[ind][
                                                                  'orderStatus'] ==
                                                              "Preapration" ||
                                                          activeOrder[ind][
                                                                  'orderStatus'] ==
                                                              "Canceled" 
                                                          
                                                      ? Container(
                                                          height: 0,
                                                          width: 0,
                                                        ):
                                                        activeOrder[ind][
                                                                  'orderStatus'] ==
                                                              "Accepted by delivery partner" ||
                                                          activeOrder[ind][
                                                                  'orderStatus'] ==
                                                              "Delivery partner reached at Restraunt" ||
                                                          activeOrder[ind][
                                                                  'orderStatus'] ==
                                                              "Delivered"?
                                                      Column(children: [
                                                        Row(
                                                          children: [
                                                            Text('Accepted by deliveryboy:', style: GoogleFonts
                                                                    .poppins(
                                                                      fontWeight: FontWeight.bold,
                                                                        color: Colors
                                                                            .black),),
                                                            Text('${activeOrder[ind][
                                                                  'delBoy']['name']}', style: GoogleFonts
                                                                    .poppins(
                                                                       fontWeight: FontWeight.bold,
                                                                        color: Colors
                                                                            .red),)
                                                          ],
                                                        ),
                                                        GestureDetector(
                                                          onTap: (){makePhoneCall('${activeOrder[ind][
                                                                    'delBoy']['phone']}');},
                                                          child: Row(
                                                            children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(FontAwesomeIcons.mobileAlt,size: 22,),
                                                                    Text('Call: ', style: GoogleFonts
                                                                          .poppins(
                                                                            fontWeight: FontWeight.bold,
                                                                              color: Colors
                                                                                  .black),),
                                                                  ],
                                                                ),
                                                              Text('${activeOrder[ind][
                                                                    'delBoy']['phone']}', style: GoogleFonts
                                                                      .poppins(
                                                                         fontWeight: FontWeight.bold,
                                                                          color: Colors
                                                                              .red),)
                                                            ],
                                                          ),
                                                        )

                                                      ],)
                                                        
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            MaterialButton(
                                                              onPressed:
                                                                  () async {
                                                                // FlutterRingtonePlayer
                                                                //     .stop();
                                                                final pref =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                final token = pref
                                                                    .getString(
                                                                        'Account Details');
                                                                print(
                                                                    '${payload['id']} ${activeOrder[ind]['_id']}');
                                                                var orderAccept =
                                                                    Provider.of<
                                                                            OrderBackend>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                await orderAccept
                                                                    .acceptOrder(
                                                                        activeOrder[ind]
                                                                            [
                                                                            '_id'],
                                                                        token);
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                'Accept',
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                        color: Colors
                                                                            .white),
                                                              ),
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            MaterialButton(
                                                              onPressed:
                                                                  () async {
                                                                final pref =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                final token = pref
                                                                    .getString(
                                                                        'Account Details');
                                                                print(
                                                                    '${payload['id']} ${activeOrder[ind]['_id']}');
                                                                var orderAccept =
                                                                    Provider.of<
                                                                            OrderBackend>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                await orderAccept
                                                                    .cancelOrder(
                                                                        activeOrder[ind]
                                                                            [
                                                                            '_id'],
                                                                        token);

                                                                // FlutterRingtonePlayer
                                                                //     .stop();
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                  'Cancel',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                          color:
                                                                              Colors.white)),
                                                              color: Colors.red,
                                                            ),
                                                          ],
                                                        )
                                                  // Text('Address :${geoCode.reverseGeocoding(latitude: snp.data['activeOrders'][ind]['cord']['lat'], longitude: snp.data['activeOrders'][ind]['cord']['lon'])}')
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        );
                      },
                    ),
                    //Text('hlo'),
                  ],
                ),
              ),
            ],
          ),
        ),
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
