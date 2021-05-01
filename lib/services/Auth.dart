import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_ma/models/User.dart' as u;

class Auth {
  final FirebaseAuth auth= FirebaseAuth.instance;
  u.User user ;

  Auth({this.user});

  Future signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email,
          password: user.password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      /*if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }*/
      return null;
    }
    catch(e){
      return null;
    }
  }

  Future signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password
      );
      return userCredential ;
    } on FirebaseAuthException catch (e) {
      /*if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }*/
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

}