import 'package:get_it/get_it.dart';

/// A simple Service Locator. It is used to register [EasyViewModel]
/// and any other services within the app.
///
/// ```dart
/// // set up navigation service
/// locator.registerSingleton<NavigationService>(NavigationService());
///
/// // use the navigation service anywhere
/// final NavigationService navigationService = locator<NavigationService>();
/// ```
///
/// More Info: https://pub.dev/packages/get_it
final GetIt locator = GetIt.instance;
