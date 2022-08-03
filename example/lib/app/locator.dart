import 'package:easy_mvvm/easy_mvvm.dart';
import 'package:example/services/user_service.dart';

setupLocator() {
  locator.registerLazySingleton<UserService>(() => UserService());
}