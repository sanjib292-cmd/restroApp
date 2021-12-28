import 'package:flutter/material.dart';

class Pastorders extends StatefulWidget {
  const Pastorders({ Key? key }) : super(key: key);

  @override
  _PastordersState createState() => _PastordersState();
}

class _PastordersState extends State<Pastorders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('No Past Orders'),),
      
    );
  }
}