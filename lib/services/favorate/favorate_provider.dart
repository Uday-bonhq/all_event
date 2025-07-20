import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:toastification/toastification.dart';

class FavoriteNotifier extends StateNotifier<Set<String>> {
  final Box _box = Hive.box('favorites');

  FavoriteNotifier() : super({}) {
    final stored = _box.get('event_ids', defaultValue: <String>[]);
    state = Set<String>.from(stored);
  }

  void toggleFavorite(context,String eventId) {
    HapticFeedback.mediumImpact();
    final updated = Set<String>.from(state);
    bool isContains = updated.contains(eventId);
    if (isContains) {
      updated.remove(eventId);
    } else {
      updated.add(eventId);
    }


    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      title: const Text("Success"),
      description: Text("Event ${!isContains ? "Save" : "Remove"} as Favorite!!"),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      // applyBlurEffect: true,
    );

    state = updated;
    _box.put('event_ids', state.toList());
  }

  bool isFavorite(String eventId) {
    return state.contains(eventId);
  }

  void clearFavorites() {
    state = {};
    _box.put('event_ids', []);
  }
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, Set<String>>(
      (ref) => FavoriteNotifier(),
);
