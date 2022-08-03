import 'dart:collection';

import 'package:easy_mvvm/src/custom_page_route_builder.dart';
import 'package:easy_mvvm/src/defined_routes.dart';
import 'package:easy_mvvm/src/route_error_template.dart';
import 'package:easy_mvvm/src/route_info.dart';
import 'package:easy_mvvm/src/route_transition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

/// Service to navigate through routes within the app
///
/// ```dart
/// void main () {
///   setupRoutes();
/// }
///
/// void setupRoutes() {
///   // dependency
///   String? serviceLoadedDependency() {
///     if (someDependentService == null) {
///       // route to this path as service is not loaded
///       return RouteService.path<ExampleClass>();
///     }
///
///     return null;
///   }
///
///   final RouteService router = RouteService.instance;
///
///   router.defineRoute<ExampleClass>(
///     instance: () => const ExampleClass(),
///     path: 'example',
///     className: 'ExampleClass',
///   );
///
///   router.defineRoute<SecondExampleClass>(
///     instance: () => const SecondExampleClass(),
///     path: 'second_example',
///     className: 'SecondExampleClass',
///     dependencies: serviceLoadedDependency,
///   );
///
///   router.defineRoute<SomeClassWithDrawer>(
///     instance: () => const SomeClassWithDrawer(),
///     path: 'some_class_with_drawer',
///     className: 'SomeClassWithDrawer',
///     title: 'Some Header',
///   );
/// }
///
/// void navigateToExampleClass() {
///   Navigator.of(context).pushNamed(RouterService.path<ExampleClass>());
/// }
/// ```
class RouteService {
  static const String kUnknownPath = 'unknown';
  static const String kUnknownClass = 'UnknownClass';
  static const String kUnknownTitle = 'Unknown Title';

  /// Get an instance of [RouteService]
  ///
  /// ```dart
  /// final RouteService routeService = RouteService.instance;
  /// ```
  static final RouteService instance = RouteService._();

  /// Get an instance of [RouteService]
  ///
  /// ```dart
  /// final RouteService routeService = RouteService();
  /// ```
  factory RouteService() => instance;

  /// Restrict creating [RouteService] outside of its class since
  /// [RouteService] is a singleton
  RouteService._();

  /// Keep a reference of the defined route using class type name
  ///
  /// Convenient for routing using class types
  final HashMap<String, DefinedRoutes> _classRoutes = HashMap();

  /// Keep a reference of the defined route using the path of the route
  ///
  /// Convenient for displaying the path of the routes in web, or
  /// simply for analytics
  final HashMap<String, DefinedRoutes> _pathRoutes = HashMap();

  /// Check if the user is authenticated.
  ///
  /// returns true by default if no value is provided
  bool Function()? isAuthenticated;

  /// Let the user know they are accessing a protected route, useful
  /// when users can jump between views for example when they are on the
  /// web, users are allowed to enter in what ever in the link
  Widget? unauthorizedView;

  /// Let the user know the route they are trying to reach is unknown,
  /// or simply not found. Also useful for developers when routing to
  /// a wrong page or undefined view
  Widget? routeNotFoundView;

  /// Route to this page when '/' is the route, mainly used for flutter web
  RouteInfo? homeView;

  /// The key for the defined routes stored within [_classRoutes]
  ///
  /// Convenient for routing using class types
  String _routeKey<T extends RouteInfo>() => T.toString().snakeCase;

  /// Path for the route from the given type [T]. If the given type [T] does
  /// not exist then [kUnknownPath] with be returned.
  ///
  /// ```dart
  /// RouteService().routePath<ExampleClass>();
  /// // or
  /// RouteService.instance.routePath<ExampleClass>();
  /// ```
  String routePath<T extends RouteInfo>() => _classRoutes[_routeKey<T>()]?.path ?? kUnknownPath;

  /// Path for the route from the given type [T]. If the given type [T] does
  /// not exist then [kUnknownPath] with be returned.
  ///
  /// ```dart
  /// RouteService.path<ExampleClass>();
  /// ```
  static String path<T extends RouteInfo>() => instance.routePath<T>();

