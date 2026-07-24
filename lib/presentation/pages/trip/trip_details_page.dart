import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/entities/weather.dart';
import '../../../data/datasources/places_remote_data_source.dart';
import '../../../data/datasources/weather_remote_data_source.dart';
import '../../../injection_container.dart' as di;
import '../../../core/theme/app_theme.dart';

class TripDetailsPage extends StatefulWidget {
  final Trip trip;

  const TripDetailsPage({super.key, required this.trip});

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  late Future<Map<String, dynamic>> _tripDataFuture;
  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    _tripDataFuture = _fetchTripData();
  }

  Future<Map<String, dynamic>> _fetchTripData() async {
    final placesSource = di.sl<PlacesRemoteDataSource>();
    final weatherSource = di.sl<WeatherRemoteDataSource>();

    LatLng? destinationCoords;
    Weather? weather;

    try {
      final predictions = await placesSource.getPlacePredictions(widget.trip.destination);
      if (predictions.isNotEmpty) {
        destinationCoords = LatLng(predictions.first.lat, predictions.first.lon);
      }
    } catch (_) {}

    try {
      weather = await weatherSource.getWeatherForecast(widget.trip.destination);
    } catch (_) {}

    return {
      'coords': destinationCoords,
      'weather': weather,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.trip.destination),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.account_balance_wallet, color: AppTheme.primaryGradientEnd),
              onPressed: () {
                context.pushNamed(
                  'budget_dashboard',
                  extra: widget.trip,
                );
              },
              tooltip: 'Budget Dashboard',
            ),
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
          FutureBuilder<Map<String, dynamic>>(
            future: _tripDataFuture,
            builder: (context, snapshot) {
              final coords = snapshot.data?['coords'] as LatLng?;
              final weather = snapshot.data?['weather'] as Weather?;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight)),
                  if (coords != null)
                    SliverToBoxAdapter(
                      child: Container(
                        height: 250,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white10),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              initialCenter: coords,
                              initialZoom: 12.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.ai_travel_planner',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: coords,
                                    width: 40,
                                    height: 40,
                                    child: const Icon(Icons.location_on, color: AppTheme.secondary, size: 40)
                                        .animate(onPlay: (c) => c.repeat(reverse: true))
                                        .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 1.seconds),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
                    ),
                  SliverToBoxAdapter(
                    child: _buildHeader(context, weather).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'Your AI Itinerary',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  if (widget.trip.itinerary.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Text('No itinerary available for this trip.'),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final day = widget.trip.itinerary[index];
                          return _buildDayCard(context, day)
                              .animate()
                              .fadeIn(delay: (300 + (index * 100)).ms)
                              .slideX(begin: 0.1);
                        },
                        childCount: widget.trip.itinerary.length,
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Weather? weather) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          if (weather != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(weather.iconUrl, width: 40, height: 40, errorBuilder: (_, __, ___) => const Icon(Icons.cloud, color: Colors.white)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${weather.temperature.toStringAsFixed(1)}°C', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      Text(weather.condition, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          Text(
            "${DateFormat('MMMM d, yyyy').format(widget.trip.startDate)} - ${DateFormat('MMMM d, yyyy').format(widget.trip.endDate)}",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Budget: ₹${widget.trip.budget.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primaryGradientEnd),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: widget.trip.interests
                .map((interest) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(interest, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, ItineraryDay day) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Day ${day.dayNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
            ),
            subtitle: Text(DateFormat('EEEE, MMM d').format(day.date), style: const TextStyle(color: AppTheme.textSecondary)),
            initiallyExpanded: day.dayNumber == 1,
            iconColor: AppTheme.primary,
            collapsedIconColor: AppTheme.textSecondary,
            children: day.activities
                .map((activity) => Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(activity.time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textPrimary)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                                const SizedBox(height: 8),
                                Text(activity.description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                                if (activity.location != null) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 14, color: AppTheme.secondary),
                                      const SizedBox(width: 6),
                                      Expanded(child: Text(activity.location!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
                                    ],
                                  ),
                                ],
                                if (activity.costEstimate != null) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.currency_rupee, size: 14, color: AppTheme.primaryGradientEnd),
                                      const SizedBox(width: 6),
                                      Text('${activity.costEstimate}', style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
