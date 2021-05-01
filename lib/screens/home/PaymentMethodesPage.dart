import 'package:flutter/material.dart';
import 'package:taxi_ma/screens/Payment/CardChoicePage.dart';


class PaymentMethodesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Payment Methodes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 48.0,),
            ElevatedButton(
                onPressed: (){},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan[400]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                  ),
                ),
                child: Text(
                  'Payment with cash',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),

            ),
            SizedBox(height: 12.0,),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[600]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),
                  ),
                ),
                child: Text(
                  'Payment with Card',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => CardChoicePage(),
                  ));
              },
            ),


          ]
      ),
    );
  }
}
