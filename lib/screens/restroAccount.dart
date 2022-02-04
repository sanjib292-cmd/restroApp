import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/loginRestro.dart';

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
              return CircularProgressIndicator();
            }
print(snapshot.data);
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
                      child: Column(
                        children: [
                          ExpansionTile(
                            title: Text('Complete orders',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green))),
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      snapshot.data['completedOrders'].length,
                                  itemBuilder: (con, index) {
                                    print(
                                        'Status: ${snapshot.data['completedOrders']}');
                                    return Expanded(
                                      // height: 150,
                                      child: Card(
                                          elevation: 5,
                                          child: ListTile(
                                              title: Text(
                                                'Status: ${snapshot.data['completedOrders'][index]['orderStatus']}',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.green),
                                              ),
                                              subtitle: Column(
                                                children: [
                                                  ListView.builder(
                                                      //scrollDirection: Axis.vertical,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: snapshot
                                                          .data[
                                                              'completedOrders']
                                                              [index]
                                                              ['orderItems']
                                                          .length,
                                                      itemBuilder:
                                                          (context, ind) {
                                                        print('index is $ind');
                                                        return Container(
                                                          height: 50,
                                                          child: Card(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    snapshot
                                                                        .data[
                                                                            'completedOrders']
                                                                            [
                                                                            index]
                                                                            [
                                                                            'orderItems']
                                                                            [
                                                                            ind]
                                                                            [
                                                                            'item']
                                                                            [
                                                                            'itemName']
                                                                        .toString(),
                                                                    style: GoogleFonts
                                                                        .poppins())
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      })
                                                ],
                                              )
                                              // // Text(snapshot.data['allOrders'][0]['orderItems'][0]['price'].toString()),

                                              //   subtitle: Row(
                                              //   children: [
                                              //     Column(
                                              //       children: [
                                              //         ListView.builder(

                                              //           itemCount:snapshot.data['allOrders'][0]['orderItems'].length ,
                                              //           itemBuilder: (con,ind){
                                              //             print('hlo');
                                              //             //print(snapshot.data['allOrders'][index]['orderItems'].length );
                                              //           return Card(child: Text(snapshot.data['allOrders'][0]['orderItems'][0]['item']['itemName']),);
                                              //         })
                                              //       ],

                                              //     ),
                                              //     Text(snapshot.data['allOrders']['orderStatus'])
                                              //   ],
                                              // ),),
                                              )),
                                    );
                                  })
                            ],
                          )
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
                            title: Text('Cancled orders',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red))),
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      snapshot.data['canceledOrder'].length,
                                  itemBuilder: (con, index) {
                                    //List numbers=[];

                                    print(
                                        'Status: ${snapshot.data['canceledOrder'][0]['orderStatus']}');
                                    return Expanded(
                                      // height: 150,
                                      child: Card(
                                          elevation: 5,
                                          child: ListTile(
                                              title: Text(
                                                'Status: ${snapshot.data['canceledOrder'][index]['orderStatus']}',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.red),
                                              ),
                                              subtitle: Column(
                                                children: [
                                                  ListView.builder(
                                                      //scrollDirection: Axis.vertical,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: snapshot
                                                          .data['canceledOrder']
                                                              [index]
                                                              ['orderItems']
                                                          .length,
                                                      itemBuilder:
                                                          (context, ind) {
                                                        print('index is $ind');
                                                        return Container(
                                                          height: 50,
                                                          child: Card(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    snapshot
                                                                        .data[
                                                                            'canceledOrder']
                                                                            [
                                                                            index]
                                                                            [
                                                                            'orderItems']
                                                                            [
                                                                            ind]
                                                                            [
                                                                            'item']
                                                                            [
                                                                            'itemName']
                                                                        .toString(),
                                                                    style: GoogleFonts
                                                                        .poppins())
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      })
                                                ],
                                              )
                                              // // Text(snapshot.data['allOrders'][0]['orderItems'][0]['price'].toString()),

                                              //   subtitle: Row(
                                              //   children: [
                                              //     Column(
                                              //       children: [
                                              //         ListView.builder(

                                              //           itemCount:snapshot.data['allOrders'][0]['orderItems'].length ,
                                              //           itemBuilder: (con,ind){
                                              //             print('hlo');
                                              //             //print(snapshot.data['allOrders'][index]['orderItems'].length );
                                              //           return Card(child: Text(snapshot.data['allOrders'][0]['orderItems'][0]['item']['itemName']),);
                                              //         })
                                              //       ],

                                              //     ),
                                              //     Text(snapshot.data['allOrders']['orderStatus'])
                                              //   ],
                                              // ),),
                                              )),
                                    );
                                  })
                            ],
                          )
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
                              Text('Ratings: ',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),),
                              Text(
                                  '${snapshot.data['rating'].fold(0, (avg, ele) => avg + ele / snapshot.data['rating'].length)}(${snapshot.data['rating'].length})',style: GoogleFonts.poppins(
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
                  child: MaterialButton(onPressed: (){},child: Text('LOGOUT',style: GoogleFonts.poppins(fontWeight:FontWeight.bold,color:Colors.white)),color: Colors.red,),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
