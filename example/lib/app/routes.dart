import 'package:easy_mvvm/easy_mvvm.dart';
import 'package:example/services/user_service.dart';
import 'package:example/ui/views/counter_view/counter_view.dart';
import 'package:example/ui/views/home_view/home_view.dart';
import 'package:example/ui/views/splash_view/splash_view.dart';

/// Setup all the routes in here
void setupRoutes() {
  final RouteService router = RouteService();
  router.homeView = const SplashView();

  router.isAuthenticated = () {
    return locator<UserService>().isUserSignedIn;
  };

  router.defineRoute<SplashView>(instance: () => const SplashView(), path: 'splash', className: 'SplashView');
  router.defineRoute<HomeView>(instance: () => const HomeView(title: 'Home'), path: 'home', className: 'HomeView');
  router.defineRoute<CounterView>(instance: () => const CounterView(), path: 'counter', className: 'CounterView');
}
