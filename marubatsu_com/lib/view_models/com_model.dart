import 'dart:math';

import 'package:marubatsu_com/utils/battle_result_utils.dart';
import 'package:marubatsu_com/utils/cell_type_utils.dart';

class ComModel {
  final int comLevel;
  final List<CellType> cellInfo;
  final CellType comCellType;

  ComModel(this.comLevel, this.cellInfo, this.comCellType);

  // 手を打った後のCellInfoを返す
  List<CellType> calcAndUpdateCellInfo () {
    switch (comLevel) {
      case 1:
        return _calcLevel1();
        break;
      case 2:
        return _calcLevel2();
        break;
      case 3:
        break;
    }
    return [...cellInfo]..[0] = comCellType;
  }

  List<CellType> _calcLevel1() {
    // CellTypeがnoneのセル(index)を抽出する
    final noneCellTypeIndexes = _pickNoneCellTypeIndexes();

    // CellTypeがnoneのセルのうち、ランダムに選んだ1マスを埋めてCellInfoを更新する
    noneCellTypeIndexes.shuffle();
    final updateIndex = noneCellTypeIndexes[0];
    return [...cellInfo]..[updateIndex] = comCellType;
  }

  List<CellType> _calcLevel2() {
    // CellTypeがnoneのセル(index)を抽出する
    final noneCellTypeIndexes = _pickNoneCellTypeIndexes();

    // 相手のリーチをつぶすセルがあれば、そこに配置
    // (1マスずつ相手のセルタイプを配置し、ビンゴになればそこがリーチポイント)
    final operatorCellType = comCellType == CellType.maru ? CellType.batsu : CellType.maru;
    final operatorWinBattleResult = operatorCellType == CellType.maru ? BattleResult.maruWin : BattleResult.batsuWin;
    for (final noneCellTypeIndex in noneCellTypeIndexes) {
      final tmpUpdatedCellInfo = [...cellInfo]..[noneCellTypeIndex] = operatorCellType;
      if (BattleResultUtils.checkBattleResult(tmpUpdatedCellInfo) == operatorWinBattleResult) {
        return [...cellInfo]..[noneCellTypeIndex] = comCellType;
      }
    }

    // 相手のリーチがなければ、ランダムに配置
    noneCellTypeIndexes.shuffle();
    final updateIndex = noneCellTypeIndexes[0];
    return cellInfo..[updateIndex] = comCellType;
  }

  // CellTypeがnoneのセル(index)を抽出する
  List<int> _pickNoneCellTypeIndexes() {
    var noneCellTypeIndexes = <int>[];
    for (var index = 0; index < cellInfo.length ; index++) {
      if (cellInfo[index] == CellType.none) {
        noneCellTypeIndexes.add(index);
      }
    }
    return noneCellTypeIndexes;
  }
}