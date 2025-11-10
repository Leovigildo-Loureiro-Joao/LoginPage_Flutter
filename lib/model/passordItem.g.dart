// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passordItem.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PasswordItemAdapter extends TypeAdapter<PasswordItem> {
  @override
  final int typeId = 0;

  @override
  PasswordItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PasswordItem(
      id: fields[0] as String,
      title: fields[1] as String,
      username: fields[2] as String,
      encryptedPassword: fields[3] as String,
      website: fields[4] as String,
      iconName: fields[5] as String,
      strength: fields[6] as int,
      category: fields[7] as String,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PasswordItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.encryptedPassword)
      ..writeByte(4)
      ..write(obj.website)
      ..writeByte(5)
      ..write(obj.iconName)
      ..writeByte(6)
      ..write(obj.strength)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
