import 'package:flutter/material.dart';

import 'models.dart';

/// Sample catalog. Names, prices and reviews are fictional.
const List<Destination> destinations = [
  Destination(
    id: 'd1',
    name: 'Santorini',
    country: 'Greece',
    emoji: '🌅',
    tagline: 'White villages above a blue caldera',
    about:
        'Cliffside towns, volcanic beaches and some of the best sunsets in the Mediterranean. '
        'Stay in Oia or Imerovigli for the views, and take a boat trip to the hot springs.',
    vibe: Vibe.beach,
    pricePerNight: 220,
    rating: 4.8,
    reviewCount: 1284,
    colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
    highlights: ['Sunset in Oia', 'Caldera boat tour', 'Wine tasting', 'Red Beach'],
    bestTime: 'May to October',
    reviews: [
      Review('Marta', 5, 'Every evening felt like a postcard. Book the sunset table early.'),
      Review('James', 4, 'Beautiful, but busy in July. Worth it for the views.'),
      Review('Aiko', 5, 'The boat day was the highlight of our trip.'),
    ],
  ),
  Destination(
    id: 'd2',
    name: 'Kyoto',
    country: 'Japan',
    emoji: '⛩️',
    tagline: 'Temples, tea houses and quiet gardens',
    about:
        'Japan\'s old capital keeps its traditions alive: wooden machiya streets, hundreds of shrines '
        'and seasonal food. Rent a bike, start early and walk through Fushimi Inari before the crowds.',
    vibe: Vibe.culture,
    pricePerNight: 180,
    rating: 4.9,
    reviewCount: 2310,
    colors: [Color(0xFFEC77AB), Color(0xFF7873F5)],
    highlights: ['Fushimi Inari', 'Tea ceremony', 'Arashiyama', 'Gion district'],
    bestTime: 'March to May, Oct to Nov',
    reviews: [
      Review('Lucas', 5, 'Calm, clean and full of surprises on every corner.'),
      Review('Sofia', 5, 'Go in autumn. The colors are unreal.'),
      Review('Ben', 4, 'Plan your days by neighborhood to save time.'),
    ],
  ),
  Destination(
    id: 'd3',
    name: 'Swiss Alps',
    country: 'Switzerland',
    emoji: '🏔️',
    tagline: 'Snowy peaks and fairytale villages',
    about:
        'Trains that climb mountains, lakes that look painted and trails for every level. '
        'Base yourself in Interlaken or Zermatt and use the regional pass.',
    vibe: Vibe.mountain,
    pricePerNight: 310,
    rating: 4.7,
    reviewCount: 986,
    colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
    highlights: ['Jungfraujoch', 'Scenic trains', 'Lake Brienz', 'Ski and hike'],
    bestTime: 'Dec to Mar, Jun to Sep',
    reviews: [
      Review('Nora', 5, 'Postcard views from the train window all day.'),
      Review('Pedro', 4, 'Pricey, but everything runs on time and feels safe.'),
    ],
  ),
  Destination(
    id: 'd4',
    name: 'Lisbon',
    country: 'Portugal',
    emoji: '🚋',
    tagline: 'Hills, trams and custard tarts',
    about:
        'A sunny, walkable capital with tiled facades, live fado and day trips to Sintra and the coast. '
        'Great value for food and wine.',
    vibe: Vibe.city,
    pricePerNight: 130,
    rating: 4.6,
    reviewCount: 1742,
    colors: [Color(0xFFF7971E), Color(0xFFFFD200)],
    highlights: ['Tram 28', 'Belém tarts', 'Sintra day trip', 'Alfama fado'],
    bestTime: 'April to October',
    reviews: [
      Review('Diego', 5, 'We ate so well and spent so little.'),
      Review('Emma', 4, 'Wear comfy shoes. The hills are real.'),
    ],
  ),
  Destination(
    id: 'd5',
    name: 'Bali',
    country: 'Indonesia',
    emoji: '🌴',
    tagline: 'Rice terraces, surf and slow mornings',
    about:
        'Split your time between Ubud for culture and wellness, and the south coast for beaches and surf. '
        'Rent a scooter only if you are experienced; drivers are easy to hire.',
    vibe: Vibe.nature,
    pricePerNight: 95,
    rating: 4.7,
    reviewCount: 3120,
    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    highlights: ['Tegalalang terraces', 'Surf lessons', 'Monkey forest', 'Temple sunrise'],
    bestTime: 'April to October',
    reviews: [
      Review('Priya', 5, 'Peaceful, friendly and very affordable.'),
      Review('Tom', 4, 'Traffic in the south is heavy. Ubud was the best part.'),
    ],
  ),
  Destination(
    id: 'd6',
    name: 'New York',
    country: 'USA',
    emoji: '🗽',
    tagline: 'The city that never sits still',
    about:
        'Museums, Broadway, food from every corner of the world and parks that surprise you. '
        'Use the subway, walk a lot and book popular shows ahead.',
    vibe: Vibe.city,
    pricePerNight: 280,
    rating: 4.5,
    reviewCount: 4410,
    colors: [Color(0xFF232526), Color(0xFF616A72)],
    highlights: ['Central Park', 'Broadway', 'The High Line', 'Brooklyn Bridge'],
    bestTime: 'April to June, Sep to Nov',
    reviews: [
      Review('Carla', 5, 'Endless things to do. We want to go back.'),
      Review('Yuki', 4, 'Exhausting in the best way.'),
    ],
  ),
  Destination(
    id: 'd7',
    name: 'Machu Picchu',
    country: 'Peru',
    emoji: '🦙',
    tagline: 'A lost city in the clouds',
    about:
        'Reach the Inca citadel by train or on the Inca Trail. Spend a day in Cusco first to adapt to the altitude '
        'and book entry tickets well in advance.',
    vibe: Vibe.culture,
    pricePerNight: 120,
    rating: 4.8,
    reviewCount: 1530,
    colors: [Color(0xFF8E9EAB), Color(0xFF3A6073)],
    highlights: ['Inca Trail', 'Sun Gate sunrise', 'Sacred Valley', 'Cusco old town'],
    bestTime: 'May to September',
    reviews: [
      Review('Ivan', 5, 'Worth every step. Go early for the best light.'),
      Review('Lena', 5, 'Our guide made the history come alive.'),
    ],
  ),
  Destination(
    id: 'd8',
    name: 'Banff',
    country: 'Canada',
    emoji: '🦌',
    tagline: 'Turquoise lakes in the Rockies',
    about:
        'Hike to alpine lakes in summer, ski in winter and soak in hot springs all year. '
        'Rent a car for Lake Louise, Moraine Lake and the Icefields Parkway.',
    vibe: Vibe.nature,
    pricePerNight: 200,
    rating: 4.8,
    reviewCount: 1105,
    colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
    highlights: ['Lake Louise', 'Moraine Lake', 'Banff gondola', 'Hot springs'],
    bestTime: 'June to September, Dec to Mar',
    reviews: [
      Review('Chloe', 5, 'The most beautiful water I have ever seen.'),
      Review('Marcus', 4, 'Parking fills up fast. Arrive at sunrise.'),
    ],
  ),
];
