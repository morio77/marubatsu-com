import 'package:flutter/cupertino.dart';
import 'package:marubatsu_com/utils/cell_type_utils.dart';

@immutable
class BattleModel {
  final int comLevel;
  final CellType ownCellType;
  final List<CellType> cellInfo;
  final CellType cellTypeInTurn;

  BattleModel(this.comLevel, this.ownCellType, this.cellInfo, this.cellTypeInTurn);

  BattleModel copyWith({
    final int comLevel,
    final CellType ownCellType,
    final List<CellType> cellInfo,
    final CellType cellTypeInTurn,
  }) {
    return BattleModel(
      comLevel ?? this.comLevel,
      ownCellType ?? this.ownCellType,
      cellInfo ?? this.cellInfo,
      cellTypeInTurn ?? this.cellTypeInTurn,
    );
  }
}