import 'package:all_event/core/common_export.dart';
import 'package:flutter/material.dart';

class FavoriteIconButton extends ConsumerWidget {
  final String eventId;
  const FavoriteIconButton({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProvider);
    final favoriteNotifier = ref.read(favoriteProvider.notifier);

    final isFav = favorites.contains(eventId);

    return IconButton(
      icon: Icon(
        isFav ? Icons.star_outlined : Icons.star_border,
        color: isFav ? primaryColor : Colors.grey,
      ),
      onPressed: () => favoriteNotifier.toggleFavorite(context, eventId),
    );
  }
}
