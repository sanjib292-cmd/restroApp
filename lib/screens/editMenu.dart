import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/add&editmenu.dart';
import 'package:restro_app/backendApi/loginRestro.dart';
import 'package:restro_app/designs/customAlertdilog.dart';
import 'package:restro_app/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMenu extends StatefulWidget {
  var itmDetails;
  var typId;
  EditMenu({this.itmDetails, this.typId});

  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  bool validated = false;
  var userdetails;
  var itmName;
  //widget.itmDetails['itemName'];
  var itmPrice;
  //widget.itmDetails['price'];
  var itmDetails;
  var cusineTyp;
  //= widget.itmDetails['itmDetails'];

  getUserdetails() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var userdetails = sharedPreferences.getString('Account Details');
    setState(() {
      userdetails = userdetails;
    });
  }

  @override
  void initState() {
    itmName = widget.itmDetails['itemName'];
    itmPrice = widget.itmDetails['price'];
    itmDetails = widget.itmDetails['itmDetails'];
    cusineTyp = widget.itmDetails['foodtype'];

    getUserdetails();
    super.initState();
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  void validate() {
    if (formkey.currentState!.validate()) {
      setState(() {
        validated = true;
      });
      print('Validated');
    } else {
      setState(() {
        validated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var restroId = widget.itmDetails['restroId'];
    var itmId = widget.itmDetails['_id'];
    print(userdetails);

    var editItm = Provider.of<AddnEditMenu>(context, listen: false);
    print(widget.itmDetails);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              readOnly:true,
              decoration: InputDecoration(
              hintText: cusineTyp,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
              
            ),
          ),
          
          Form(
            key: formkey,
            child: editingTextfield('Item Name', '$itmName', (val) {
              setState(() {
                itmName = val;
                print(itmName);
              });
            }),
          ),
          editingTextfield('Price', '$itmPrice', (val) {
            setState(() {
              itmPrice = val;
            });
          }),
          editingTextfield('Item Details', '$itmDetails', (val) {
            setState(() {
              itmDetails = val;
            });
          }),
          Container(
            color: Colors.green,
            height: 50,
            width: 345,
            child: TextButton(
                onPressed: () async {
                  validate();
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  print(
                      '$itmName,$itmPrice,$itmDetails,${widget.typId},$itmId,$restroId,${sharedPreferences.getString('Account Details')}');
                  if (validated == false) {
                    return null;
                  } else if (sharedPreferences.getString('Account Details') ==
                      null) {
                    return showDialog(
                        context: context,
                        builder: (con) {
                          return CustomDialogBox(
                              title: "Invalid Opration",
                              descriptions: "Token expired..please login",
                              img:
                                  "https://freefrontend.com/assets/img/html-funny-404-pages/SVG-Animation-404-Page.png",
                              text: "Login");
                          // AlertDialog(
                          //   title: Text('Token expired please login..'),
                          //   content:TextButton(child: Text('Login'),onPressed: (){},)
                          // );
                        });
                  }
                  await editItm.editItms(
                      itmName,
                      itmPrice,
                      itmDetails,
                      widget.typId,
                      itmId,
                      restroId,
                      sharedPreferences.getString('Account Details'));
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(editItm.sucessMsg ?? editItm.errorMsg),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (con) {
                                    return ChangeNotifierProvider(
                                        create: (BuildContext context) {
                                          return LoginRestro();
                                        },
                                        child: HomePage());
                                  }));
                                },
                                child: Text('Home'))
                          ],
                        );
                      });
                },
                child: Text('Save Changes',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16))),
          ),
        ],
      ),
    );
  }

  Column editingTextfield(
      String header, String initialVal, Function(String) onchangedCallback) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 4, top: 2),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(header,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red)))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (val) {
              if (val == null || val == "") {
                return "Field can't be null";
              } else {
                return null;
              }
            },
            onChanged: onchangedCallback,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey))),
            initialValue: initialVal,
          ),
        ),
      ],
    );
  }
}
