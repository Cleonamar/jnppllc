import 'package:flutter/material.dart';
import 'package:lord_of_the_firms/widgets/signin.dart';
import 'package:lord_of_the_firms/pages/news.dart';
import 'package:lord_of_the_firms/pages/about.dart';
import 'package:lord_of_the_firms/pages/services.dart';

class CentralPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
      
        appBar: new AppBar(
          title: Text('JNP Partner Center'),
          actions: <Widget>[
            new SignIn(),
          ],
          bottom: new TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.speaker_notes),
                text: 'News',
              ),
              Tab(
                icon: Icon(Icons.school),
                text: 'About'
              ),
              Tab(
                icon: Icon(Icons.shopping_cart),
                text: 'Services',
              ),
            ],
          ),
        ),

        body: new TabBarView( 
          children: <Widget>[
            new NewsPage(),
            new AboutPage(),
            new ServicesPage(),
          ],
        ),
      ),
    );
  } // build()
} // class
