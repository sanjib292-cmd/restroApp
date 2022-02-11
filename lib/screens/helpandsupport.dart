import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpnSupport extends StatefulWidget {
  const HelpnSupport({ Key? key }) : super(key: key);

  @override
  _HelpnSupportState createState() => _HelpnSupportState();
}

class _HelpnSupportState extends State<HelpnSupport> {
     String data='';
  fetchData()async{
    String text;
    text=await rootBundle.loadString('images/hlp.txt');
    setState(() {
      data=text;
    });
  }
  @override
  void initState() {
    fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text('Help & Support',style: GoogleFonts.poppins(color:Colors.black,fontWeight: FontWeight.w700)),backgroundColor: Colors.white,elevation: 0,centerTitle: true,),
      body: SingleChildScrollView(child: SafeArea(child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(data,style: GoogleFonts.poppins(fontWeight:FontWeight.w600,fontSize: 20)),
      )))
      
      
    );
  }
}