import 'package:flutter/material.dart';

enum Vibe {
  beach('Beach', Icons.beach_access_rounded),
  city('City', Icons.location_city_rounded),
  mountain('Mountain', Icons.landscape_rounded),
  culture('Culture', Icons.museum_rounded),
  nature('Nature', Icons.forest_rounded);

  const Vibe(this.label, this.icon);

  final String label;
  final IconData icon;
}

enum RoomType {
  standard('Standard', 1.0),
  deluxe('Deluxe', 1.4),
  suite('Suite', 2.0);

  const RoomType(this.label, this.multiplier);

  final String label;

  /// Price multiplier over the base nightly rate.
  final double multiplier;
}

class Review {
  const Review(this.author, this.stars, this.text);

  final String author;
  final int stars;
  final String text;
}

class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.emoji,
    required this.tagline,
    required this.about,
    required this.vibe,
    required this.pricePerNight,
    required this.rating,
    required this.reviewCount,
    required this.colors,
    required this.highlights,
    required this.bestTime,
    required this.reviews,
  });

  final String id;
  final String name;
  final String country;

  /// Emoji used as the artwork, so the template needs no image assets.
  /// Swap [DestinationArt] for `Image.network` / `Image.asset` when you have photos.
  final String emoji;
  final String tagline;
  final String about;
  final Vibe vibe;
  final int pricePerNight;
  final double rating;
  final int reviewCount;
  final List<Color> colors;
  final List<String> highlights;
  final String bestTime;
  final List<Review> reviews;
}

class Trip {
  const Trip({
    required this.id,
    required this.destination,
    required this.start,
    required this.end,
    required this.guests,
    required this.room,
    required this.total,
  });

  final String id;
  final Destination destination;
  final DateTime start;
  final DateTime end;
  final int guests;
  final RoomType room;
  final double total;
}

/// Price breakdown for a stay.
typedef Quote = ({
  int nights,
  double subtotal,
  double taxes,
  double fee,
  double total,
});
