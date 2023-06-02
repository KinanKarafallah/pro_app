import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_app/widgets/auth/sign_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLogging = false;
  void _submitAuth(
    String email,
    String password,
    String username,
    bool isLogIn,
    BuildContext ctx,
  ) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLogging = true;
      });
      if (isLogIn) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({'username': username, 'email': email});
      }
    } on PlatformException catch (err) {
      var message = 'an error occured';

      if (message != null) {
        message = err.message;
      }

      setState(() {
        _isLogging = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLogging = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Damascus Uni App || Sign In')),
      body: SignAuth(_submitAuth, _isLogging),
    );
  }
}
