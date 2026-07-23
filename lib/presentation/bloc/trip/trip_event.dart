import 'package:equatable/equatable.dart';
import '../../../../domain/entities/trip.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedTripsEvent extends TripEvent {}

class GenerateItineraryEvent extends TripEvent {
  final Trip tripPreferences;

  const GenerateItineraryEvent(this.tripPreferences);

  @override
  List<Object?> get props => [tripPreferences];
}

class SaveTripEvent extends TripEvent {
  final Trip trip;

  const SaveTripEvent(this.trip);

  @override
  List<Object?> get props => [trip];
}

class DeleteTripEvent extends TripEvent {
  final String tripId;

  const DeleteTripEvent(this.tripId);

  @override
  List<Object?> get props => [tripId];
}
