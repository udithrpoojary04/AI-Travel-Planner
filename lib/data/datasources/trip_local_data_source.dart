import 'package:hive/hive.dart';
import '../models/trip_model.dart';

abstract class TripLocalDataSource {
  Future<List<TripModel>> getSavedTrips();
  Future<void> saveTrip(TripModel trip);
  Future<void> deleteTrip(String id);
}

class TripLocalDataSourceImpl implements TripLocalDataSource {
  final Box<TripModel> tripBox;

  TripLocalDataSourceImpl({required this.tripBox});

  @override
  Future<List<TripModel>> getSavedTrips() async {
    return tripBox.values.toList();
  }

  @override
  Future<void> saveTrip(TripModel trip) async {
    await tripBox.put(trip.id, trip);
  }

  @override
  Future<void> deleteTrip(String id) async {
    await tripBox.delete(id);
  }
}
