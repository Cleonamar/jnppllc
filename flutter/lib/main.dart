import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lord_of_the_firms/pages/central.dart';
import 'package:lord_of_the_firms/pages/story.dart';

void main() async {
  Map data = await MethodChannel('us.devlaw.data').invokeMethod('get');
  runApp(new PartnerApp(data: data));
}

class PartnerApp extends StatelessWidget {

  final Map data;

  PartnerApp({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'JNPartner',
      theme: new ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
      initialRoute: (data['url'] != null) ? '/story' : '/',
      routes: {
        '/':(context) => CentralPage(),
        '/story': (context) => StoryPage(source: data),
      },
    );
  }
}