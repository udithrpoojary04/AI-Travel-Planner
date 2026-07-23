import 'package:dartz/dartz.dart';
import '../entities/trip.dart';

abstract class TripRepository {
  Future<Either<String, Trip>> generateItinerary(Trip tripPreferences);
  Future<Either<String, List<Trip>>> getSavedTrips();
  Future<Either<String, void>> saveTrip(Trip trip);
  Future<Either<String, void>> deleteTrip(String tripId);
}
