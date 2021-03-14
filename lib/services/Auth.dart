import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth= FirebaseAuth.instance;

  Future signInAnonymously() async {
    try{
      UserCredential result = await auth.signInAnonymously();
      User user = result.user;
      return user;
    }
    catch(e){
      print("error $e");
      return null;
    }
  }

}