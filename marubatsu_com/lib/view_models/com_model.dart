import 'package:marubatsu_com/utils/cell_type_utils.dart';

class ComModel {
  final int comLevel;
  final List<CellType> cellInfo;
  final CellType comCellType;

  ComModel(this.comLevel, this.cellInfo, this.comCellType);

  // 手を打った後のCellInfoを返す
  List<CellType> calcAndUpdateCellInfo () {
    return cellInfo..[0] = comCellType;
  }
}