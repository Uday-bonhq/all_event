import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class AnimatedColumn extends StatelessWidget {
  final List<Widget> children;
  final int milliseconds;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final double? leftPadding, rightPadding, topPadding, bottomPadding;

  const AnimatedColumn(
      {super.key,
        required this.children,
        this.milliseconds = 275,
        this.crossAxisAlignment,
        this.mainAxisAlignment,
        this.mainAxisSize,
        this.leftPadding,
        this.rightPadding,
        this.topPadding,
        this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: rightPadding ?? 0,
          left: leftPadding ?? 0),
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
          mainAxisSize: mainAxisSize ?? MainAxisSize.max,
          children: AnimationConfiguration.toStaggeredList(
            duration: Duration(milliseconds: milliseconds),//375
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 10,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: children,
          ),
        ),
      ),
    );
  }
}


class AnimatedListViewBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final int? milliseconds;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool reverse;
  final ScrollController? scrollController;
  final Axis? scrollDirection;
  final double? leftPadding, rightPadding, topPadding, bottomPadding;

  const AnimatedListViewBuilder({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.milliseconds,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.leftPadding,
    this.padding,
    this.rightPadding,
    this.physics,
    this.topPadding,this.scrollController,
    this.bottomPadding, this.reverse = false,  this.scrollDirection,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: itemCount,
        physics: physics ?? const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: scrollDirection ?? Axis.vertical,
        reverse: reverse,
        controller: scrollController,
        padding: padding,
        itemBuilder: (context, index) {
          final animatedWidget = itemBuilder(context, index);
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: milliseconds ?? 200),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: animatedWidget,
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedGridViewBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final int? milliseconds;
  final double? gridItemExtent;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int? crossAxisCount;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;

  const AnimatedGridViewBuilder({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.milliseconds,
    this.gridItemExtent,
    this.crossAxisCount,
    this.crossAxisAlignment,
    this.crossAxisSpacing = 4,
    this.mainAxisSpacing = 4,
    this.mainAxisAlignment,
    this.mainAxisSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount ?? 2, // default value
          crossAxisSpacing: crossAxisSpacing, // you can adjust this as per your needs
          mainAxisSpacing: mainAxisSpacing, // you can adjust this as per your needs
          childAspectRatio: gridItemExtent != null
              ? MediaQuery.of(context).size.width /
              (gridItemExtent! + 4) // +4 for spacing
              : 1,
        ),
        itemBuilder: (context, index) {
          final animatedWidget = itemBuilder(context, index);
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: crossAxisCount ?? 2,
            duration: Duration(milliseconds: milliseconds ?? 200),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: animatedWidget,
              ),
            ),
          );
        },
      ),
    );
  }
}