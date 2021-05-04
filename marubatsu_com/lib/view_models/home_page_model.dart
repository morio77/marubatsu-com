import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:marubatsu_com/utils/cell_type_utils.dart';

class HomePageModel extends ChangeNotifier {
  var ownCellType;

  /// コンストラクタ
  HomePageModel() : this.initialize();
  HomePageModel.initialize() {
    // 自分のセルタイプを取得する
    readOwnCellType();
  }

  Future<void> readOwnCellType() async {
    final box = Hive.box('settings');
    ownCellType = box.get('own_cell_type');
    print(ownCellType);
    if (ownCellType == null) {
      ownCellType = CellType.maru;
      box.put('own_cell_type', CellType.maru);
    }
    print(box.get('own_cell_type'));
  }
}