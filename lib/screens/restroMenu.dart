import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/add&editmenu.dart';
import 'package:restro_app/backendApi/loginRestro.dart';
import 'package:restro_app/screens/editMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class RestroMenu extends StatefulWidget {
  var payLoad;
  var token;
  RestroMenu({this.payLoad, this.token});

  @override
  _RestroMenuState createState() => _RestroMenuState();
}

class _RestroMenuState extends State<RestroMenu> {
  @override
  Widget build(BuildContext context) {
    AddnEditMenu addnEditMenu = AddnEditMenu();
    print('this is ${widget.token}');
    final restroLogin = Provider.of<LoginRestro>(context, listen: false);
    getAllcusineTyp() async {
      var res = await restroLogin.getRestroDetails(widget.payLoad['id']) as Map;
      print(res);
      return res["cusineType"];
      //return null;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Restraunt Items',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    textBaseline: TextBaseline.alphabetic,
                    decoration: TextDecoration.underline),
              ),
            )),
            FutureBuilder(
                future: getAllcusineTyp(),
                builder: (context, AsyncSnapshot<dynamic> snap) {
                  print(snap.data);
                  if (snap.data != null) {
                    return ListView.builder(
                        itemCount: snap.data.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Card(
                                child: ExpansionTile(
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: snap
                                              .data[index]['restro'][0]['items']
                                              .length,
                                          itemBuilder: (context, indx) {
                                            print(
                                                'this is   ${snap.data[index]['restro']}');
                                            // Text(
                                            //       "snap.data[index]['restro'][0]['items'][indx]['itemName']")
                                            return Card(
                                              child: ListTile(
                                                subtitle: Row(
                                                  children: [
                                                    Text('₹',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.green)),
                                                    Text(
                                                      snap.data[index]['restro']
                                                              [0]['items'][indx]
                                                              ['price']
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16),
                                                    ),
                                                    Switch(
                                                        value: snap.data[index]
                                                                    ['restro']
                                                                [0]['items']
                                                            [indx]['inStock'],
                                                        onChanged:
                                                            (bool val) async {
                                                          final SharedPreferences
                                                              sharedPreferences =
                                                              await SharedPreferences
                                                                  .getInstance();

                                                          await addnEditMenu.editInStock(
                                                              snap.data[index]
                                                                  ['_id'],
                                                              snap.data[index]
                                                                          ['restro']
                                                                      [0]['items']
                                                                  [indx]['_id'],
                                                              snap.data[index]
                                                                          ['restro'][0]
                                                                      ['items'][indx]
                                                                  ['restroId'],
                                                              sharedPreferences
                                                                  .getString(
                                                                      'Account Details'),
                                                              val);
                                                          setState(() {
                                                            snap.data[index]['restro']
                                                                            [0][
                                                                        'items']
                                                                    [indx][
                                                                'inStock'] = val;
                                                          });
                                                        }),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return ChangeNotifierProvider(
                                                              create:
                                                                  (BuildContext
                                                                      context) {
                                                                return AddnEditMenu();
                                                              },
                                                              child: EditMenu(
                                                                itmDetails: snap
                                                                            .data[index]
                                                                        [
                                                                        'restro'][0]
                                                                    [
                                                                    'items'][indx],
                                                                typId: snap.data[
                                                                        index]
                                                                    ['_id'],
                                                              ),
                                                            );
                                                          }));
                                                        },
                                                        icon: FaIcon(
                                                            FontAwesomeIcons
                                                                .pencilAlt,
                                                            size: 20))
                                                  ],
                                                ),
                                                title: Text(
                                                  snap.data[index]['restro'][0]
                                                          ['items'][indx]
                                                      ['itemName'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                trailing: CircleAvatar(
                                                    radius: 60,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      snap.data[index]['restro']
                                                              [0]['items'][indx]
                                                          ['itmImg'],
                                                    )),
                                              ),
                                            );
                                          })
                                    ],
                                    title: Text(snap.data[index]['cusineType'],
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ))),
                              ),
                              SizedBox(height: 10)
                            ],
                          );
                        });
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (con, ind) {
                        return Shimmer.fromColors(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  height: 60,
                                  width: 12),
                            ),
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[300]!);
                      });
                })
          ],
        ),
      ),
    );
  }
}
