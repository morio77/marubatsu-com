import 'package:flutter/material.dart';

class BattlePageModel extends ChangeNotifier {
  final comLevel;

  /// コンストラクタ
  BattlePageModel(int comLevel) : this.initialize(comLevel);
  BattlePageModel.initialize(this.comLevel) {
    print(comLevel);
  }
}