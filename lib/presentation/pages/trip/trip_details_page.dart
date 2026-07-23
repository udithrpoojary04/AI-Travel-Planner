import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/trip.dart';

class TripDetailsPage extends StatelessWidget {
  final Trip trip;

  const TripDetailsPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trip.destination),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Icon(Icons.map, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    '\${DateFormat('MMMM d, yyyy').format(trip.startDate)} - \${DateFormat('MMMM d, yyyy').format(trip.endDate)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Budget: \$\${trip.budget.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: trip.interests
                        .map((interest) => Chip(
                              label: Text(interest),
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            
            // Itinerary
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Your AI Itinerary',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            
            if (trip.itinerary.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Text('No itinerary available for this trip.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: trip.itinerary.length,
                itemBuilder: (context, index) {
                  final day = trip.itinerary[index];
                  return _buildDayCard(context, day);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, ItineraryDay day) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Text(
          'Day \${day.dayNumber}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(DateFormat('EEEE, MMM d').format(day.date)),
        initiallyExpanded: day.dayNumber == 1,
        children: day.activities
            .map((activity) => ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(activity.time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  title: Text(activity.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(activity.description),
                      if (activity.location != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(child: Text(activity.location!, style: const TextStyle(color: Colors.grey))),
                          ],
                        ),
                      ],
                      if (activity.costEstimate != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.attach_money, size: 14, color: Colors.green),
                            const SizedBox(width: 4),
                            Text('\${activity.costEstimate}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ],
                  ),
                  isThreeLine: true,
                ))
            .toList(),
      ),
    );
  }
}
