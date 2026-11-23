import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/travel_store.dart';
import '../features/detail/destination_screen.dart';
import 'scope.dart';

/// Centers content and caps its width so layouts also work on tablets and web.
class MaxWidth extends StatelessWidget {
  const MaxWidth({super.key, required this.child, this.width = 720});

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: child,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Gradient + emoji artwork. Replace the body with `Image.network` or
/// `Image.asset` once you have real photos.
class DestinationArt extends StatelessWidget {
  const DestinationArt({
    super.key,
    required this.destination,
    this.emojiSize = 64,
    this.radius = 0,
  });

  final Destination destination;
  final double emojiSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: destination.colors,
              ),
            ),
          ),
          const Positioned(
            right: -40,
            bottom: -40,
            child: _Circle(size: 170, alpha: 0.12),
          ),
          const Positioned(
            left: -30,
            top: -30,
            child: _Circle(size: 110, alpha: 0.10),
          ),
          Center(
            child: Text(destination.emoji, style: TextStyle(fontSize: emojiSize)),
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.size, required this.alpha});

  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }
}

class RatingBadge extends StatelessWidget {
  const RatingBadge(this.rating, {super.key, this.textColor});

  final double rating;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFB400)),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.w700, color: textColor),
        ),
      ],
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.destination, this.filled = false});

  final Destination destination;

  /// Use a tonal background (for buttons placed over artwork).
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final store = Scope.of<TravelStore>(context);
    final saved = store.isFavorite(destination.id);
    final icon = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Icon(
        saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        key: ValueKey(saved),
        color: saved ? Colors.redAccent : null,
      ),
    );
    final tooltip = saved ? 'Remove from saved' : 'Save';
    void toggle() => store.toggleFavorite(destination.id);
    return filled
        ? IconButton.filledTonal(tooltip: tooltip, onPressed: toggle, icon: icon)
        : IconButton(tooltip: tooltip, onPressed: toggle, icon: icon);
  }
}

/// Horizontal list card used in Explore and Saved.
class DestinationTile extends StatelessWidget {
  const DestinationTile({super.key, required this.destination, required this.heroPrefix});

  final Destination destination;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tag = '$heroPrefix-${destination.id}';
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: () => openDestination(context, destination, tag),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: Hero(
                  tag: tag,
                  child: DestinationArt(
                    destination: destination,
                    emojiSize: 40,
                    radius: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(destination.country, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        RatingBadge(destination.rating),
                        const SizedBox(width: 8),
                        Text(
                          '(${destination.reviewCount})',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: '\$${destination.pricePerNight}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                        ),
                        children: [
                          TextSpan(
                            text: ' / night',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FavoriteButton(destination: destination),
            ],
          ),
        ),
      ),
    );
  }
}
