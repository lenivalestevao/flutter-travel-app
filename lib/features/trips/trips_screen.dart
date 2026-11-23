import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/scope.dart';
import '../../core/widgets.dart';
import '../../data/models.dart';
import '../../data/travel_store.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  Future<void> _confirmCancel(
    BuildContext context,
    TravelStore store,
    Trip trip,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel trip to ${trip.destination.name}?'),
        content: const Text('This removes the booking from your trips.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep trip'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel trip'),
          ),
        ],
      ),
    );
    if (ok == true) store.cancel(trip.id);
  }

  @override
  Widget build(BuildContext context) {
    final store = Scope.of<TravelStore>(context);
    final theme = Theme.of(context);
    final trips = store.trips;
    final today = dateOnly(store.now);

    return MaxWidth(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('My trips')),
          if (trips.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.luggage_outlined,
                        size: 56,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 12),
                      Text('No trips yet', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                        onPressed: () => store.selectTab(0),
                        child: const Text('Plan your first trip'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList.builder(
                itemCount: trips.length,
                itemBuilder: (context, i) {
                  final trip = trips[i];
                  final daysAway = nightsBetween(today, trip.start);
                  final nights = nightsBetween(trip.start, trip.end);
                  return Card(
                    elevation: 0,
                    color: theme.colorScheme.surfaceContainerLow,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 84,
                            height: 84,
                            child: DestinationArt(
                              destination: trip.destination,
                              emojiSize: 36,
                              radius: 18,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trip.destination.name,
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '${rangeLabel(trip.start, trip.end)} · $nights nights',
                                  style: theme.textTheme.bodySmall,
                                ),
                                Text(
                                  '${trip.guests} guests · ${trip.room.label}',
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      money(trip.total, cents: true),
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(width: 8),
                                    Chip(
                                      visualDensity: VisualDensity.compact,
                                      label: Text(
                                        daysAway <= 0
                                            ? 'Now'
                                            : 'In $daysAway days',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            tooltip: 'Trip options',
                            onSelected: (_) => _confirmCancel(context, store, trip),
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'cancel',
                                child: Text('Cancel trip'),
                              ),
                            ],
                          ),
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
