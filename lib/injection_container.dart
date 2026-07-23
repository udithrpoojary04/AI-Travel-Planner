import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'data/datasources/trip_local_data_source.dart';
import 'data/datasources/trip_remote_data_source.dart';
import 'data/models/trip_model.dart';
import 'data/repositories/trip_repository_impl.dart';
import 'domain/repositories/trip_repository.dart';
import 'presentation/bloc/trip/trip_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => TripBloc(tripRepository: sl()));

  // Repository
  sl.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TripRemoteDataSource>(
    () => TripRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<TripLocalDataSource>(
    () => TripLocalDataSourceImpl(tripBox: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());

  // Hive Box
  Hive.registerAdapter(TripModelAdapter());
  Hive.registerAdapter(ItineraryDayModelAdapter());
  Hive.registerAdapter(ActivityModelAdapter());
  
  final tripBox = await Hive.openBox<TripModel>('trips');
  sl.registerLazySingleton<Box<TripModel>>(() => tripBox);
}
