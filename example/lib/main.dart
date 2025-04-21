import 'package:easy_mvvm/easy_mvvm.dart';
import 'package:example/app/locator.dart';
import 'package:example/app/routes.dart';
import 'package:example/ui/views/splash_view/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  // if any of the code calls native code
  // (ios/js/android/etc) then you need to call this
  WidgetsFlutterBinding.ensureInitialized();

  // Setup the locator
  setupLocator();

  // Setup the routes
  setupRoutes();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // add the initial route (it can also be the `RouteService().homeView`)
      initialRoute: RouteService.path<SplashView>(),
      // this allows the [RouteService] to generate the necessary routes
      onGenerateRoute: RouteService().onGenerateRoute,
    );
  }
}
