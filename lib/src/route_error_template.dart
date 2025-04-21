import 'package:flutter/material.dart';

/// Template used to display errors that occur during routing using the RouteService
class RouteErrorTemplate extends StatelessWidget {
  const RouteErrorTemplate({
    super.key,
    required this.errorDescription,
    this.actionText,
    this.onAction,
  });

  /// Describes the error for this route
  final String errorDescription;

  /// Action text that should be taken on this error page, for example
  /// 'Go back home'
  final String? actionText;

  /// When the [actionText] is tapped on
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              errorDescription,
              style: theme.textTheme.headlineMedium,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (actionText != null)
              ElevatedButton(
                onPressed: onAction,
                child: Text(
                  actionText!,
                  style: theme.textTheme.labelLarge,
                  softWrap: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
