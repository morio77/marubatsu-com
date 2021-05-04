// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell_type_utils.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CellTypeAdapter extends TypeAdapter<CellType> {
  @override
  final int typeId = 0;

  @override
  CellType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CellType.none;
      case 1:
        return CellType.maru;
      case 2:
        return CellType.batsu;
      default:
        return CellType.none;
    }
  }

  @override
  void write(BinaryWriter writer, CellType obj) {
    switch (obj) {
      case CellType.none:
        writer.writeByte(0);
        break;
      case CellType.maru:
        writer.writeByte(1);
        break;
      case CellType.batsu:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CellTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
