import 'package:easy_mvvm/easy_mvvm.dart' show RouteTransition;
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:meta/meta.dart';

/// Custom page route builder to add custom animations
///
/// The animations are provided from the animations package
///   maintained by flutter.dev
///  Link: https://pub.dev/packages/animations
@internal
class CustomPageRouteBuilder extends PageRouteBuilder {
  CustomPageRouteBuilder({
    required RouteTransition routerTransition,
    required Widget child,
    Duration? transitionDuration,
    RouteSettings? settings,
    Color? backgroundColor,
  }): super(
    settings: settings,
    transitionDuration: transitionDuration ?? const Duration(milliseconds: 300),
    reverseTransitionDuration: transitionDuration ?? const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (routerTransition) {
        case RouteTransition.none:
          break;
        case RouteTransition.appDefault:
          break;
        case RouteTransition.fadeScale:
          return FadeScaleTransition(
            animation: animation,
            child: child,
          );
        case RouteTransition.fadeThrough:
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            fillColor: backgroundColor,
            child: child,
          );
        case RouteTransition.scaledSharedAxis:
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            fillColor: backgroundColor,
            child: child,
          );
        case RouteTransition.verticalSharedAxis:
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.vertical,
            fillColor: backgroundColor,
            child: child,
          );
        case RouteTransition.horizontalSharedAxis:
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: backgroundColor,
            child: child,
          );
      }

      return child;
    },
  );
}