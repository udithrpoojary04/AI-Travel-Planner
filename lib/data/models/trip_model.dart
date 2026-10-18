import 'package:hive/hive.dart';
import '../../domain/entities/trip.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 0)
class TripModel extends Trip {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String destination;
  @HiveField(2)
  final DateTime startDate;
  @HiveField(3)
  final DateTime endDate;
  @HiveField(4)
  final double budget;
  @HiveField(5)
  final List<String> interests;
  @HiveField(6)
  final List<ItineraryDayModel> itineraryModel;
  @HiveField(7, defaultValue: <String>[])
  final List<String> packingList;

  const TripModel({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.interests,
    this.itineraryModel = const [],
    this.packingList = const [],
  }) : super(
          id: id,
          destination: destination,
          startDate: startDate,
          endDate: endDate,
          budget: budget,
          interests: interests,
          itinerary: itineraryModel,
          packingList: packingList,
        );

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] ?? '',
      destination: json['destination'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      interests: List<String>.from(json['interests'] ?? []),
      itineraryModel: (json['itinerary'] as List<dynamic>?)
              ?.map((e) => ItineraryDayModel.fromJson(e))
              .toList() ??
          [],
      packingList: List<String>.from(json['packingList'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'budget': budget,
      'interests': interests,
      'itinerary': itineraryModel.map((e) => e.toJson()).toList(),
      'packingList': packingList,
    };
  }

  factory TripModel.fromEntity(Trip trip) {
    return TripModel(
      id: trip.id,
      destination: trip.destination,
      startDate: trip.startDate,
      endDate: trip.endDate,
      budget: trip.budget,
      interests: trip.interests,
      itineraryModel: trip.itinerary
          .map((day) => ItineraryDayModel.fromEntity(day))
          .toList(),
      packingList: trip.packingList,
    );
  }
}

@HiveType(typeId: 1)
class ItineraryDayModel extends ItineraryDay {
  @HiveField(0)
  final int dayNumber;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final List<ActivityModel> activitiesModel;

  const ItineraryDayModel({
    required this.dayNumber,
    required this.date,
    required this.activitiesModel,
  }) : super(dayNumber: dayNumber, date: date, activities: activitiesModel);

  factory ItineraryDayModel.fromJson(Map<String, dynamic> json) {
    return ItineraryDayModel(
      dayNumber: json['dayNumber'] ?? 1,
      date: DateTime.parse(json['date']),
      activitiesModel: (json['activities'] as List<dynamic>?)
              ?.map((e) => ActivityModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'date': date.toIso8601String(),
      'activities': activitiesModel.map((e) => e.toJson()).toList(),
    };
  }

  factory ItineraryDayModel.fromEntity(ItineraryDay day) {
    return ItineraryDayModel(
      dayNumber: day.dayNumber,
      date: day.date,
      activitiesModel:
          day.activities.map((act) => ActivityModel.fromEntity(act)).toList(),
    );
  }
}

@HiveType(typeId: 2)
class ActivityModel extends Activity {
  @HiveField(0)
  final String time;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String? location;
  @HiveField(4)
  final double? costEstimate;

  const ActivityModel({
    required this.time,
    required this.title,
    required this.description,
    this.location,
    this.costEstimate,
  }) : super(
          time: time,
          title: title,
          description: description,
          location: location,
          costEstimate: costEstimate,
        );

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      time: json['time'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'],
      costEstimate: (json['costEstimate'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'title': title,
      'description': description,
      'location': location,
      'costEstimate': costEstimate,
    };
  }

  factory ActivityModel.fromEntity(Activity activity) {
    return ActivityModel(
      time: activity.time,
      title: activity.title,
      description: activity.description,
      location: activity.location,
      costEstimate: activity.costEstimate,
    );
  }
}
