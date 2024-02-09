// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_count.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LikeCountAdapter extends TypeAdapter<LikeCount> {
  @override
  final int typeId = 1;

  @override
  LikeCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LikeCount(
      likeCount: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LikeCount obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.likeCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LikeCountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
