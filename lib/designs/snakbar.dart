import 'package:flutter/material.dart';

snackBar(String? message,BuildContext context) {
    
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }