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
        return _calcLevel3();
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

  List<CellType> _calcLevel3() {
    // CellTypeがnoneのセル(index)を抽出する
    final noneCellTypeIndexes = _pickNoneCellTypeIndexes();

    // リーチがあればそのIndexを返す関数（なければ-1を返却）
    int _reachCellIndex() {
      final comWinBattleResult = comCellType == CellType.maru ? BattleResult.maruWin : BattleResult.batsuWin;
      for (final noneCellTypeIndex in noneCellTypeIndexes) {
        final tmpUpdatedCellInfo = [...cellInfo]..[noneCellTypeIndex] = comCellType;
        if (BattleResultUtils.checkBattleResult(tmpUpdatedCellInfo) == comWinBattleResult) {
          return noneCellTypeIndex;
        }
      }
      return -1;
    }

    // 先手が後手で戦略が大きく異なる
    if (comCellType == CellType.maru) { /// 先手の場合

    }
    else if (comCellType == CellType.batsu) { /// 後手の場合
      final isMaruCount1 = [...cellInfo].where((cellType) => cellType == CellType.maru).length == 1;
      final doesMaruPlacesCenter = cellInfo[4] == CellType.maru;
      final doesMaruPlacedCorner = (cellInfo[0] == CellType.maru || cellInfo[2] == CellType.maru || cellInfo[6] == CellType.maru || cellInfo[8] == CellType.maru);
      final doesMaruPlacedSide = (cellInfo[1] == CellType.maru || cellInfo[3] == CellType.maru || cellInfo[5] == CellType.maru || cellInfo[7] == CellType.maru);
      // 1手目かつ、「中」にマルが置かれた場合
      if (isMaruCount1 && doesMaruPlacesCenter) {
        // 「角」のどこかに置く
        final cornerIndexes = [0, 2, 6, 8];
        cornerIndexes.shuffle();
        return [...cellInfo]..[cornerIndexes[0]] = CellType.batsu;
      } // 1手目かつ、「角」にマルが置かれた場合
      else if (isMaruCount1 && doesMaruPlacedCorner) {
        // 「中」に置く
        return [...cellInfo]..[4] = CellType.batsu;
      } // 1手目かつ、「辺」にマルが置かれた場合
      else if (isMaruCount1 && doesMaruPlacedSide) {
        // 「中」もしくは「マルから見て縦横方向すべてのどこか(T.B.D.)」に置く
        return [...cellInfo]..[4] = CellType.batsu;
      }
      else { // リーチのマスがあればそこに置いて、そうでなければ、相手のリーチを潰す。それもなければランダム
        return _reachCellIndex() != -1 ? ([...cellInfo]..[_reachCellIndex()] = CellType.batsu) : _calcLevel2();
      }
    }

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