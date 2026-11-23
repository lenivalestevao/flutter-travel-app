import 'package:flutter/material.dart';

import '../../core/widgets.dart';
import '../../data/models.dart';
import '../booking/booking_screen.dart';

void openDestination(BuildContext context, Destination destination, String heroTag) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => DestinationScreen(destination: destination, heroTag: heroTag),
    ),
  );
}

class DestinationScreen extends StatelessWidget {
  const DestinationScreen({
    super.key,
    required this.destination,
    required this.heroTag,
  });

  final Destination destination;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final d = destination;

    return Scaffold(
      body: MaxWidth(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 320,
              leading: Padding(
                padding: const EdgeInsets.all(6),
                child: IconButton.filledTonal(
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
              ),
              actions: [
                FavoriteButton(destination: d, filled: true),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: heroTag,
                  child: DestinationArt(destination: d, emojiSize: 120),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              sliver: SliverList.list(
                children: [
                  Text(
                    d.name,
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.place_rounded, size: 18, color: scheme.primary),
                      const SizedBox(width: 4),
                      Text(d.country, style: theme.textTheme.bodyMedium),
                      const SizedBox(width: 16),
                      RatingBadge(d.rating),
                      const SizedBox(width: 4),
                      Text('(${d.reviewCount})', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    d.tagline,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: scheme.primary),
                  ),
                  const SizedBox(height: 12),
                  Text(d.about, style: theme.textTheme.bodyLarge),
                  const SectionHeader('Highlights'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final h in d.highlights)
                        Chip(
                          label: Text(h),
                          avatar: const Icon(Icons.check_circle_rounded, size: 18),
                        ),
                    ],
                  ),
                  const SectionHeader('Best time to visit'),
                  Row(
                    children: [
                      Icon(Icons.wb_sunny_rounded, color: scheme.primary),
                      const SizedBox(width: 8),
                      Text(d.bestTime, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                  const SectionHeader('Reviews'),
                  for (final r in d.reviews) _ReviewCard(review: r),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${d.pricePerNight}',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  Text('per night', style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => BookingScreen(destination: d),
                    ),
                  ),
                  child: const Text('Book now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  child: Text(review.author[0]),
                ),
                const SizedBox(width: 10),
                Text(review.author, style: theme.textTheme.titleSmall),
                const Spacer(),
                for (var i = 0; i < 5; i++)
                  Icon(
                    i < review.stars ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 16,
                    color: const Color(0xFFFFB400),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.text, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
