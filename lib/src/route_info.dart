import 'package:easy_mvvm/src/route_transition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A mixin to add route information to [Widget]
mixin RouteInfo on Widget {
  /// If the route is protected or not
  bool get isProtectedRoute => false;

  /// Transition for the route
  RouteTransition get routeTransition => kIsWeb ? RouteTransition.none : RouteTransition.appDefault;

  /// Transition duration for the route
  Duration get routeTransitionDuration => const Duration(milliseconds: 320);

  /// The color to use for the background color during the transition.
  ///
  /// This defaults to the [Theme]'s [ThemeData.canvasColor].
  Color? get routeTransitionBackgroundColor => null;
}