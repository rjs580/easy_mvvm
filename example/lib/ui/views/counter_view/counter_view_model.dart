import 'package:easy_mvvm/easy_mvvm.dart';

class CounterViewModel extends EasyViewModel {
  int _counter = 0;
  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    updateView();
  }
}