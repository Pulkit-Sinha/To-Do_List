import 'package:flutter/material.dart';
import 'To Do List/TodoList.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: ThemeData(
        fontFamily: 'GoogleSans',
        primaryColor: Color(0xff141111),
        scaffoldBackgroundColor: Color(0xff1d1d1d),
      ),
      home: TodoList(),
    );
  }
}



