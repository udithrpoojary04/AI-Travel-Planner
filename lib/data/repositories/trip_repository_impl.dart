import 'package:dartz/dartz.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_local_data_source.dart';
import '../datasources/trip_remote_data_source.dart';
import '../models/trip_model.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;
  final TripLocalDataSource localDataSource;

  TripRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, Trip>> generateItinerary(Trip tripPreferences) async {
    try {
      final tripModel = await remoteDataSource.generateItinerary(tripPreferences);
      return Right(tripModel);
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        return const Left('No internet connection. Please connect to Wi-Fi or Cellular to plan a trip.');
      }
      return Left('Failed to generate itinerary: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<Trip>>> getSavedTrips() async {
    try {
      final localTrips = await localDataSource.getSavedTrips();
      return Right(localTrips);
    } catch (e) {
      return Left('Failed to fetch saved trips: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> saveTrip(Trip trip) async {
    try {
      final tripModel = TripModel.fromEntity(trip);
      await localDataSource.saveTrip(tripModel);
      return const Right(null);
    } catch (e) {
      return Left('Failed to save trip: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deleteTrip(String tripId) async {
    try {
      await localDataSource.deleteTrip(tripId);
      return const Right(null);
    } catch (e) {
      return Left('Failed to delete trip: ${e.toString()}');
    }
  }
}
