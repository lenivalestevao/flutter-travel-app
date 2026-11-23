import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wander_travel/data/destinations.dart';
import 'package:wander_travel/data/models.dart';
import 'package:wander_travel/data/travel_store.dart';
import 'package:wander_travel/main.dart';

void main() {
  final fixedNow = DateTime(2026, 11, 20, 12);
  TravelStore makeStore() => TravelStore(clock: () => fixedNow);

  group('TravelStore', () {
    test('quote adds taxes and the service fee', () {
      final store = makeStore();
      final d = destinations.first;
      final q = store.quote(d, nights: 2, room: RoomType.standard, guests: 2);
      expect(q.subtotal, d.pricePerNight * 2);
      expect(q.taxes, closeTo(q.subtotal * TravelStore.taxRate, 0.001));
      expect(q.total, closeTo(q.subtotal + q.taxes + TravelStore.serviceFee, 0.001));
    });

    test('extra guests and better rooms cost more', () {
      final store = makeStore();
      final d = destinations.first;
      final base = store.quote(d, nights: 1, room: RoomType.standard, guests: 2);
      expect(
        store.quote(d, nights: 1, room: RoomType.suite, guests: 2).total,
        greaterThan(base.total),
      );
      expect(
        store.quote(d, nights: 1, room: RoomType.standard, guests: 4).total,
        greaterThan(base.total),
      );
    });

    test('book adds a trip and cancel removes it', () {
      final store = makeStore();
      final before = store.trips.length;
      final trip = store.book(
        destinations.first,
        start: DateTime(2026, 12, 1),
        end: DateTime(2026, 12, 4),
        guests: 2,
        room: RoomType.standard,
      );
      expect(store.trips.length, before + 1);
      store.cancel(trip.id);
      expect(store.trips.length, before);
    });

    test('toggleFavorite saves and unsaves', () {
      final store = makeStore();
      expect(store.isFavorite('d1'), isFalse);
      store.toggleFavorite('d1');
      expect(store.isFavorite('d1'), isTrue);
      store.toggleFavorite('d1');
      expect(store.isFavorite('d1'), isFalse);
    });

    test('search matches name, country and vibe', () {
      final store = makeStore();
      expect(store.search('kyo').single.name, 'Kyoto');
      expect(store.search('portugal').single.name, 'Lisbon');
      expect(store.search('', vibe: Vibe.beach), isNotEmpty);
    });
  });

  group('App', () {
    testWidgets('shows the Explore tab', (tester) async {
      await tester.pumpWidget(WanderApp(store: makeStore()));
      await tester.pumpAndSettle();

      expect(find.text('Where to next?'), findsOneWidget);
      expect(find.text('Popular destinations'), findsOneWidget);
    });

    testWidgets('opens a saved destination and shows the Book button', (tester) async {
      await tester.pumpWidget(WanderApp(store: makeStore()));
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Saved'),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Kyoto'), findsOneWidget);

      await tester.tap(find.text('Kyoto'));
      await tester.pumpAndSettle();
      expect(find.text('Book now'), findsOneWidget);
    });
  });
}
