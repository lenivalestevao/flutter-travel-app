import 'package:flutter/material.dart';

import '../core/scope.dart';
import '../data/travel_store.dart';
import 'explore/explore_screen.dart';
import 'saved/saved_screen.dart';
import 'trips/trips_screen.dart';

typedef _Destination = ({String label, IconData icon, IconData selected});

/// Adaptive navigation: bottom bar on phones, side rail on tablets/desktop.
/// The selected tab lives in the store so other screens can switch tabs
/// (for example "View my trips" after booking).
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const List<_Destination> _items = [
    (label: 'Explore', icon: Icons.explore_outlined, selected: Icons.explore_rounded),
    (label: 'Saved', icon: Icons.favorite_border_rounded, selected: Icons.favorite_rounded),
    (label: 'Trips', icon: Icons.luggage_outlined, selected: Icons.luggage_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final store = Scope.of<TravelStore>(context);
    final body = IndexedStack(
      index: store.tab,
      children: const [ExploreScreen(), SavedScreen(), TripsScreen()],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 840) {
          return Scaffold(
            body: body,
            bottomNavigationBar: NavigationBar(
              selectedIndex: store.tab,
              onDestinationSelected: store.selectTab,
              destinations: [
                for (final item in _items)
                  NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selected),
                    label: item.label,
                  ),
              ],
            ),
          );
        }
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: store.tab,
                onDestinationSelected: store.selectTab,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final item in _items)
                    NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selected),
                      label: Text(item.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }
}
