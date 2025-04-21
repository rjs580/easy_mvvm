import 'package:easy_mvvm/easy_mvvm.dart';

class CounterViewModel extends EasyViewModel {
  static const String counterProperty = 'counter';

  int _counter = 0;
  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyPropertyChange(counterProperty);
  }
}
