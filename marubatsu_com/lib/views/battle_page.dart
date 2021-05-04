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
              // title: Text('対戦中（LV.$comLevel）'),
              title: Text(model.battleResult.toString()),
              centerTitle: true,
            ),
            body: Center(
              child: BattleField(model),
            ),
          );
        },
      ),
    );
  }

  Widget BattleField(BattlePageModel model) {
    /// 一つのセルを表すウィジェット
    Widget _cell(CellType cellType, index) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1.0),
          color: Colors.white54,
        ),
        child: cellType == CellType.none ? Material(
          color: Colors.orange,
          child: model.isSelfTurn() ? InkWell(
            onTap: () => {
              model.cellTapped(index),
            },
          ) : Container(),
        ) : Center(
          child: CustomPaint(
            size: Size(50, 50),
            painter: CellPainter(cellType),
          ),
        ),
      );
    }

    final gridViewList = List.generate(9, (index) => _cell(model.battleModel.cellInfo[index], index));

    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      children: gridViewList,
    );
  }
}