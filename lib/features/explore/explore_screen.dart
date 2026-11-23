import 'package:flutter/material.dart';

import '../../core/scope.dart';
import '../../core/widgets.dart';
import '../../data/models.dart';
import '../../data/travel_store.dart';
import '../detail/destination_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _pager = PageController(viewportFraction: 0.86);
  Vibe? _vibe; // null = all

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Scope.of<TravelStore>(context);
    final list = store.search('', vibe: _vibe);
    final featured = ([...list]..sort((a, b) => b.rating.compareTo(a.rating)))
        .take(4)
        .toList();

    return MaxWidth(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Where to next?')),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: SearchAnchor.bar(
                barHintText: 'Search destinations',
                suggestionsBuilder: (context, controller) {
                  final results = store.search(controller.text);
                  return [
                    for (final d in results)
                      ListTile(
                        leading: Text(d.emoji, style: const TextStyle(fontSize: 26)),
                        title: Text(d.name),
                        subtitle: Text(d.country),
                        onTap: () {
                          controller.closeView(null);
                          openDestination(context, d, 'search-${d.id}');
                        },
                      ),
                  ];
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('All'),
                      selected: _vibe == null,
                      onSelected: (_) => setState(() => _vibe = null),
                    ),
                  ),
                  for (final vibe in Vibe.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        avatar: Icon(vibe.icon, size: 18),
                        label: Text(vibe.label),
                        selected: _vibe == vibe,
                        onSelected: (_) => setState(() => _vibe = vibe),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (featured.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  height: 250,
                  child: PageView.builder(
                    controller: _pager,
                    padEnds: false,
                    itemCount: featured.length,
                    itemBuilder: (context, i) => Padding(
                      padding: EdgeInsets.only(left: i == 0 ? 20 : 6, right: 6),
                      child: _FeaturedCard(destination: featured[i]),
                    ),
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.list(
              children: [
                SectionHeader(_vibe == null ? 'Popular destinations' : '${_vibe!.label} escapes'),
                if (list.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('No destinations found')),
                  ),
                for (final d in list)
                  DestinationTile(destination: d, heroPrefix: 'list'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tag = 'featured-${destination.id}';
    return GestureDetector(
      onTap: () => openDestination(context, destination, tag),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: tag,
            child: DestinationArt(
              destination: destination,
              emojiSize: 84,
              radius: 28,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.55)],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        destination.country,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: RatingBadge(destination.rating, textColor: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
