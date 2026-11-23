import 'package:flutter/material.dart';

import 'core/scope.dart';
import 'core/theme.dart';
import 'data/travel_store.dart';
import 'features/shell.dart';

void main() => runApp(WanderApp(store: TravelStore()));

class WanderApp extends StatelessWidget {
  const WanderApp({super.key, required this.store});

  final TravelStore store;

  @override
  Widget build(BuildContext context) {
    return Scope<TravelStore>(
      store: store,
      child: MaterialApp(
        title: 'Wander',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        home: const AppShell(),
      ),
    );
  }
}
