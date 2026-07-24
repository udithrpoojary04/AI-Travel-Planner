import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/loading_shimmer.dart';
import '../../../domain/entities/trip.dart';
import '../../bloc/trip/trip_bloc.dart';
import '../../bloc/trip/trip_state.dart';
import '../../../core/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('My Adventures'),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              context.push('/profile');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.background, Color(0xFF1E1B4B)],
              ),
            ),
          ),
          // Glow effect
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withOpacity(0.15),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(duration: 4.seconds, begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
          ),
          SafeArea(
            child: BlocBuilder<TripBloc, TripState>(
              builder: (context, state) {
                if (state is TripLoading || state is TripInitial) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: 3,
                    itemBuilder: (context, index) => const ShimmerCard(height: 120),
                  );
                } else if (state is TripLoaded) {
                  if (state.trips.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppTheme.surface.withOpacity(0.5),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white10),
                            ),
                            child: const Icon(Icons.travel_explore, size: 64, color: AppTheme.primary),
                          ).animate().scale(delay: 200.ms).fadeIn(),
                          const SizedBox(height: 24),
                          Text(
                            'No adventures yet.',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                          ).animate().slideY(begin: 0.2).fadeIn(delay: 300.ms),
                          const SizedBox(height: 8),
                          Text(
                            'Tap + to let AI plan your dream trip!',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ).animate().slideY(begin: 0.2).fadeIn(delay: 400.ms),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: state.trips.length,
                    itemBuilder: (context, index) {
                      final trip = state.trips[index];
                      return TripCard(trip: trip)
                          .animate()
                          .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                          .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
                    },
                  );
                } else if (state is TripError) {
                  return Center(child: Text(state.message, style: const TextStyle(color: AppTheme.secondary)));
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/create_trip');
        },
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Trip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ).animate().slideY(begin: 1.0).fadeIn(delay: 500.ms),
    );
  }
}

class TripCard extends StatelessWidget {
  final Trip trip;
  
  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.push('/trip_details', extra: trip);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            trip.destination,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 16, color: AppTheme.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          "${DateFormat('MMM d').format(trip.startDate)} - ${DateFormat('MMM d, yyyy').format(trip.endDate)}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.currency_rupee, size: 16, color: AppTheme.primaryGradientEnd),
                        const SizedBox(width: 8),
                        Text(
                          'Budget: ₹${trip.budget.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
