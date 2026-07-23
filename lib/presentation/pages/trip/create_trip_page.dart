import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/trip.dart';
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
      appBar: AppBar(
        title: const Text('Plan New Trip'),
      ),
      body: BlocConsumer<TripBloc, TripState>(
        listener: (context, state) {
          if (state is ItineraryGenerated) {
            // Save the trip locally after generation
            context.read<TripBloc>().add(SaveTripEvent(state.generatedTrip));
            
            // Navigate to the trip details page (passing the trip via state or extra)
            // For now, we will just go back to home and the list will reload
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
                        ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      labelText: 'Destination (City, Country)',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDateRange(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Dates',
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _startDate != null && _endDate != null
                            ? "\${DateFormat('MMM d, yyyy').format(_startDate!)} - \${DateFormat('MMM d, yyyy').format(_endDate!)}"
                            : 'Select travel dates',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Budget (USD)',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      if (double.tryParse(value) == null) return 'Must be a number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _interestsController,
                    decoration: InputDecoration(
                      labelText: 'Interests (comma separated)',
                      hintText: 'e.g. History, Food, Hiking, Museums',
                      prefixIcon: const Icon(Icons.favorite_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 32),
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
