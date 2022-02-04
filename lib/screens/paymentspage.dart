import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/orderBackend.dart';

class Paymentspage extends StatefulWidget {
  var restroId;
  var token;
  Paymentspage({this.restroId, this.token});

  @override
  _PaymentspageState createState() => _PaymentspageState();
}

class _PaymentspageState extends State<Paymentspage> {
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat.yMMMd('en_US');
    DateFormat dateFormat2 = DateFormat.yMMMd('en_US');

    var order = Provider.of<OrderBackend>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: order.gettendaysOrder(
                            widget.restroId, widget.token),
                        builder: (con, AsyncSnapshot snap) {
                          if (snap.data == null) {
                            return CircularProgressIndicator();
                          }
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                                itemCount: snap.data['payCycle'].length,
                                itemBuilder: (context, indx) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4.5,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Colors.green[100]),
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Card(
                                                color: Colors.green,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    snap.data['payCycle'][indx]
                                                        ['paymentStatus'],
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "₹ " +
                                                    (snap.data['payCycle'][indx]
                                                                [
                                                                'totalAmount'] -
                                                            (snap.data['payCycle']
                                                                        [indx][
                                                                    'totalAmount'] *
                                                                0.20))
                                                        .toString(),
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                    fontSize: 19),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                ' Pay Cycle',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                  '${dateFormat2.format(DateTime.parse(snap.data['payCycle'][indx]['startDate']).toLocal())} To ${dateFormat.format(DateTime.parse(snap.data['payCycle'][indx]['endDate']).toLocal())}',
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      fontSize: 14)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                ' Copmleted orders',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                  '${snap.data['payCycle'][indx]['orderCount']}',
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      fontSize: 14)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                ' Total sell',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                  '${"₹ " + snap.data['payCycle'][indx]['totalAmount'].toString()}',
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      fontSize: 14)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                ' Site charge',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                  '${"₹ " + (snap.data['payCycle'][indx]['totalAmount'] * 0.20).toString()}',
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      fontSize: 14)),
                                            ],
                                          ),
                                          snap.data['payCycle'][indx]
                                                      ['paymentStatus'] ==
                                                  "Paid"
                                              ? Container()
                                              : Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      'Payment Date: ${dateFormat.format(DateTime.parse(snap.data['payCycle'][indx]['endDate']).toLocal())}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 14)),
                                                )

                                          // Text(snap.data['payCycle'][indx]
                                          //         ['totalAmount']
                                          //     .toString())
                                          //snap.data['payCycle'][indx]
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
