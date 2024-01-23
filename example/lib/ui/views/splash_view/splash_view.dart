import 'package:easy_mvvm/easy_mvvm.dart';
import 'package:example/ui/views/home_view/home_view.dart';
import 'package:flutter/material.dart';

// Custom widget can be created with the route info for navigation
class SplashView extends StatefulWidget with RouteInfo {
  const SplashView({Key? key}) : super(key: key);

  @override
  RouteTransition get routeTransition => RouteTransition.fadeScale;

  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    locator.allReady().whenComplete(() async {
      // todo: check state of services and internet before continuing
      await Future.delayed(const Duration(milliseconds: 500));

      Navigator.of(context).pushReplacementNamed(RouteService.path<HomeView>());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome'),
          Text('To'),
          Text('Easy MVVM'),
        ],
      ),
    );
  }
}
