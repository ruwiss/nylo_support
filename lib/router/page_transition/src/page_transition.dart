import 'package:flutter/material.dart';
import 'enum.dart';

/// Page transition class extends PageRouteBuilder
class PageTransition<T> extends PageRouteBuilder<T> {
  /// Child for your next page
  final Widget child;

  /// Child for your next page
  final Widget? childCurrent;

  /// Transition types for your page transitions
  final PageTransitionType type;

  /// Curves for transitions
  final Curve curve;

  /// Alignment for transitions
  final Alignment? alignment;

  /// Duration for your transition default is 300 ms
  final Duration duration;

  /// Duration for your pop transition default is 300 ms
  final Duration reverseDuration;

  /// Context for inherit theme
  final BuildContext? ctx;

  /// Optional inherit theme
  final bool inheritTheme;

  /// Optional fullscreen dialog mode
  @override
  // ignore: overridden_fields
  final bool fullscreenDialog;

  @override
  // ignore: overridden_fields
  final bool opaque;

  final bool? maintainStateData;

  @override
  Duration get transitionDuration => duration;

  @override
  Duration get reverseTransitionDuration => reverseDuration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => false;

  /// Page transition constructor. We can pass the next page as a child,
  PageTransition({
    Key? key,
    required this.child,
    required this.type,
    this.childCurrent,
    this.ctx,
    this.inheritTheme = false,
    this.curve = Curves.linear,
    this.alignment,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 200),
    this.fullscreenDialog = false,
    this.opaque = false,
    this.maintainStateData,
    super.settings,
  })  : assert(inheritTheme ? ctx != null : true,
            "'ctx' cannot be null when 'inheritTheme' is true, set ctx: context"),
        super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return inheritTheme
                ? InheritedTheme.captureAll(ctx!, child)
                : child;
          },
          maintainState: maintainStateData ?? true,
          opaque: opaque,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    switch (type) {
      case PageTransitionType.theme:
        return Theme.of(context).pageTransitionsTheme.buildTransitions(
            this, context, animation, secondaryAnimation, child);

      /// PageTransitionType.fade which is the give us fade transition
      case PageTransitionType.fade:
        return FadeTransition(opacity: animation, child: child);

      /// PageTransitionType.rightToLeft which is the give us right to left transition
      case PageTransitionType.rightToLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      /// PageTransitionType.leftToRight which is the give us left to right transition
      case PageTransitionType.leftToRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      /// PageTransitionType.topToBottom which is the give us up to down transition
      case PageTransitionType.topToBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      /// PageTransitionType.downToUp which is the give us down to up transition
      case PageTransitionType.bottomToTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
    }
  }
}
