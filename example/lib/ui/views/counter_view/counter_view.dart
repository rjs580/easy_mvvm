import 'package:easy_mvvm/easy_mvvm.dart';
import 'package:example/ui/views/counter_view/counter_view_model.dart';
import 'package:flutter/material.dart';

class CounterView extends EasyView<CounterViewModel> {
  const CounterView({
    super.key,
  });

  @override
  RouteTransition get routeTransition => RouteTransition.scaledSharedAxis;

  @override
  Duration get routeTransitionDuration => const Duration(milliseconds: 500);

  @override
  Widget build(
    BuildContext context,
    ThemeData theme,
    CounterViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            PropertyBuilder(
              viewModel: viewModel,
              propertyName: CounterViewModel.counterProperty,
              builder: (context) {
                return Text(
                  '${viewModel.counter}',
                  style: theme.textTheme.labelLarge,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  CounterViewModel viewModelFactory() => CounterViewModel();
}
