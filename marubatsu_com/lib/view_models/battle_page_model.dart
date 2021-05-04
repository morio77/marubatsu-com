import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:marubatsu_com/utils/cell_type_utils.dart';
import 'package:marubatsu_com/view_models/battle_model.dart';

class BattlePageModel extends ChangeNotifier {
  BattleModel battleModel;

  /// コンストラクタ
  BattlePageModel(int comLevel) : this.initialize(comLevel);
  BattlePageModel.initialize(int comLevel) {
    // バトルモデルを作成
    final box = Hive.box('settings');
    final ownCellType = box.get('own_cell_type');
    battleModel = BattleModel(comLevel, ownCellType, List.generate(9, (index) => CellType.none), CellType.maru);
    notifyListeners();

    // COMのターンの場合のみ、COMに手を打たせる
    if (ownCellType != battleModel.cellTypeInTurn) {
      comTurn;
    }
  }

  /// 自分がセルをタップされた時に呼ばれる
  void cellTapped(int index) {

  }

  /// コンピュータのターンになったら呼ばれる
  void comTurn() {
    // 次に打つ手を計算する

    // バトルモデルを更新する

  }

}