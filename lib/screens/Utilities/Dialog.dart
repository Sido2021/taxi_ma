import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

BuildContext dialogContext ;

Future<void> showProgressDialog(c) async {
  return showDialog<void>(
    context: c,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      dialogContext = context ;
      return
          AlertDialog(
            content: Container(
              height: 100,
              child:  SpinKitWave(
               color: Colors.amber,
              size: 30.0,
            ),
          ),
        );
    },
  );
}