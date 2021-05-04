import 'package:flutter/material.dart';
import 'package:marubatsu_com/views/battle_page.dart';
import 'package:marubatsu_com/views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'マルバツゲーム',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.rootName,
      routes: {
        HomePage.rootName: (_) => HomePage(),
        BattlePage.rootName: (_) => BattlePage(),
      },
    );
  }
}