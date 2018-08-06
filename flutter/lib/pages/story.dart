import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lord_of_the_firms/widgets/signin.dart';

class StoryPage extends StatefulWidget {

  final Map source;

  StoryPage({Key key, @required this.source}) : super(key: key);

  @override
  _StoryState createState() => new _StoryState();
}

class _StoryState extends State<StoryPage> {

  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final FirebaseStorage storage = 
    new FirebaseStorage(storageBucket: 'gs://jnppllc.appspot.com');

  File imageFile;

  FutureOr onAdded(DocumentReference docRef) {
    return docRef;
  }

  FutureOr onUser(FirebaseUser user) {
    return user.uid;
  }

  Future<DocumentReference> postStory(Map<String, dynamic> story) async {
    
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (story['icon'] == null) {
      story['icon'] = 'https://flutter.io/images/flutter-mark-square-100.png';
    } else {
      Uri file = story['icon'];
      StorageReference ref = storage.ref().child('news').child(file.pathSegments.last);
      StorageUploadTask uploadTask = ref.putFile(File.fromUri(file));
      final Uri downloadUrl = (await uploadTask.future).downloadUrl;
      story['icon'] = downloadUrl.toString();
    }
    story['owner'] = await _auth.currentUser().then(onUser);
    story['created'] = DateTime.now();
    story['updated'] = DateTime.now();
    story['status'] = true;

    final CollectionReference _news = Firestore.instance.collection('news');
    return _news.add(story);

  }

  @override
  void initState() {
    super.initState();
    imageFile = (widget.source['file'] != null) ? new File(widget.source['file']) : null;
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onShare() {
    postStory({
      'url': widget.source['url'],
      'title': titleController.text,
      'subtitle': subtitleController.text,
      'icon': imageFile.uri,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: new AppBar(
        title: new Text('Share'),
        actions: <Widget>[
          new SignIn(),
        ]
      ),
          
      body:
            // Image
              ListView(
                children: <Widget>[
                  new Card(
                    margin: EdgeInsets.all(20.0),
                    child: new Image.file(
                      imageFile,
                      height: 240.0,
                      fit: BoxFit.contain,
                    ),
                  ),

                  new Container(
                    padding: new EdgeInsets.all(32.0),
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                child: TextField(
                                  controller: titleController,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              new TextField(
                                controller: subtitleController,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new FloatingActionButton(
                        child: new Icon(Icons.share),
                        onPressed: _onShare,
                      ),
                      new FloatingActionButton(
                        child: new Icon(Icons.cancel),
                        onPressed: _onCancel,
                      ),
                    ],
                  ),
                ],
              ),

    );
  }
}
