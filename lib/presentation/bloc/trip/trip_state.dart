import 'package:equatable/equatable.dart';
import '../../../../domain/entities/trip.dart';

abstract class TripState extends Equatable {
  const TripState();

  @override
  List<Object?> get props => [];
}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<Trip> trips;

  const TripLoaded(this.trips);

  @override
  List<Object?> get props => [trips];
}

class ItineraryGenerating extends TripState {}

class ItineraryGenerated extends TripState {
  final Trip generatedTrip;

  const ItineraryGenerated(this.generatedTrip);

  @override
  List<Object?> get props => [generatedTrip];
}

class TripError extends TripState {
  final String message;

  const TripError(this.message);

  @override
  List<Object?> get props => [message];
}
