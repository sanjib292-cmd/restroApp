import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:restro_app/backendApi/add&editmenu.dart';
import 'package:restro_app/backendApi/uploadFile.dart';
import 'package:restro_app/designs/customAlertdilog.dart';
import 'package:path/path.dart';

class AddorEditMenu extends StatefulWidget {
  var token;

  AddorEditMenu({this.token});

  @override
  _AddorEditMenuState createState() => _AddorEditMenuState();
}

class _AddorEditMenuState extends State<AddorEditMenu> {
  final ImagePicker _picker = ImagePicker();
  var img;

  Future pickImgandSaveFilename() async {
    try {
      var image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          img = image;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  var itemName, isveg, file, price, inStock, foodtype, category;
  String itmDetails = '';

  var cusineTyp;
  bool itmVeg = false;
  @override
  Widget build(BuildContext context) {
    UploadTask? task;
    //FirebaseApi firebaseApi = FirebaseApi();
    AddnEditMenu addnEditMenu = AddnEditMenu();
    //print('this fuck${widget.token}');
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            SizedBox(height: 20.0),
            ExpansionTile(
              title: Text("Category",
                  style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  )),
              children: [
                ExpansionTile(
                    title: Text("Category Name", style: GoogleFonts.poppins()),
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField<String>(
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                              hint: Text("*Sellect Category"),
                              items: [
                                "Lunch",
                                "Breakfast",
                                "Dinner",
                                "Snacks",
                                "Beavrages",
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  category = val;
                                });
                              }),
                        ),
                      ),
                      ExpansionTile(
                        title: Text("ITEM DETAILS",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: [
                                  Container(
                                    // child: img == null
                                    child: TextButton(
                                      onPressed: () async {
                                        pickImgandSaveFilename();
                                      },
                                      child: Center(
                                        child: FaIcon(FontAwesomeIcons.camera),
                                      ),
                                    ),
                                    // : Image.file(File(img.path),fit: BoxFit.contain,),
                                    decoration: BoxDecoration(
                                        image: img == null
                                            ? null
                                            : DecorationImage(
                                                image: FileImage(
                                                  File(img.path),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                        color: Colors.grey[200],
                                        border: Border.all(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    height: 100,
                                    width: 100,
                                  ),
                                  Text("Add item image",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                          ),
                          additemTxtfield("*Item Name", (val) {
                            setState(() {
                              itemName = val;
                              print(itemName);
                            });
                          }),
                          additemTxtfield("*Price", (val) {
                            setState(() {
                              price = val;
                            });
                          }),
                          additemTxtfield("Item Details", (val) {
                            setState(() {
                              itmDetails = val;
                            });
                          }),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 14.0, right: 14),
                            child: Column(
                              children: [
                                Text("*Sellect Cusine Type",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButtonFormField<String>(
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                        hint: Text("Sellect Cusine Type"),
                                        items: [
                                          "Indian",
                                          "Chinese",
                                          "Tibetian",
                                          "Arunachali",
                                          "North Indian",
                                          "South India",
                                          "Sweets",
                                          "Roast",
                                          "BBQ",
                                          "Naga",
                                          "Assamess",
                                          "Contiental",
                                          "Korean",
                                          "Biryani",
                                          "Bakery"
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            cusineTyp = val;
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 25),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(itmVeg ? "Veg" : "Non-Veg",
                                      style: GoogleFonts.poppins(
                                          color: itmVeg
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: Checkbox(
                                          checkColor: Colors.white,
                                          value: itmVeg,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              itmVeg = value!;
                                            });
                                            print(itmVeg);
                                          },
                                        )),
                                  )
                                ],
                              ),
                              Text(
                                'Item is non-veg tick the box to change to veg',
                                style: GoogleFonts.poppins(),
                              )
                            ],
                          )
                        ],
                      )
                    ])
              ],
            ),
            SizedBox(height: 20),
            Container(
                color: Colors.green,
                height: 50,
                width: 300,
                child: TextButton(
                    onPressed: () async {
                      var payload = Jwt.parseJwt(widget.token);

                      try {
                        if (img.path == null) {
                          return;
                        } else {
                          final filename = basename(img.path);
                          final destination = 'itmImg/$filename';
                          EasyLoading.showInfo('Uploading..');
                          task = FirebaseApi.uploadTask(
                              destination, File(img.path));
                          if (task == null) {
                            EasyLoading.dismiss();
                            return;
                          } else {
                            final snap = await task!
                                .whenComplete(() {})
                                .catchError((er) {
                              showDialog(
                                  context: context,
                                  builder: (con) {
                                    return CustomDialogBox(
                                      title: "Reuired field can't be null",
                                      descriptions: "$er",
                                    );
                                  });
                            });
                            final url = await snap.ref.getDownloadURL();
                            EasyLoading.dismiss();
                            // if(url==null){
                            //   print('null');
                            // }
                            print(url);
                            //.then((value) async {
                            try {
                              if (itemName == null ||
                                  url == null ||
                                  price == null ||
                                  cusineTyp == null ||
                                  category == null) {
                                showDialog(
                                    context: context,
                                    builder: (con) {
                                      return CustomDialogBox(
                                        title: "Reuired field can't be null",
                                        descriptions:
                                            "Recheck form and submit..",
                                      );
                                    });
                              } else {
                                await addnEditMenu.addItems(
                                    widget.token,
                                    payload['id'].toString(),
                                    itemName,
                                    itmVeg,
                                    url,
                                    price,
                                    cusineTyp,
                                    itmDetails,
                                    category);
                                //if (addnEditMenu.sucessMsg != null) {

                                try {
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              addnEditMenu.uploadedSucess ??
                                                  addnEditMenu.uploadedFail),
                                        );
                                      });
                                } on Exception catch (e) {
                                  print(e);
                                }
                              }
                            } catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (con) {
                                    return AlertDialog(
                                        title: Text(e.toString()));
                                  });
                            }
                            // });
                            //});
                          }
                        }
                      } on Exception catch (e) {
                        print(e);
                      }
                    },
                    child: Text('Add to menu',
                        style: TextStyle(color: Colors.white)))),
            SizedBox(
              height: 150,
            )
          ],
        )),
      ),
    );
  }

  additemTxtfield(String lbltxt, Function(String) onchangedCallback) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: onchangedCallback,
          decoration: InputDecoration(
              labelText: lbltxt,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.green),
                borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.red),
                borderRadius: BorderRadius.circular(6),
              )),
        ),
      );
}

class textFieldexpansionTile extends StatelessWidget {
  var title;
  textFieldexpansionTile({this.title});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: title,
      children: [
        additemTxtfield("Item Name"),
        additemTxtfield("Price"),
        additemTxtfield("Item Details"),
      ],
    );
  }

  TextField additemTxtfield(String lbltxt) => TextField(
        decoration: InputDecoration(
            labelText: lbltxt,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.blue),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.red),
              borderRadius: BorderRadius.circular(15),
            )),
      );
}
