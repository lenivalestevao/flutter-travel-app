import 'package:flutter/foundation.dart';

import '../core/format.dart';
import 'destinations.dart';
import 'models.dart';

/// All app state in one plain [ChangeNotifier]. Swap it for Riverpod, Bloc or
/// an API client later; the screens only use the getters and methods below.
class TravelStore extends ChangeNotifier {
  TravelStore({DateTime Function()? clock}) : _clock = clock ?? DateTime.now {
    final today = dateOnly(now);
    _trips.add(Trip(
      id: 'tr1',
      destination: destinations.firstWhere((d) => d.id == 'd4'),
      start: today.add(const Duration(days: 30)),
      end: today.add(const Duration(days: 35)),
      guests: 2,
      room: RoomType.deluxe,
      total: quote(
        destinations.firstWhere((d) => d.id == 'd4'),
        nights: 5,
        room: RoomType.deluxe,
        guests: 2,
      ).total,
    ));
  }

  static const double taxRate = 0.12;
  static const double serviceFee = 15;
  static const int maxGuests = 8;

  final DateTime Function() _clock;
  final Set<String> _favorites = {'d2'};
  final List<Trip> _trips = [];
  int _tab = 0;

  DateTime get now => _clock();
  int get tab => _tab;
  List<Destination> get all => destinations;
  List<Trip> get trips => List.unmodifiable(
        _trips.toList()..sort((a, b) => a.start.compareTo(b.start)),
      );
  List<Destination> get favorites =>
      destinations.where((d) => _favorites.contains(d.id)).toList();

  void selectTab(int index) {
    _tab = index;
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.contains(id);

  void toggleFavorite(String id) {
    if (!_favorites.add(id)) _favorites.remove(id);
    notifyListeners();
  }

  /// Search by name, country or vibe, optionally limited to one [vibe].
  List<Destination> search(String query, {Vibe? vibe}) {
    final q = query.trim().toLowerCase();
    return destinations.where((d) {
      if (vibe != null && d.vibe != vibe) return false;
      if (q.isEmpty) return true;
      return d.name.toLowerCase().contains(q) ||
          d.country.toLowerCase().contains(q) ||
          d.vibe.label.toLowerCase().contains(q);
    }).toList();
  }

  /// Price for a stay: nightly rate x room, +15% per guest beyond two,
  /// 12% taxes and a flat service fee.
  Quote quote(
    Destination destination, {
    required int nights,
    required RoomType room,
    required int guests,
  }) {
    final extraGuests = guests > 2 ? guests - 2 : 0;
    final nightly = destination.pricePerNight * room.multiplier * (1 + 0.15 * extraGuests);
    final subtotal = nightly * nights;
    final taxes = subtotal * taxRate;
    return (
      nights: nights,
      subtotal: subtotal,
      taxes: taxes,
      fee: nights > 0 ? serviceFee : 0,
      total: subtotal + taxes + (nights > 0 ? serviceFee : 0),
    );
  }

  Trip book(
    Destination destination, {
    required DateTime start,
    required DateTime end,
    required int guests,
    required RoomType room,
  }) {
    final nights = nightsBetween(start, end);
    assert(nights > 0, 'A trip needs at least one night');
    final trip = Trip(
      id: 'tr${_trips.length + 1}',
      destination: destination,
      start: dateOnly(start),
      end: dateOnly(end),
      guests: guests,
      room: room,
      total: quote(destination, nights: nights, room: room, guests: guests).total,
    );
    _trips.add(trip);
    notifyListeners();
    return trip;
  }

  void cancel(String tripId) {
    _trips.removeWhere((t) => t.id == tripId);
    notifyListeners();
  }
}
