const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// `1234.5` -> `$1,235`. Pass [cents] for `$1,234.50`.
String money(num value, {bool cents = false}) {
  final parts = value.toStringAsFixed(cents ? 2 : 0).split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return cents ? '\$$whole.${parts[1]}' : '\$$whole';
}

String weekdayShort(DateTime d) => _weekdays[d.weekday - 1];

String dateShort(DateTime d) => '${_months[d.month - 1]} ${d.day}';

/// `Dec 3 – Dec 8`
String rangeLabel(DateTime start, DateTime end) =>
    '${dateShort(start)} – ${dateShort(end)}';

/// Nights between two dates, immune to daylight-saving shifts.
int nightsBetween(DateTime start, DateTime end) =>
    DateTime.utc(end.year, end.month, end.day)
        .difference(DateTime.utc(start.year, start.month, start.day))
        .inDays;

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
