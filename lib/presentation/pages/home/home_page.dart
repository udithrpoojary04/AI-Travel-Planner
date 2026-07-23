import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/trip.dart';
import '../../bloc/trip/trip_bloc.dart';
import '../../bloc/trip/trip_state.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequestedEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<TripBloc, TripState>(
        builder: (context, state) {
          if (state is TripLoading || state is TripInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TripLoaded) {
            if (state.trips.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.flight_takeoff, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No trips planned yet.',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Text('Tap + to let AI plan your next adventure!'),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.trips.length,
              itemBuilder: (context, index) {
                final trip = state.trips[index];
                return TripCard(trip: trip);
              },
            );
          } else if (state is TripError) {
            return Center(child: Text(state.message));
          }
          
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/create_trip');
        },
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  final Trip trip;
  
  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.push('/trip_details', extra: trip);
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trip.destination,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '\${DateFormat('MMM d').format(trip.startDate)} - \${DateFormat('MMM d, yyyy').format(trip.endDate)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Budget: \$\${trip.budget.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
