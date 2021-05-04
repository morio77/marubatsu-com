import 'package:hive/hive.dart';

part 'cell_type_utils.g.dart';

@HiveType(typeId : 0)
enum CellType {
  @HiveField(0)
  none,

  @HiveField(1)
  maru,

  @HiveField(2)
  batsu,
}