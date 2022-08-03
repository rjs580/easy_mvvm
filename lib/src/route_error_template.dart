import 'package:flutter/material.dart';

/// Template used to display errors that occur during routing using the RouteService
class RouteErrorTemplate extends StatelessWidget {
  const RouteErrorTemplate({
    Key? key,
    required this.errorDescription,
    this.actionText,
    this.onAction,
  }) : super(key: key);

  /// Describes the error for this route
  final String errorDescription;

  /// Action text that should be taken on this error page, for example
  /// 'Go back home'
  final String? actionText;

  /// When the [actionText] is tapped on
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(errorDescription, style: _theme.textTheme.headlineMedium, softWrap: true, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            if (actionText != null)
              ElevatedButton(
                child: Text(actionText!, style: _theme.textTheme.labelLarge, softWrap: true),
                onPressed: onAction,
              ),
          ],
        ),
      ),
    );
  }
}