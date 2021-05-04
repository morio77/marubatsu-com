import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marubatsu_com/utils/cell_type_utils.dart';
import 'package:marubatsu_com/view_models/home_page_model.dart';
import 'package:marubatsu_com/views/battle_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomePageModel>(
      create: (_) => HomePageModel(),
      child: Consumer<HomePageModel>(
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text('マルバツ対戦（対COM）'),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ownCellTypeText(model),
                  selectComLevelButtons(context),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => model.reverseOwnCellType(),
              child: Icon(Icons.swap_calls),
            ),
          );
        },
      ),
    );
  }

  Widget ownCellTypeText(HomePageModel model) {
    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(),
        )
      ),
      child: Text(
        model.ownCellType == CellType.maru
            ? '先行（◯）で対戦します'
            : '後攻（×）で対戦します',
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }

  Widget selectComLevelButtons(BuildContext context) {
    var buttonList = <Widget>[];
    final levels = [1, 2, 3];
    for (final level in levels) {
      buttonList.add(
        ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed(BattlePage.routeName, arguments: {'comLevel': level}),
          child: Text('Lv.$level'),
        ),
      );
    }

    return Container(
      child: Column(
        children: buttonList,
      ),
    );
  }

}