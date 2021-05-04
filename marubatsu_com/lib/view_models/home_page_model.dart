import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:marubatsu_com/utils/cell_type_utils.dart';

class HomePageModel extends ChangeNotifier {
  CellType ownCellType;

  /// コンストラクタ
  HomePageModel() : this.initialize();
  HomePageModel.initialize() {
    // 自分のセルタイプを取得する
    readOwnCellType();
  }

  CellType readOwnCellType() {
    final box = Hive.box('settings');
    ownCellType = box.get('own_cell_type');
    if (ownCellType == null || ownCellType == CellType.none) {
      ownCellType = CellType.maru;
      box.put('own_cell_type', ownCellType);
    }
    notifyListeners();
    return ownCellType;
  }

  // 自分のセルタイプを反転させる
  CellType reverseOwnCellType() {
    ownCellType = ownCellType == CellType.maru ? CellType.batsu : CellType.maru;
    final box = Hive.box('settings');
    box.put('own_cell_type', ownCellType);
    notifyListeners();
    return ownCellType;
  }
}