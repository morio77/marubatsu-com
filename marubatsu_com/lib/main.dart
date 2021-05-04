import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marubatsu_com/utils/cell_type_utils.dart';
import 'package:marubatsu_com/views/battle_page.dart';
import 'package:marubatsu_com/views/home_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CellTypeAdapter());
  await Hive.openBox('settings');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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