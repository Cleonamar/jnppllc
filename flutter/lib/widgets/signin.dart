import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  @override
  State createState() => new SignInState();
}

class SignInState extends State<SignIn> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

  IconData _icon;
  String _tip;

  Future<FirebaseUser> _run() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    _user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _user;
  }

  @override
   void initState() {
     super.initState();
     _icon = Icons.warning;
     _tip = 'signin';
     _run().then(_onIn).catchError(_onError);
   }

  void _onIn(FirebaseUser user) {
    setState(() {
      _tip = user.displayName;
      _icon = Icons.account_box;
    });
  }

  void _onError(Error error) {
    setState(() {
      _tip = error.toString();
      _icon = Icons.error;
    });
  }

  void _onPress() {
     _run().then(_onIn).catchError(_onError);
  }

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Icon(_icon),
      tooltip: _tip,
      onPressed: _onPress ,
    );

  }
}
