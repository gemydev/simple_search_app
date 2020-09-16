import 'package:flutter/material.dart';
import 'package:simple_search_app/home.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: Colors.teal,
        primaryColorDark: Colors.indigo,
        accentColor: const Color(0xFF167F67),
      ),
      home: new MainPage(),
    );
  }
}
