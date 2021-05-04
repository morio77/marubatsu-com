import 'cell_type_utils.dart';

class BattleResultUtils {
  /// 試合結果を調べて返す関数
  static BattleResult checkBattleResult(List<CellType> cellInfo) {

    bool _checkWinPattenMatch(List<CellType> cellInfo, CellType cellType) {

      // '111******', '***111***', '******111' かどうか
      final checkStartIndexes = [0, 3, 6];
      for (final checkStartIndex in checkStartIndexes) {
        if (cellInfo.getRange(checkStartIndex, checkStartIndex + 3).every((element) => element == cellType)) {
          return true;
        }
      }

      // '1**1**1**', '*1**1**1*', '**1**1**1' かどうか
      for (var startIndex = 0; startIndex < 3; startIndex++) {
        final indexSpace = 3;
        if (cellInfo[startIndex + (0 * indexSpace)] == cellType &&
            cellInfo[startIndex + (1 * indexSpace)] == cellType &&
            cellInfo[startIndex + (2 * indexSpace)] == cellType) {
          return true;
        }
      }

      // '1***1***1' かどうか
      if (cellInfo[0] == cellType &&
          cellInfo[4] == cellType &&
          cellInfo[8] == cellType) {
        return true;
      }

      // '**1*1*1**' かどうか
      if (cellInfo[2] == cellType &&
          cellInfo[4] == cellType &&
          cellInfo[6] == cellType) {
        return true;
      }

      // どのパターンにも当てはまらない場合、false
      return false;
    }

    // マルが勝っているか調べる
    if (_checkWinPattenMatch(cellInfo, CellType.maru)) {
      return BattleResult.maruWin;
    }

    // バツが勝っているか調べる
    if (_checkWinPattenMatch(cellInfo, CellType.batsu)) {
      return BattleResult.batsuWin;
    }

    // バトル中か、試合中か調べて返す
    return cellInfo.contains(CellType.none) ? BattleResult.undecided : BattleResult.draw;
  }
}

enum BattleResult {
  undecided,
  draw,
  maruWin,
  batsuWin,
}