  /// Define the route for a view of type [T]
  ///
  /// The [instance] being a function allows for loading in the route lazily when the [path]
  /// is requested. [className] is optional, and very useful for Flutter Web as the class names are not accurate
  /// when --release is used due to minification, it can also be used for analytics. The [title] is used for drawers, and web tabs. [dependencies] help
  /// with ensuring that the dependencies are satisfied before showing the requested [path], if not it can return a
  /// new path to redirect to.
  ///
  /// ```dart
  /// // dependency
  /// String? serviceLoadedDependency() {
  ///   if (someDependentService == null) {
  ///     // route to this path as service is not loaded
  ///     return RouteService.path<ExampleClass>();
  ///   }
  ///
  ///   return null;
  /// }
  ///
  /// final RouteService router = RouteService.instance;
  ///
  /// router.defineRoute<ExampleClass>(
  ///   instance: () => const ExampleClass(),
  ///   path: 'example',
  ///   className: 'ExampleClass'
  /// );
  ///
  /// router.defineRoute<SecondExampleClass>(
  ///   instance: () => const SecondExampleClass(),
  ///   path: 'second_example',
  ///   className: 'SecondExampleClass',
  ///   dependencies: serviceLoadedDependency,
  /// );
  ///
  /// router.defineRoute<SomeClassWithDrawer>(
  ///   instance: () => const SomeClassWithDrawer(),
  ///   path: 'some_class_with_drawer',
  ///   className: 'SomeClassWithDrawer',
  ///   title: 'Some Header',
  /// );
  /// ```
  void defineRoute<T extends RouteInfo>({
    required T Function() instance,
    required String path,
    String? className,
    String? title,
    String? Function()? dependencies,
  }) {
    _pathRoutes[path] = _classRoutes[_routeKey<T>()] = DefinedRoutes(
      path: path,
      instanceCreator: instance,
      title: title ?? '',
      className: className ?? T.toString(),
      dependencies: dependencies,
    );
  }

  /// Class name from the given [path]
  String routeClassName(String path) {
    if (kIsWeb) {
      final Uri uri = Uri.parse(path);
      if (uri.pathSegments.isEmpty) {
        return _pathRoutes['/']?.className ?? kUnknownClass;
      } else {
        return uri.pathSegments
            .map((e) => _pathRoutes[e]?.className ?? kUnknownClass).join('/');
      }
    }

    return _pathRoutes[path]?.className ?? kUnknownClass;
  }

  /// Title for the given [path]
  String routeTitle(String path) {
    if (kIsWeb) {
      final Uri uri = Uri.parse(path);
      if (uri.pathSegments.isEmpty) {
        return _pathRoutes['/']?.title ?? kUnknownTitle;
      } else {
        return uri.pathSegments
            .map((e) => _pathRoutes[e]?.title ?? kUnknownTitle).join('/');
      }
    }

    return _pathRoutes[path]?.title ?? kUnknownTitle;
  }

  /// The route generator callback used when the app is navigated to a named route
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    String? routeName = settings.name;

    // update route name for the web
    if (kIsWeb && routeName != null) {
      final Uri uri = Uri.parse(routeName);
      if (uri.pathSegments.isEmpty) {
        routeName = '/';
      } else {
        routeName = uri.pathSegments.join('/');
      }
    }

    if (routeName != null && routeName == '/') {
      RouteInfo? _homeView = homeView;
      if (_homeView != null) {
        if (_homeView.routeTransition == RouteTransition.appDefault) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => _homeView,
          );
        } else {
          return CustomPageRouteBuilder(
            routerTransition: _homeView.routeTransition,
            transitionDuration: _homeView.routeTransitionDuration,
            settings: settings,
            child: _homeView,
          );
        }
      }
    }

    // check dependencies
    final String? Function()? dependencies = _pathRoutes[routeName]?.dependencies;
    final String? satisfiedDependencies = dependencies?.call();

    if (satisfiedDependencies != null) {
      final String tmpRouteName = satisfiedDependencies;
      // check if route exists
      if (_pathRoutes.containsKey(tmpRouteName)) {
        routeName = tmpRouteName;
      }
    }

    dynamic Function()? instanceFunction = _pathRoutes[routeName]?.instanceCreator;
    if (instanceFunction != null) {
      dynamic routeInstance = instanceFunction.call();

      if (routeInstance is RouteInfo) {
        if (routeInstance.isProtectedRoute) {
          if ((isAuthenticated?.call() ?? true)) {
            if (routeInstance.routeTransition == RouteTransition.appDefault) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => routeInstance,
              );
            } else {
              return CustomPageRouteBuilder(
                routerTransition: routeInstance.routeTransition,
                transitionDuration: routeInstance.routeTransitionDuration,
                settings: settings,
                child: routeInstance,
              );
            }
          } else {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => unauthorizedView ?? RouteErrorTemplate(
                errorDescription: 'The requested route $routeName is a protected route and therefore requires users to be authenticated before accessing.',
              ),
            );
          }
        }

        if (routeInstance.routeTransition == RouteTransition.appDefault) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => routeInstance,
          );
        } else {
          return CustomPageRouteBuilder(
            routerTransition: routeInstance.routeTransition,
            transitionDuration: routeInstance.routeTransitionDuration,
            settings: settings,
            child: routeInstance,
          );
        }
      }
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (_) => routeNotFoundView ?? RouteErrorTemplate(
        errorDescription: 'The requested route $routeName was not found.',
      ),
    );
  }
}