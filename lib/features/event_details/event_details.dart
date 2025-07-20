import 'package:all_event/core/common_export.dart';
import 'package:all_event/services/notification/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final EventData event;
  const EventDetailScreen({super.key, required this.event});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  late EventData event;

  @override
  void initState() {
    event = widget.event;
    Future.microtask(() {
      ref.read(eventStateProvider.notifier).randomEvents(widget.event.eventId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String heroTag = 'event-${event.eventId ?? event.thumbUrl ?? UniqueKey().toString()}';

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EventBanner(heroTag: heroTag, event: event),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedColumn(
                milliseconds: 1000,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.eventname ?? "", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  _OrganizerInfo(event: event),
                  const SizedBox(height: 12),
                  _HighlightsSection(event: event),
                  const SizedBox(height: 5),
                  const _PeopleInterestedStack(),
                  const SizedBox(height: 12),
                  _ActionButtons(event: event, ref: ref, context: context),
                  const SizedBox(height: 12),
                  _BookTicketsButton(event: event, context: context),
                  const SizedBox(height: 16),
                  _AboutSection(event: event),
                  const SizedBox(height: 16),
                  _DateTimeSection(event: event),
                  const SizedBox(height: 16),
                  _LocationSection(event: event, context: context),
                  const SizedBox(height: 16),
                  _OrganizerContactInfo(event: event),
                  const SizedBox(height: 8),
                  const SuggestedEventsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventBanner extends StatelessWidget {
  final String heroTag;
  final EventData event;

  const _EventBanner({required this.heroTag, required this.event});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Hero(
            tag: heroTag,
            child: customNetworkImage(
              imageUrl: event.thumbUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              borderRadius: 0,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 30,
          child: PopupMenuButton<String>(
            offset: const Offset(0, 80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            color: Colors.white,
            elevation: 8,
            onSelected: (String value) {
              if (value == 'Help') {
                print('Help selected');
              } else if (value == 'Report') {
                print('Report selected');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'Help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Help'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Report',
                child: Row(
                  children: [
                    Icon(Icons.report_problem_outlined, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Report'),
                  ],
                ),
              ),
            ],
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              onPressed: null,
              child: const Icon(Icons.more_vert, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrganizerInfo extends StatelessWidget {
  final EventData event;

  const _OrganizerInfo({required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          maxRadius: 15,
          child: Text("V", style: TextStyle(fontSize: 10)),
        ),
        const SizedBox(width: 10),
        Text(
          'Organized by ${event.ownerId ?? "Organizer"}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

class _HighlightsSection extends StatelessWidget {
  final EventData event;

  const _HighlightsSection({required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Highlights", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        _buildHighlight(Icons.show_chart, "Featured in ${event.location ?? ""}"),
        _buildHighlight(CupertinoIcons.calendar_today, event.startTimeDisplay ?? ""),
        _buildHighlight(Icons.place_outlined, event.location ?? "No Venue"),
        _buildHighlight(CupertinoIcons.ticket, _getPrice(event)),
        _buildHighlight(Icons.people_outline, "89 people are interested"),
      ],
    );
  }

  Widget _buildHighlight(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryColor),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  String _getPrice(EventData event) {
    if (event.tickets?.minTicketPrice != null) {
      return "INR ${event.tickets!.minTicketPrice} - ${event.tickets!.maxTicketPrice}";
    } else {
      return "Free or Not Listed";
    }
  }
}

class _PeopleInterestedStack extends StatelessWidget {
  const _PeopleInterestedStack();

  @override
  Widget build(BuildContext context) {
    return buildPeopleStack(context,["Vishal", "Kiran", "Raj", "Meera"]);
  }
}

class _ActionButtons extends StatelessWidget {
  final EventData event;
  final WidgetRef ref;
  final BuildContext context;

  const _ActionButtons({required this.event, required this.ref, required this.context});

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteProvider);
    final favoriteNotifier = ref.read(favoriteProvider.notifier);
    final isFav = favorites.contains(event.eventId ?? "-");

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              favoriteNotifier.toggleFavorite(context, event.eventId ?? "-");
            },
            icon: Icon(
              isFav ? Icons.star_outlined : Icons.star_border,
              color: isFav ? primaryColor : Colors.grey,
            ),
            label: const Text(
              "Interested",
              style: TextStyle(color: Colors.black),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: primaryColor.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              shareContent(event.shareUrl);
            },
            icon: const Icon(Icons.file_upload_outlined, color: Colors.black),
            label: const Text(
              "Share",
              style: TextStyle(color: Colors.black),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: primaryColor.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BookTicketsButton extends StatelessWidget {
  final EventData event;
  final BuildContext context;

  const _BookTicketsButton({required this.event, required this.context});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        onPressed: () {
          if (event.tickets?.hasTickets == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookTicketScreen(
                  bookingUrl: event.tickets?.ticketUrl ?? event.eventUrl ?? "",
                ),
              ),
            ).then((_) {
              if (event.tickets?.hasTickets == true) {
                showLocalNotification(
                  'Tickets Booked!',
                  'Your Tickets has been confirmed.',
                );
              }
            });
          } else {
            toastification.show(
              context: context,
              type: ToastificationType.info,
              style: ToastificationStyle.minimal,
              title: const Text("Error"),
              description: const Text("Sold Out!!"),
              alignment: Alignment.topCenter,
              autoCloseDuration: const Duration(seconds: 4),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: highModeShadow,
            );
          }
        },
        color: event.tickets?.hasTickets == true ? primaryColor : Colors.deepOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          event.tickets?.hasTickets == true ? 'Book Tickets' : "Sold Out!!",
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  final EventData event;

  const _AboutSection({required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("About", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if ((event.tags ?? []).isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Wrap(
              spacing: 6,
              runSpacing: 0,
              children: [
                ...event.tags!.take(9).map((tag) => Chip(
                  backgroundColor: primaryColor.withOpacity(0.05),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  label: Text(
                    tag.firstCapital(),
                    style: const TextStyle(fontSize: 10),
                  ),
                )),
                if (event.tags!.length > 5)
                  Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    label: Text(
                      '+${event.tags!.length - 5} more',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: Colors.grey.shade300,
                  ),
              ],
            ),
          ),
        Text(event.eventname ?? "", style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class _DateTimeSection extends StatelessWidget {
  final EventData event;

  const _DateTimeSection({required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Date & Time", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildHighlight(Icons.schedule, event.startTimeDisplay ?? ""),

        const Text(
          "+ Add to Calender",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHighlight(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryColor),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

class _LocationSection extends StatelessWidget {
  final EventData event;
  final BuildContext context;

  const _LocationSection({required this.event, required this.context});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Location",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on_outlined, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                event.venue?.fullAddress ?? "No address available",
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            var latitude = event.venue?.latitude ?? 0.0;
            var longitude = event.venue?.longitude ?? 0.0;

            final geoUrl = Uri.parse("geo:$latitude,$longitude");
            final mapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('$latitude,$longitude')}");

            if (await canLaunchUrl(geoUrl)) {
              await launchUrl(geoUrl, mode: LaunchMode.externalApplication);
            } else if (await canLaunchUrl(mapsUrl)) {
              await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
            } else {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                style: ToastificationStyle.minimal,
                title: const Text("Error"),
                description: const Text("No map application or browser found!"),
                alignment: Alignment.topCenter,
                autoCloseDuration: const Duration(seconds: 4),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: highModeShadow,
              );
            }
          },
          child: const Row(
            children: [
              Text(
                "View on Map ",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.keyboard_arrow_down, color: primaryColor)
            ],
          ),
        ),
      ],
    );
  }
}

class _OrganizerContactInfo extends StatelessWidget {
  final EventData event;

  const _OrganizerContactInfo({required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Organized By", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const CircleAvatar(
                minRadius: 30,
                child: Icon(Icons.account_circle, size: 30),
              ),
              const SizedBox(height: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    event.ownerId ?? "Organizer",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "${300} Followers • ⭐ ${"4.7"}",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "${5} Upcoming Events",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        child: MaterialButton(
                          onPressed: () {},
                          color: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            "Follow",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 120,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            side: const BorderSide(color: primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text(
                            "Message",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}