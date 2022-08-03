import 'package:easy_mvvm/easy_mvvm.dart';
import 'package:example/app/locator.dart';
import 'package:example/app/routes.dart';
import 'package:example/ui/views/splash_view/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  setupRoutes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: RouteService.path<SplashView>(),
      onGenerateRoute: RouteService().onGenerateRoute,
    );
  }
}
