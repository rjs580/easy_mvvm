import 'package:easy_mvvm/easy_mvvm.dart';
import 'package:example/ui/views/counter_view/counter_view.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends EasyViewModel {
  void navigateToCounterView(BuildContext context) {
    Navigator.of(context).pushNamed(RouteService.path<CounterView>());
  }
}
