import 'package:easy_mvvm/easy_mvvm.dart';
import 'package:example/ui/views/home_view/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeView extends View<HomeViewModel> {
  const HomeView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget buildView(BuildContext context, ThemeData theme, HomeViewModel viewModel, Widget? child) {
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