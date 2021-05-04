import 'dart:math';

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
        break;
      case 3:
        break;
    }
    return cellInfo..[0] = comCellType;
  }

  List<CellType> _calcLevel1() {
    // CellTypeがnoneのセル(index)を抽出する
    var noneCellTypeIndexes = <int>[];
    for (var index = 0; index < cellInfo.length ; index++) {
      if (cellInfo[index] == CellType.none) {
        noneCellTypeIndexes.add(index);
      }
    }

    // CellTypeがnoneのセルのうち、ランダムに選んだ1マスを埋めてCellInfoを更新する
    noneCellTypeIndexes.shuffle();
    final updateIndex = noneCellTypeIndexes[0];
    return cellInfo..[updateIndex] = comCellType;
  }
}