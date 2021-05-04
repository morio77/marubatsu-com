import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:marubatsu_com/utils/battle_result_utils.dart';
import 'package:marubatsu_com/utils/cell_type_utils.dart';
import 'package:marubatsu_com/view_models/battle_model.dart';
import 'package:marubatsu_com/view_models/com_model.dart';

class BattlePageModel extends ChangeNotifier {
  CellType ownCellType;
  BattleModel battleModel;
  BattleResult battleResult = BattleResult.undecided;

  /// コンストラクタ
  BattlePageModel(int comLevel) : this.initialize(comLevel);
  BattlePageModel.initialize(int comLevel) {
    // バトルモデルを作成
    final box = Hive.box('settings');
    ownCellType = box.get('own_cell_type');
    battleModel = BattleModel(comLevel, ownCellType, List.generate(9, (index) => CellType.none), CellType.maru);
    notifyListeners();

    // COMのターンの場合のみ、COMに手を打たせる
    if (ownCellType != battleModel.cellTypeInTurn) {
      _comTurn();
    }
  }

  /// 自分がセルをタップされた時に呼ばれる
  Future<void> cellTapped(int index) async {
    // バトルモデルを更新する
    final cellTypeNextTurn = ownCellType == CellType.maru ? CellType.batsu : CellType.maru;
    final updatedCellInfo = battleModel.cellInfo..[index] = ownCellType;
    battleModel = battleModel.copyWith(cellInfo: updatedCellInfo, cellTypeInTurn: cellTypeNextTurn);
    notifyListeners();

    // 決着かついたかどうか調べる
    _checkBattleResult();

    // 決着がついていなければ、コンピュータに入力させる
    if (battleResult == BattleResult.undecided) {
      await _comTurn();
    }
  }

  /// コンピュータのターンになったら呼ばれる
  Future<void> _comTurn() async {
    // ちょっと待つ
    await Future.delayed(Duration(milliseconds: 500));

    // 次に打つ手を計算する
    final comCellType = ownCellType == CellType.maru ? CellType.batsu : CellType.maru;
    final comModel = ComModel(battleModel.comLevel, battleModel.cellInfo, comCellType);
    final updatedCellInfo = comModel.calcAndUpdateCellInfo();

    // バトルモデルを更新する
    battleModel = battleModel.copyWith(cellInfo: updatedCellInfo, cellTypeInTurn: ownCellType);

    notifyListeners();

    // 決着かついたかどうか調べる
    _checkBattleResult();
  }

  /// 決着かついたかどうか調べる
  void _checkBattleResult() {
    battleResult = BattleResultUtils.checkBattleResult(battleModel.cellInfo);
    notifyListeners();
  }

  /// 自分のターンかどうか調べて返す
  bool isSelfTurn() {
    return battleModel.cellTypeInTurn == ownCellType ? true : false;
  }

}