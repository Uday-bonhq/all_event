import 'dart:math';

import 'package:all_event/core/app_colors.dart';
import 'package:all_event/features/event_details/widget/floating_user.dart';
import 'package:flutter/material.dart';

Widget buildPeopleStack(context,List<String> names) {
  return Row(
    // crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // ✅ CircleAvatar Stack (max 3)
      SizedBox(
        height: 30,
        width: 80,
        child: Stack(
          children: List.generate(names.length.clamp(0, 3), (index) {
            return Positioned(
              left: index * 20, // Adjust overlap
              child: CircleAvatar(
                radius: 14,
                backgroundColor: getRandomColor(),
                child: Text(
                  names[index][0].toUpperCase(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
        ),
      ),
      const SizedBox(width: 8),
      GestureDetector(
        onTap: (){
          // FloatingAvatarBottomSheet(names: names);
          showFloatingAvatarsBottomSheet(context,);
        },
        child: const Text(
          "View All",
          style: TextStyle(fontSize: 12,
              color: primaryColor,
              fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );
}

String _generateNamesText(List<String> names) {
  if (names.isEmpty) return 'No one interested';
  if (names.length <= 3) {
    return names.join(', ');
  } else {
    final firstTwo = names.take(2).join(', ');
    final remaining = names.length - 2;
    return '$firstTwo, +$remaining more';
  }
}


/// Generates a random color.
Color getRandomColor() {
  final colors = [
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.purple.shade100,
    Colors.orange.shade100,
    Colors.teal.shade100,
    Colors.pink.shade100,
    Colors.deepOrange.shade200,
    Colors.amber.shade100,
    Colors.purpleAccent.shade100,
    Colors.limeAccent.shade200,
    Colors.cyan.shade200,
  ];
  return colors[Random().nextInt(colors.length)];
}
