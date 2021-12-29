import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Future getRestroById(id)async{
    var restroByid=Provider.of<LoginRestro>(context,listen: false);
   var restrodetails= await restroByid.getRestroDetails(id);
   return restrodetails;
  }

  @override
  Widget build(BuildContext context) {
        var payload = Jwt.parseJwt(widget.userDetails);

    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getRestroById(payload['id']),
          
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  
            if(snapshot.data==null){
              return CircularProgressIndicator();
            }
            print(snapshot.data);
      return Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.redAccent, Colors.pinkAccent]
                  )
                ),
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
                          margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 22.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
        
                                    children: <Widget>[
                                      Text(
                                        "Posts",
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
                                        "5200",
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
                                        "Orders",
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
                                        snapshot.data['allOrders'].length.toString(),
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
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        snapshot.data['activeOrders'].length.toString(),
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
                )
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 16.0),
                  child: Column(
                        children: [
                          ExpansionTile(title: Text('Past orders', style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red))),
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                             physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data['allOrders'].length,
                              itemBuilder: (con,index){
                                 print(snapshot.data['allOrders'][0]['orderItems'].length);
                              return Expanded(
                               // height: 150,
                                child: Card(
                                  elevation: 5,
                                  
                                  child: ListTile(
                                    title: Text('Status: ${snapshot.data['allOrders'][index]['orderStatus']}',style: GoogleFonts.poppins(color:snapshot.data['allOrders'][index]['orderStatus']=="Canceled"?Colors.red:Colors.green ),),
                                    subtitle:Column(children: [
                                      ListView.builder(
                                        //scrollDirection: Axis.vertical,
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data['allOrders'][index]['orderItems'].length,
                                        itemBuilder: (context,ind){
                                          print('index is $ind');
                                        return Container(
                                          height: 50,
                                          child: Card(
                                            child: Row(
                                              children: [

                                                Text(snapshot.data['allOrders'][index]['orderItems'][ind]['item']['itemName'].toString(),style: GoogleFonts.poppins())
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                    ],)
                                    // Text(snapshot.data['allOrders'][0]['orderItems'][0]['price'].toString()),
      
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
                          ],)
                        ],
                      )
                  
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
            
            ],
          );
          },
          
        ),
      ),
    );
  }
}

