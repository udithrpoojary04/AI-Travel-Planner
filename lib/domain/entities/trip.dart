import 'package:equatable/equatable.dart';

class Trip extends Equatable {
  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final List<String> interests;
  final List<ItineraryDay> itinerary;
  final List<String> packingList;

  const Trip({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.interests,
    this.itinerary = const [],
    this.packingList = const [],
  });

  @override
  List<Object?> get props => [
        id,
        destination,
        startDate,
        endDate,
        budget,
        interests,
        itinerary,
        packingList,
      ];
}

class ItineraryDay extends Equatable {
  final int dayNumber;
  final DateTime date;
  final List<Activity> activities;

  const ItineraryDay({
    required this.dayNumber,
    required this.date,
    required this.activities,
  });

  @override
  List<Object?> get props => [dayNumber, date, activities];
}

class Activity extends Equatable {
  final String time;
  final String title;
  final String description;
  final String? location;
  final double? costEstimate;

  const Activity({
    required this.time,
    required this.title,
    required this.description,
    this.location,
    this.costEstimate,
  });

  @override
  List<Object?> get props => [time, title, description, location, costEstimate];
}
