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
    int _reachCellIndex(List<CellType> cellInfo, CellType checkCellType) {
      final WinBattleResult = checkCellType == CellType.maru ? BattleResult.maruWin : BattleResult.batsuWin;
      for (final noneCellTypeIndex in noneCellTypeIndexes) {
        final tmpUpdatedCellInfo = [...cellInfo]..[noneCellTypeIndex] = checkCellType;
        if (BattleResultUtils.checkBattleResult(tmpUpdatedCellInfo) == WinBattleResult) {
          return noneCellTypeIndex;
        }
      }
      return -1;
    }

    // ダブルリーチを取ることができるセルがあれば、そのIndexを返す関数（なければ-1を返却）
    int _checkCanGetDoubleReach(List<CellType> cellInfo, CellType checkCellType) {
      final WinBattleResult = checkCellType == CellType.maru ? BattleResult.maruWin : BattleResult.batsuWin;
      for (final noneCellTypeIndex in noneCellTypeIndexes) {
        var reachCount = 0;
        final tmpUpdatedCellInfo = [...cellInfo]..[noneCellTypeIndex] = checkCellType;
        for (final noneCellTypeIndex2 in noneCellTypeIndexes) {
          if (BattleResultUtils.checkBattleResult([...tmpUpdatedCellInfo]..[noneCellTypeIndex2] = checkCellType) == WinBattleResult) {
            reachCount++;
            if (reachCount >= 2) {
              return noneCellTypeIndex;
            }
          }
        }
      }
      return -1;
    }

    // リーチを取ることができるセルがあれば、そのIndexを返す関数（なければ-1を返却）
    int _checkCanGetReach(List<CellType> cellInfo, CellType checkCellType) {
      final WinBattleResult = checkCellType == CellType.maru ? BattleResult.maruWin : BattleResult.batsuWin;
      for (final noneCellTypeIndex in noneCellTypeIndexes) {
        final tmpUpdatedCellInfo = [...cellInfo]..[noneCellTypeIndex] = checkCellType;
        for (final noneCellTypeIndex2 in noneCellTypeIndexes) {
          if (BattleResultUtils.checkBattleResult([...tmpUpdatedCellInfo]..[noneCellTypeIndex2] = checkCellType) == WinBattleResult) {
            return noneCellTypeIndex;
          }
        }
      }
      return -1;
    }

    // 先手が後手で戦略が大きく異なる
    /// == 先手の場合 ここから ==
    if (comCellType == CellType.maru) {
      final doesBatsuPlacesCenter = cellInfo[4] == CellType.batsu;
      final doesBatsuPlacedSide = (cellInfo[1] == CellType.batsu || cellInfo[3] == CellType.batsu || cellInfo[5] == CellType.batsu || cellInfo[7] == CellType.batsu);
      final doesMaruPlacedCorner = (cellInfo[0] == CellType.maru || cellInfo[2] == CellType.maru || cellInfo[6] == CellType.maru || cellInfo[8] == CellType.maru);
      final doesMaruPlacedSide = (cellInfo[1] == CellType.maru || cellInfo[3] == CellType.maru || cellInfo[5] == CellType.maru || cellInfo[7] == CellType.maru);

      final isFirstTurn = cellInfo.every((cellType) => cellType == CellType.none);
      final isSecondTurn = [...cellInfo].where((cellType) => cellType == CellType.maru).length == 1;
      // 初手の場合
      if (isFirstTurn) {
        // ランダムに置く
        final noneCellTypeIndexes = List.generate(9, (index) => index);
        noneCellTypeIndexes.shuffle();
        return [...cellInfo]..[noneCellTypeIndexes[0]] = CellType.maru;
      }

      // 2手目の場合
      else if (isSecondTurn) {
        // 1手目で「中」に置いていて、かつ、相手が「辺」に置いた場合
        if (cellInfo[4] == CellType.maru && doesBatsuPlacedSide) {
          // 「辺」かつリーチになるセルに置く
          final sideCellIndexed = [1, 3, 5, 7];
          sideCellIndexed.shuffle();
          for (final index in sideCellIndexed) {
            if (cellInfo[index] == CellType.none &&  _reachCellIndex([...cellInfo]..[index] = CellType.maru, CellType.maru) != -1) {
              return [...cellInfo]..[index] = CellType.maru;
            }
          }
        }

        // 1手目で「角」「辺」に置いていて、かつ、相手が「中」以外に置いた場合
        else if ((doesMaruPlacedCorner || doesMaruPlacedSide) && !doesBatsuPlacesCenter) {
          // 「中」に置く
          return [...cellInfo]..[4] = CellType.maru;
        }
      }

      // 上記のどれにも当てはまらない場合
      // 勝てるセルがあれば、そこに置く
      if (_reachCellIndex(cellInfo, CellType.maru) != -1) {
        return [...cellInfo]..[_reachCellIndex(cellInfo, CellType.maru)] = CellType.maru;
      }

      // 相手にリーチがあれば、そこに置く
      else if (_reachCellIndex(cellInfo, CellType.batsu) != -1) {
        return [...cellInfo]..[_reachCellIndex(cellInfo, CellType.batsu)] = CellType.maru;
      }

      // 相手にダブルリーチを取られそうなら、そこに置く
      else if (_checkCanGetDoubleReach(cellInfo, CellType.batsu) != -1) {
        return [...cellInfo]..[_checkCanGetDoubleReach(cellInfo, CellType.batsu)] = CellType.maru;
      }

      // ダブルリーチを取れるなら、そこに置く
      else if (_checkCanGetDoubleReach(cellInfo, CellType.maru) != -1) {
        return [...cellInfo]..[_checkCanGetDoubleReach(cellInfo, CellType.maru)] = CellType.maru;
      }

      // リーチを取れるなら、そこに置く
      else if (_checkCanGetReach(cellInfo, CellType.maru) != -1) {
        return [...cellInfo]..[_checkCanGetReach(cellInfo, CellType.maru)] = CellType.maru;
      }

      // 上記以外は、ランダムに置く
      else {
        final noneCellTypeIndexes = _pickNoneCellTypeIndexes();
        noneCellTypeIndexes.shuffle();
        return [...cellInfo]..[noneCellTypeIndexes[0]] = CellType.maru;
      }
    }
    /// == 先手の場合 ここまで ==

    /// == 後手の場合 ここから ==
    else if (comCellType == CellType.batsu) {
      final isMaruCount1 = [...cellInfo].where((cellType) => cellType == CellType.maru).length == 1;
      final isMaruCount2 = [...cellInfo].where((cellType) => cellType == CellType.maru).length == 2;
      final doesMaruPlacesCenter = cellInfo[4] == CellType.maru;
      final doesMaruPlacedCorner = (cellInfo[0] == CellType.maru || cellInfo[2] == CellType.maru || cellInfo[6] == CellType.maru || cellInfo[8] == CellType.maru);
      final doesMaruPlacedDiagonalCorner = ((cellInfo[0] == CellType.maru && cellInfo[8] == CellType.maru) || (cellInfo[2] == CellType.maru && cellInfo[6] == CellType.maru));
      final doesMaruPlacedSide = (cellInfo[1] == CellType.maru || cellInfo[3] == CellType.maru || cellInfo[5] == CellType.maru || cellInfo[7] == CellType.maru);

      // 1手目かつ、「中」にマルが置かれた場合
      if (isMaruCount1 && doesMaruPlacesCenter) {
        // 「角」のどこかに置く
        final cornerIndexes = [0, 2, 6, 8];
        cornerIndexes.shuffle();
        return [...cellInfo]..[cornerIndexes[0]] = CellType.batsu;
      }

      // 1手目かつ、「角」にマルが置かれた場合
      else if (isMaruCount1 && doesMaruPlacedCorner) {
        // 「中」に置く
        return [...cellInfo]..[4] = CellType.batsu;
      }

      // 1手目かつ、「辺」にマルが置かれた場合
      else if (isMaruCount1 && doesMaruPlacedSide) {
        // 「中」もしくは「マルから見て縦横方向すべてのどこか(T.B.D.)」に置く
        return [...cellInfo]..[4] = CellType.batsu;
      }

      // 2手目でかつ、対角の「角」にマルが置かれた場合
      if (isMaruCount2 && doesMaruPlacedDiagonalCorner) {
        // 「辺」のどこかに置く
        final cornerIndexes = [1, 3, 5, 7];
        cornerIndexes.shuffle();
        return [...cellInfo]..[cornerIndexes[0]] = CellType.batsu;
      }

      // リーチのマスがあればそこに置いて終了、そうでなければ、相手のリーチを潰す。それもなければランダム
      else {
        return _reachCellIndex(cellInfo, CellType.batsu) != -1 ? ([...cellInfo]..[_reachCellIndex(cellInfo, CellType.batsu)] = CellType.batsu) : _calcLevel2();
      }
    }
    /// == 後手の場合 ここまで ==

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