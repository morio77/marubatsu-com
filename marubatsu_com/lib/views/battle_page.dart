import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marubatsu_com/utils/cell_type_utils.dart';
import 'package:marubatsu_com/view_models/battle_page_model.dart';
import 'package:marubatsu_com/views/cell_painter.dart';
import 'package:provider/provider.dart';

class BattlePage extends StatelessWidget {
  static const routeName = '/battle';
  
  @override
  Widget build(BuildContext context) {
    // 引数で渡されてくるCOMレベルと自分のセルタイプを取得しておく
    final args = ModalRoute.of(context).settings.arguments as Map;
    final comLevel = args['comLevel'];

    return ChangeNotifierProvider<BattlePageModel>(
      create: (_) => BattlePageModel(comLevel),
      child: Consumer<BattlePageModel>(
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text('対戦中（LV.$comLevel）'),
              centerTitle: true,
            ),
            body: Center(
              child: CustomPaint(
                size: Size(100, 100),
                painter: CellPainter(CellType.batsu),
              ),
            ),
          );
        },
      ),
    );
  }
}