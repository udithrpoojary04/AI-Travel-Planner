// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripModelAdapter extends TypeAdapter<TripModel> {
  @override
  final int typeId = 0;

  @override
  TripModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripModel(
      id: fields[0] as String,
      destination: fields[1] as String,
      startDate: fields[2] as DateTime,
      endDate: fields[3] as DateTime,
      budget: fields[4] as double,
      interests: (fields[5] as List).cast<String>(),
      itineraryModel: (fields[6] as List).cast<ItineraryDayModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, TripModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.destination)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.budget)
      ..writeByte(5)
      ..write(obj.interests)
      ..writeByte(6)
      ..write(obj.itineraryModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItineraryDayModelAdapter extends TypeAdapter<ItineraryDayModel> {
  @override
  final int typeId = 1;

  @override
  ItineraryDayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItineraryDayModel(
      dayNumber: fields[0] as int,
      date: fields[1] as DateTime,
      activitiesModel: (fields[2] as List).cast<ActivityModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ItineraryDayModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dayNumber)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.activitiesModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItineraryDayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityModelAdapter extends TypeAdapter<ActivityModel> {
  @override
  final int typeId = 2;

  @override
  ActivityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityModel(
      time: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      location: fields[3] as String?,
      costEstimate: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.costEstimate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
