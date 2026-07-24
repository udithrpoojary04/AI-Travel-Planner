import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/entities/trip.dart';
import '../../../data/datasources/places_remote_data_source.dart';
import '../../../injection_container.dart' as di;
import '../../bloc/trip/trip_bloc.dart';
import '../../bloc/trip/trip_event.dart';
import '../../bloc/trip/trip_state.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _budgetController = TextEditingController();
  final _interestsController = TextEditingController(); // Comma separated

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _destinationController.dispose();
    _budgetController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)), // 2 years ahead
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Plan New Adventure'),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
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
            top: 50,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondary.withOpacity(0.15),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(duration: 4.seconds, begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
          ),
          SafeArea(
            child: BlocConsumer<TripBloc, TripState>(
              listener: (context, state) {
                if (state is ItineraryGenerated) {
                  context.read<TripBloc>().add(SaveTripEvent(state.generatedTrip));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Trip successfully generated!')),
                  );
                  context.go('/home');
                } else if (state is TripError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Where to next?',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _destinationController,
                          decoration: const InputDecoration(
                            labelText: 'Destination (City, Country)',
                            prefixIcon: Icon(Icons.location_on_outlined),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () => _selectDateRange(context),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Dates',
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                            ),
                            child: Text(
                              _startDate != null && _endDate != null
                                  ? "${DateFormat('MMM d, yyyy').format(_startDate!)} - ${DateFormat('MMM d, yyyy').format(_endDate!)}"
                                  : 'Select travel dates',
                            ),
                          ),
                        ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _budgetController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Budget (INR)',
                            prefixIcon: Icon(Icons.currency_rupee),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Required';
                            if (double.tryParse(value) == null) return 'Must be a number';
                            return null;
                          },
                        ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _interestsController,
                          decoration: const InputDecoration(
                            labelText: 'Interests (comma separated)',
                            hintText: 'e.g. History, Food, Hiking, Museums',
                            prefixIcon: Icon(Icons.favorite_outline),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
                        const SizedBox(height: 48),
                        ElevatedButton.icon(
                          onPressed: state is ItineraryGenerating
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate() && _startDate != null && _endDate != null) {
                                    final trip = Trip(
                                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                                      destination: _destinationController.text,
                                      startDate: _startDate!,
                                      endDate: _endDate!,
                                      budget: double.parse(_budgetController.text),
                                      interests: _interestsController.text.split(',').map((e) => e.trim()).toList(),
                                    );
                                    context.read<TripBloc>().add(GenerateItineraryEvent(trip));
                                  } else if (_startDate == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please select dates')),
                                    );
                                  }
                                },
                          icon: state is ItineraryGenerating
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.auto_awesome),
                          label: Text(state is ItineraryGenerating ? 'Generating AI Itinerary...' : 'Generate Itinerary'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            backgroundColor: AppTheme.primary,
                          ),
                        ).animate(target: state is ItineraryGenerating ? 1 : 0).shimmer(duration: 1.seconds, color: Colors.white30).scale(begin: const Offset(0.9, 0.9), delay: 500.ms),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
