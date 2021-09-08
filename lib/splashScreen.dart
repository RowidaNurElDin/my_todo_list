import 'dart:async';

import 'package:flutter/material.dart';

import 'Constants.dart';
import 'Screens/homeScreen.dart';

class splashScreen extends StatefulWidget {

  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen())));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                child: Image(
                  image: AssetImage('images/todo.png'),
                )
              ),
            ),
            Text('My Todo-list',
              style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 40,
                color: Constants.color,
                shadows: [Shadow(
                    color: Constants.color.withOpacity(0.3),
                    offset: Offset(15, 15),
                    blurRadius: 15),]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
