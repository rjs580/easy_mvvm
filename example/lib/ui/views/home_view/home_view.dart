import 'package:easy_mvvm/easy_mvvm.dart';
import 'package:example/ui/views/home_view/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeView extends EasyView<HomeViewModel> {
  const HomeView({
    super.key,
    required this.title,
  });

  final String title;

  @override
  bool get canPop => false;

  @override
  PopInvokedContextWithResultCallback? get onPopInvokedWithResult =>
      (context, didPop, result) {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text(
                'Are you sure you want to leave this page?',
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Nevermind'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Leave'),
                  onPressed: () {
                    Navigator.pop(context);
                    SystemNavigator.pop();
                    // Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      };

  @override
  Widget build(
    BuildContext context,
    ThemeData theme,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Click the button below to navigate to the counter.',
            ),
            ElevatedButton(
              child: const Text('Counter View'),
              onPressed: () => viewModel.navigateToCounterView(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelFactory() => HomeViewModel();
}
