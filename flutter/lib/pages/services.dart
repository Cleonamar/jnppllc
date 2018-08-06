import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesState createState() => new _ServicesState();
}

class _ServicesState extends State<ServicesPage> {

  @override
  Widget build(BuildContext context) {
    return new Container( 
        child: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('news')
          .where('status', isEqualTo: true)
          .orderBy('created', descending: true)
          .limit(3)
          .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {return new Text('loading...');} else {
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new Container(
                  margin: EdgeInsets.all(10.0),
                  child: new Card(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          child: new Image.network(
                            document['icon'],
                            fit: BoxFit.contain,
                            height: 200.0,
                          ), 
                        ),
                        new Flexible(
                          child: new Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                new Text(
                                  document['title'] ?? 'blank',
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                new Text(
                                  document['subtitle'] ?? 'blank',
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                );
              })
            .toList());
          }
        }
      ),
    );
  } // build()
} // class
