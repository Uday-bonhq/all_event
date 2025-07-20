import 'package:all_event/core/common_export.dart';
import 'package:flutter/material.dart';

class SuggestedEventsWidget extends ConsumerWidget {
  const SuggestedEventsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final randomEvents = ref.watch(eventStateProvider).randomEventList;

    if (randomEvents.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Text(
            "Events You May Like",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            itemCount: randomEvents.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final event = randomEvents[index];
              return _eventCard(context, event, ref);
            },
          ),
        ),
      ],
    );
  }

  Widget _eventCard(BuildContext context, EventData event, WidgetRef ref) {
    final heroTag = 'event-hero-${event.eventId ?? event.thumbUrl ?? UniqueKey()}';

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(
              event: event,
            ),
          ),
        );
      },
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Hero(
                    tag: heroTag,
                    child: customNetworkImage(
                      imageUrl: event.thumbUrl,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      borderRadius: 16,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 20,
                  child: Builder(
                    builder: (context) {
                      final favorites = ref.watch(favoriteProvider);
                      final favoriteNotifier = ref.read(favoriteProvider.notifier);
                      final isFav = favorites.contains(event.eventId ?? "-");

                      return FloatingActionButton.small(
                        heroTag: null, // ✅ prevent Hero conflict
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        onPressed: () {
                          favoriteNotifier.toggleFavorite(context, event.eventId ?? "-");
                        },
                        child: Icon(
                          isFav ? Icons.star_outlined : Icons.star_border,
                          color: isFav ? primaryColor : Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                event.eventname ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

