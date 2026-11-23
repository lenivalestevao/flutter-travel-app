import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/scope.dart';
import '../../core/widgets.dart';
import '../../data/models.dart';
import '../../data/travel_store.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.destination});

  final Destination destination;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTimeRange? _range;
  int _guests = 2;
  RoomType _room = RoomType.standard;

  Future<void> _pickDates() async {
    final today = dateOnly(Scope.read<TravelStore>(context).now);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      initialDateRange: _range,
      helpText: 'Select your dates',
    );
    if (picked != null && mounted) setState(() => _range = picked);
  }

  void _confirm() {
    final store = Scope.read<TravelStore>(context);
    final range = _range!;
    final trip = store.book(
      widget.destination,
      start: range.start,
      end: range.end,
      guests: _guests,
      room: _room,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => _BookedScreen(trip: trip)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Scope.of<TravelStore>(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final d = widget.destination;
    final range = _range;
    final nights = range == null ? 0 : nightsBetween(range.start, range.end);
    final quote = store.quote(d, nights: nights, room: _room, guests: _guests);

    return Scaffold(
      appBar: AppBar(title: const Text('Book your stay')),
      body: MaxWidth(
        width: 560,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            Row(
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: DestinationArt(destination: d, emojiSize: 30, radius: 16),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.name,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(d.country, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SectionHeader('Dates'),
            Card(
              elevation: 0,
              color: scheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                onTap: _pickDates,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.calendar_month_rounded),
                title: Text(
                  range == null
                      ? 'Select dates'
                      : rangeLabel(range.start, range.end),
                ),
                subtitle: range == null
                    ? null
                    : Text('$nights ${nights == 1 ? 'night' : 'nights'}'),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ),
            const SectionHeader('Guests'),
            Row(
              children: [
                const Icon(Icons.people_alt_rounded),
                const SizedBox(width: 12),
                Text('$_guests ${_guests == 1 ? 'guest' : 'guests'}',
                    style: theme.textTheme.titleMedium),
                const Spacer(),
                IconButton.filledTonal(
                  tooltip: 'Fewer guests',
                  onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                  icon: const Icon(Icons.remove_rounded),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: 'More guests',
                  onPressed: _guests < TravelStore.maxGuests
                      ? () => setState(() => _guests++)
                      : null,
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            const SectionHeader('Room'),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<RoomType>(
                showSelectedIcon: false,
                segments: [
                  for (final r in RoomType.values)
                    ButtonSegment(value: r, label: Text(r.label)),
                ],
                selected: {_room},
                onSelectionChanged: (s) => setState(() => _room = s.first),
              ),
            ),
            const SectionHeader('Price details'),
            Card(
              elevation: 0,
              color: scheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _PriceRow(
                      '${money(d.pricePerNight * _room.multiplier)} × $nights nights',
                      money(quote.subtotal, cents: true),
                    ),
                    _PriceRow('Taxes (12%)', money(quote.taxes, cents: true)),
                    _PriceRow('Service fee', money(quote.fee, cents: true)),
                    const Divider(height: 24),
                    _PriceRow('Total', money(quote.total, cents: true), bold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Demo only. No payment is taken and nothing is sent anywhere.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton(
            onPressed: range == null ? null : _confirm,
            child: Text(
              range == null
                  ? 'Choose your dates'
                  : 'Confirm · ${money(quote.total, cents: true)}',
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w800)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _BookedScreen extends StatelessWidget {
  const _BookedScreen({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: MaxWidth(
          width: 480,
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.4, end: 1),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.onPrimaryContainer,
                    child: const Icon(Icons.check_rounded, size: 56),
                  ),
                ),
                const SizedBox(height: 24),
                Text('You are going to ${trip.destination.name}!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  '${rangeLabel(trip.start, trip.end)} · ${trip.guests} guests · ${trip.room.label}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Scope.read<TravelStore>(context).selectTab(2);
                      Navigator.of(context).popUntil((r) => r.isFirst);
                    },
                    child: const Text('View my trips'),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  child: const Text('Keep exploring'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
