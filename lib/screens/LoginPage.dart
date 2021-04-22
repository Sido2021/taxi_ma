import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'MainPage.dart';
import 'package:taxi_ma/services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_ma/models/User.dart' as u;
import 'Utilities/Dialog.dart';
import 'SignUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Auth auth ;
  List<TextEditingController> textEditingControllers = <TextEditingController>[TextEditingController(),TextEditingController()];


  _LoginPageState(){
    super.initState();
    loginAutomatically();
  }

  void loginAutomatically() async{
    showProgressDialog(context);
    u.User newUser = u.User.forSignIn(email:"ayoub@gmail.com",password:"azerty@123" );
    auth = new Auth(user:newUser);
    UserCredential user = await auth.signIn();
    Navigator.of(dialogContext).pop();
    if(user != null){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainPage()));
    }
    else {
      print("Failed !");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/images/taxi.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: textEditingControllers[0],
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'email@exemple.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: textEditingControllers[1],
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: '**********'),
              ),
            ),
            FlatButton(
              onPressed: (){
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.amberAccent, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () async{
                  showProgressDialog(context);
                  u.User newUser = u.User.forSignIn(email:textEditingControllers[0].text,password:textEditingControllers[1].text );
                  auth = new Auth(user:newUser);
                  UserCredential user = await auth.signIn();
                  Navigator.of(dialogContext).pop();
                  if(user != null){
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => MainPage()));
                  }
                  else {
                    print("Failed !");
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            FlatButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SignUp()));
              },
              child: Text(
                'New User ? Create Account',
              ),
            ),
          ],
        ),
      ),
    );
  }
}