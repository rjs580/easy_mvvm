import 'package:easy_mvvm/easy_mvvm.dart' show RouteInfo;
import 'package:meta/meta.dart';

/// Used to store route information so it can be mapped by the
/// route service with ease
@internal
class DefinedRoutes<T extends RouteInfo> {
  const DefinedRoutes({
    required this.path,
    required this.instanceCreator,
    required this.className,
    required this.title,
    this.dependencies,
  });

  /// Name of the class for [T], very useful for Flutter Web as the class names are not accurate
  /// since --release uses minification
  final String className;

  /// Path to show for the defined view
  final String path;

  /// Title for the defined view, useful for drawers and flutter web tab titles
  final String title;

  /// Lazy load the instance for the defined view whenever needed
  final T Function() instanceCreator;

  /// Check for dependencies before the defined view is shown
  ///
  /// Returns a redirect path if the dependencies are not met, else returns null
  final String? Function()? dependencies;
}