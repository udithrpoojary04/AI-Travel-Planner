import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/splash_screen.dart';
import '../../presentation/pages/onboarding_screen.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/trip/create_trip_page.dart';
import '../../presentation/pages/trip/trip_details_page.dart';
import '../../presentation/pages/trip/budget_dashboard_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../domain/entities/trip.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/create_trip',
        name: 'create_trip',
        builder: (context, state) => const CreateTripPage(),
      ),
      GoRoute(
        path: '/trip_details',
        name: 'trip_details',
        builder: (context, state) {
          final trip = state.extra as Trip;
          return TripDetailsPage(trip: trip);
        },
      ),
      GoRoute(
        path: '/budget_dashboard',
        name: 'budget_dashboard',
        builder: (context, state) {
          final trip = state.extra as Trip;
          return BudgetDashboardPage(trip: trip);
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
