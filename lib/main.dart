import 'package:flutter/material.dart';
import 'package:untitled/blocObserver.dart';
import 'package:untitled/splashScreen.dart';
import 'Screens/homeScreen.dart';
import 'package:bloc/bloc.dart';
void main() {

  Bloc.observer = SimpleBlocObserver();
  runApp(TodoList());
}

class TodoList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: splashScreen());
  }
}
