import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/trip_repository.dart';
import 'trip_event.dart';
import 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final TripRepository tripRepository;

  TripBloc({required this.tripRepository}) : super(TripInitial()) {
    on<LoadSavedTripsEvent>(_onLoadSavedTrips);
    on<GenerateItineraryEvent>(_onGenerateItinerary);
    on<SaveTripEvent>(_onSaveTrip);
    on<DeleteTripEvent>(_onDeleteTrip);
  }

  void _onLoadSavedTrips(LoadSavedTripsEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    final result = await tripRepository.getSavedTrips();
    result.fold(
      (error) => emit(TripError(error)),
      (trips) => emit(TripLoaded(trips)),
    );
  }

  void _onGenerateItinerary(GenerateItineraryEvent event, Emitter<TripState> emit) async {
    emit(ItineraryGenerating());
    final result = await tripRepository.generateItinerary(event.tripPreferences);
    result.fold(
      (error) => emit(TripError(error)),
      (trip) => emit(ItineraryGenerated(trip)),
    );
  }

  void _onSaveTrip(SaveTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    final result = await tripRepository.saveTrip(event.trip);
    result.fold(
      (error) => emit(TripError(error)),
      (_) => add(LoadSavedTripsEvent()), // Reload trips after saving
    );
  }

  void _onDeleteTrip(DeleteTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    final result = await tripRepository.deleteTrip(event.tripId);
    result.fold(
      (error) => emit(TripError(error)),
      (_) => add(LoadSavedTripsEvent()), // Reload trips after deleting
    );
  }
}
