import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marubatsu_com/view_models/battle_page_model.dart';
import 'package:provider/provider.dart';

class BattlePage extends StatelessWidget {
  static const rootName = '/battle';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BattlePageModel>(
      create: (_) => BattlePageModel(),
      child: Consumer<BattlePageModel>(
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text('バトル画面'),
              centerTitle: true,
            ),
            body: Center(
              child: Text('バトル画面'),
            ),
          );
        },
      ),
    );
  }
}