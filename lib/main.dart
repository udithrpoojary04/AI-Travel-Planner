import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'firebase_options.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/bloc/trip/trip_bloc.dart';
import 'presentation/bloc/trip/trip_event.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize Dependency Injection
  await di.init();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (context) => di.sl<TripBloc>()..add(LoadSavedTripsEvent()),
        ),
      ],
      child: const AITravelPlannerApp(),
    ),
  );
}

class AITravelPlannerApp extends StatelessWidget {
  const AITravelPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI Travel Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
