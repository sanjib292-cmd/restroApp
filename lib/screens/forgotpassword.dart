import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restro_app/backendApi/loginRestro.dart';
import 'package:restro_app/designs/snakbar.dart';

import 'otpScreen.dart';

class Forgotpass extends StatefulWidget {
  const Forgotpass({ Key? key }) : super(key: key);

  @override
  _ForgotpassState createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  var number;
  @override
  Widget build(BuildContext context) {
    
    var forgotpass=Provider.of<LoginRestro>(context,listen: false);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('RESET PASSWORD',style: GoogleFonts.poppins(fontWeight:FontWeight.bold,fontSize: 22,color: Colors.red),),
          Padding(
            padding: const EdgeInsets.only(left:8.0,right: 8.0),
            child: Center(child: Text('Enter the number associated with your account and we will send you a otp to reset your password',style: GoogleFonts.poppins(fontWeight:FontWeight.w500,fontSize: 16))),
          ),
         // Text('and we will send you a otp to reset your password'),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(decoration: InputDecoration(hintText: 'Phone'),
            onChanged: (val){
setState(() {
  number=val;
});
print(number.runtimeType);
            },
            ),
          ),
          MaterialButton(onPressed:()async{
             number.length<10?
             snackBar('Number shoud be 10 digit', context):
           await forgotpass.forGotpassword(number);
           if(forgotpass.forgotsucess!=null){
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
               return ChangeNotifierProvider(create: (BuildContext context) {return LoginRestro();  },
               child: Otp(number: number,));
             }));
           }
           snackBar(forgotpass.forgotfail, context);
          },child: Text('Reset password',style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold),),color: Colors.green,)
        ],
      ),
      
    );
  }
}