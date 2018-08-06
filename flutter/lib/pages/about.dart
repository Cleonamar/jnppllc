import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutState createState() => new _AboutState();
}

class _AboutState extends State<AboutPage> {

  final _nameCon = new TextEditingController();
  final _addressCon = new TextEditingController();
  final _phoneCon = new TextEditingController();
  final _emailCon = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _store = Firestore.instance;

  FirebaseUser _user;
  DocumentSnapshot _profile;
  String _headshotUri;
  bool _headshot = false;
  bool _inEditMode = false;

  @override
  void initState() {
    super.initState();
    _nameCon.text = 'empty';
    _addressCon.text = 'empty';
    _phoneCon.text = 'empty';
    _emailCon.text = 'empty';
    _restore();
  }

  void _newHeadshot() {
    // open browse for picture intent
  }

  Future<DocumentSnapshot> _getProfile() async {
    _user = await _auth.currentUser();
    return await _store.collection('partners').document(_user.uid).get();
  }

  void _restore() {
    _getProfile().then(_onRestore);
  }

  void _update() {
    Map<String, dynamic> data = {
      'name': _nameCon.text,
      'address': _addressCon.text,
      'email': _emailCon.text,
      'phone': _phoneCon.text,
      'headshot': _headshotUri,
    };
    _profile.reference.setData(data, merge: true).then(_onUpdated);
  }

  void _onRestore(DocumentSnapshot snapshot) {
    setState(() {
      _profile = snapshot;
      _nameCon.text = _profile['name'] ?? 'empty';
      _addressCon.text = _profile['address'] ?? 'empty';
      _emailCon.text = _profile['email'] ?? 'empty';
      _phoneCon.text = _profile['phone'] ?? 'empty';
      _headshotUri = _profile['headshot'] ?? _user.photoUrl;
      _headshot = (_headshotUri != null);
    });
  }

  void _onUpdated(value) {
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        duration: new Duration(seconds: 2),
        content: new Text('Profile updated.', softWrap: true,),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
    new Scaffold(

    persistentFooterButtons: 
    (!_inEditMode) ? <Widget>[
        new FloatingActionButton(
          child: new Icon(Icons.restore),
          onPressed: _restore,
          tooltip: 'update',
        ),
        new FloatingActionButton(
          child: new Icon(Icons.save),
          onPressed: _update,
          tooltip: 'update',
        ),
      ] : new Container(height: 0.0, width: 0.0,),
    
    body: 
    new Form(
      child: 
    new Material(
        child:
    new ListView(

      children: <Widget>[

                // Headshot
                new Card(
                    child: 
                    (_headshot) ? 
                      new Image.network(_headshotUri,
                        fit: BoxFit.contain,
                        height: 100.0,
                    ) : 
                      new Icon(Icons.camera_alt),
                ),

                // Name, Address, Phone, Email
                new Card(
                  child: new Container(
                    margin: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      _buildText('name', _nameCon, Icons.portrait, TextInputType.text, 1),
                      _buildText('address', _addressCon, Icons.add_location, TextInputType.multiline, 2),
                      _buildText('email', _emailCon, Icons.email, TextInputType.emailAddress, 1),
                      _buildText('phone', _phoneCon, Icons.phone, TextInputType.phone, 1),
                    ],
                  ),
                ),
                ),
        ]
      ),
    ),
    ),
    );
  }

  Widget _buildText(
    String label, 
    TextEditingController controller, 
    IconData icon,
    TextInputType keyboardType,
    int maxlines,
    ) {
    return 
  /*  new Material(
      type: MaterialType.canvas,
      borderRadius: BorderRadius.all(Radius.circular(3.0)),
      child: 
  */    new TextFormField(
        decoration: new InputDecoration(
          labelText: label,
          icon: new Icon(icon),
        ),
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxlines,
  //    ),
    );
  }

}
