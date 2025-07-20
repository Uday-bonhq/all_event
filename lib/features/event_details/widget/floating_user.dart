import 'dart:math';
import 'package:all_event/features/event_details/widget/people_stack.dart';
import 'package:flutter/material.dart';

void showFloatingAvatarsBottomSheet(BuildContext context,) {

  List<Map<String, dynamic>> userNames = generateRandomAlphabets(25);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SizedBox(
      height: 400,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        // fit: StackFit.expand,
        children: [
          for (var user in userNames) FloatingAvatar(user: user),

        ],
      ),
    ),
  );
}

List<Map<String, dynamic>> generateRandomAlphabets(int count) {
  final random = Random();
  return List.generate(count, (_) {
    int asciiCode = 65 + random.nextInt(26); // ASCII of 'A' is 65, 'Z' is 90
    return {
      "name" :String.fromCharCode(asciiCode),
      "color" : getRandomColor(),
    };
  });
}


class FloatingAvatar extends StatefulWidget {
  final Map<String, dynamic> user;

  const FloatingAvatar({super.key, required this.user});

  @override
  State<FloatingAvatar> createState() => _FloatingAvatarState();
}

class _FloatingAvatarState extends State<FloatingAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double topOffset;
  late double leftOffset;

  @override
  void initState() {
    super.initState();
    topOffset = randomOffset();
    leftOffset = randomOffset();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000 + (Random().nextInt(2000))),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  double randomOffset() => Random().nextDouble() * 400;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topOffset + _animation.value,
      left: leftOffset + _animation.value,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: widget.user['color'],
        child: Text(
          widget.user['name'][0].toUpperCase(),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}


class FloatingAvatarBottomSheet extends StatefulWidget {
  final List<String> names;

  const FloatingAvatarBottomSheet({Key? key, required this.names}) : super(key: key);

  @override
  _FloatingAvatarBottomSheetState createState() => _FloatingAvatarBottomSheetState();
}

class _FloatingAvatarBottomSheetState extends State<FloatingAvatarBottomSheet> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.names.length,
          (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2000 + Random().nextInt(1000)),
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 20).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOutSine,
        ),
      );
    }).toList();

    for (var controller in _controllers) {
      controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Color getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.names.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[index].value),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: getRandomColor(),
                  child: Text(
                    widget.names[index][0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Example usage:
/*
void showFloatingAvatarBottomSheet(BuildContext context) {
  final List<String> names = [
    'Alice', 'Bob', 'Charlie', 'David', 'Emma',
    'Frank', 'Grace', 'Henry', 'Isabella', 'Jack',
    'Kelly', 'Liam', 'Mia', 'Noah', 'Olivia',
    'Peter', 'Quinn', 'Rachel', 'Sam', 'Tara',
  ];

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => FloatingAvatarBottomSheet(names: names),
  );
}
*/