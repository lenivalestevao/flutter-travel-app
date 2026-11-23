import 'package:flutter/material.dart';

import '../../core/scope.dart';
import '../../core/widgets.dart';
import '../../data/travel_store.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Scope.of<TravelStore>(context);
    final theme = Theme.of(context);
    final saved = store.favorites;

    return MaxWidth(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Saved')),
          if (saved.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        size: 56,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 12),
                      Text('Nothing saved yet', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        'Tap the heart on a destination to keep it here.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                        onPressed: () => store.selectTab(0),
                        child: const Text('Explore destinations'),
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
                itemCount: saved.length,
                itemBuilder: (context, i) =>
                    DestinationTile(destination: saved[i], heroPrefix: 'saved'),
              ),
            ),
        ],
      ),
    );
  }
}
