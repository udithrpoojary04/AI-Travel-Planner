import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'data/datasources/trip_local_data_source.dart';
import 'data/datasources/trip_remote_data_source.dart';
import 'data/datasources/places_remote_data_source.dart';
import 'data/datasources/weather_remote_data_source.dart';
import 'data/models/trip_model.dart';
import 'data/models/expense_model.dart';
import 'data/datasources/expense_local_data_source.dart';
import 'data/repositories/trip_repository_impl.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'domain/repositories/trip_repository.dart';
import 'domain/repositories/expense_repository.dart';
import 'presentation/bloc/trip/trip_bloc.dart';
import 'presentation/bloc/expense/expense_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => TripBloc(tripRepository: sl()));
  sl.registerFactory(() => ExpenseBloc(expenseRepository: sl()));

  // Repository
  sl.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TripRemoteDataSource>(
    () => TripRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<TripLocalDataSource>(
    () => TripLocalDataSourceImpl(tripBox: sl()),
  );

  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(expenseBox: sl()),
  );

  sl.registerLazySingleton<PlacesRemoteDataSource>(
    () => PlacesRemoteDataSource(client: sl()),
  );

  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSource(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());

  // Hive Box
  Hive.registerAdapter(TripModelAdapter());
  Hive.registerAdapter(ItineraryDayModelAdapter());
  Hive.registerAdapter(ActivityModelAdapter());
  Hive.registerAdapter(ExpenseModelAdapter());
  
  final tripBox = await Hive.openBox<TripModel>('trips');
  sl.registerLazySingleton<Box<TripModel>>(() => tripBox);

  final expenseBox = await Hive.openBox<ExpenseModel>('expenses');
  sl.registerLazySingleton<Box<ExpenseModel>>(() => expenseBox);
}
