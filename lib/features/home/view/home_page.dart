import 'package:all_event/core/common_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(eventStateProvider);

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: _buildAppBar(context, ref, categoryState),
        body: Column(
          children: [
            const SizedBox(height: 10),
            _buildFilterButtons(context, ref, categoryState),
            const SizedBox(height: 16),
            Expanded(child: _buildEventList(context, ref, categoryState))
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, WidgetRef ref, categoryState) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text("Events in ${ ref.watch(eventStateProvider).userLocation}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
      centerTitle: false,
      flexibleSpace: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.8),
              image: const DecorationImage(
                image: AssetImage(AssetIcon.homeBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              controller: searchController,
              cursorColor: primaryColor,
              decoration: const InputDecoration(
                hintText: "What do you feel like doing?",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                debouncer.run(() => ref.read(eventStateProvider.notifier).updateSearchQuery(value));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButtons(BuildContext context, WidgetRef ref, categoryState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => categoryState.selectedCategory.isEmpty
                ? showCategoryBottomSheet(context: context, ref: ref)
                : ref.read(eventStateProvider.notifier).updateSelectedCategory(selectedCategory: ""),
            child: _filterButton(
              capitalizeFirstLetter(categoryState.selectedCategory.isEmpty ? "Category" : categoryState.selectedCategory),
              categoryState.selectedCategory.isEmpty ? Icons.arrow_drop_down : Icons.cancel,
              color: categoryState.selectedCategory.isEmpty ? null : primaryColor,
            ),
          ),
          GestureDetector(
            onTap: () => showDateBottomSheet(
              context: context,
              selectedDate: DateTime.now(),
              onDateSelected: (date) {},
            ),
            child: _filterButton("Date", Icons.arrow_drop_down),
          ),
          GestureDetector(
            onTap: () => showPriceRangeBottomSheet(context, ref),
            child: _filterButton("Price", Icons.arrow_drop_down),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String text, IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(text, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          Icon(icon, color: Colors.black54, size: 20),
        ],
      ),
    );
  }

  Widget _buildEventList(BuildContext context, WidgetRef ref, categoryState) {
    final eventsList = categoryState.eventList;
    // final eventsList = ref.read(eventStateProvider.notifier).filteredEvents;
    if (categoryState.isLoading) return const ListShimmer();
    if (eventsList.isEmpty) return const Center(child: Text("No events found"));

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 600),
      crossFadeState: categoryState.showAsList == true ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: AnimatedListViewBuilder(
        itemCount: eventsList.length,
        itemBuilder: (context, index) => _eventCard(context, ref, eventsList[index], true),
      ),
      secondChild: AnimatedGridViewBuilder(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        milliseconds: 600,
        itemCount: eventsList.length,
        itemBuilder: (context, index) => _eventCard(context, ref, eventsList[index], false),
      ),
    );
  }

  Widget _eventCard(BuildContext context, WidgetRef ref, EventData event, bool isList) {

    return InkWell(
      onTap: (){
        FocusScope.of(context).unfocus();
        HapticFeedback.mediumImpact();
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (_, __, ___) => EventDetailScreen(event: event),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: isList ? _listItem(context, ref, event,) : _gridItem(context, event),
    );
  }

  Widget _listItem(BuildContext context, WidgetRef ref, EventData event,) {
    final favoriteNotifier = ref.read(favoriteProvider.notifier);
    final String heroTag = 'event-${event.eventId ?? event.thumbUrl ?? UniqueKey().toString()}';
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // customNetworkImage(
          //   imageUrl: event.thumbUrl,
          //   width: 100,
          //   height: 100,
          //   borderRadius: 12,
          // ),
          //

          Hero(
            tag: heroTag,
            flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
              return FadeTransition(
                opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
                child: toHeroContext.widget,
              );
            },
            child: customNetworkImage(
              imageUrl: event.thumbUrl,
              width: 100,
              height: 100,
              borderRadius: 12,
            ),
          ),


          const SizedBox(width: 12),
          Expanded(
            child: AnimatedColumn(
              milliseconds: 700,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.eventname ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(event.location ?? "", style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Divider(height: 5, color: Colors.grey.shade300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(event.label ?? "", style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
                    Row(
                      children: [
                        FavoriteIconButton(eventId: event.eventId ?? "-"),

                        IconButton(
                          icon: const Icon(Icons.file_upload_outlined, color: Colors.grey),
                          onPressed: () => shareContent(event.shareUrl),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _gridItem(BuildContext context, EventData event) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: AnimatedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          customNetworkImage(
            imageUrl: event.thumbUrl,
            width: double.infinity,
            height: 100,
            borderRadius: 8,
          ),

          const SizedBox(height: 12),
          Text(event.eventname ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  void showCategoryBottomSheet({required BuildContext context, required WidgetRef ref}) {
    final categoryState = ref.watch(eventStateProvider);
    final stateNotifier = ref.read(eventStateProvider.notifier);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text.rich(TextSpan(text: 'Choose Your Preferred ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600), children: [TextSpan(text: 'Category', style: TextStyle(color: primaryColor))])),
                IconButton(
                  icon: Icon(categoryState.showAsList == true ? Icons.view_list_rounded : Icons.grid_view_rounded, color: Colors.grey.shade600),
                  onPressed: () {
                    Navigator.pop(context);
                    stateNotifier.updateShowAsList(value: !categoryState.showAsList!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...categoryState.categories.map((category) {
              final isSelected = category.category.toLowerCase() == (categoryState.selectedCategory).toLowerCase();
              return ListTile(
                title: Text(category.category.firstCapital(), style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? primaryColor : Colors.black87)),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                  stateNotifier.updateSelectedCategory(selectedCategory: category.category);
                },
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
