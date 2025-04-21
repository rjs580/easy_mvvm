import 'package:easy_mvvm/src/easy_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that rebuilds when specific properties of an [EasyViewModel] change.
///
/// This allows for more granular control over widget rebuilding compared to
/// rebuilding the entire widget tree when any property changes.
class MultiPropertyBuilder<T extends EasyViewModel> extends StatefulWidget {
  /// Creates a [MultiPropertyBuilder].
  ///
  /// The [viewModel] parameter is the view model instance to listen to.
  /// The [propertyNames] are the names of specific properties to watch for changes.
  /// The [builder] function is called to build the widget whenever the watched properties change.
  const MultiPropertyBuilder({
    super.key,
    required this.viewModel,
    required this.propertyNames,
    required this.builder,
  });

  /// The view model instance to listen to for property changes.
  final T viewModel;

  /// The list of property names to watch for changes.
  final List<String> propertyNames;

  /// Builder function called when any of the watched properties change.
  ///
  /// This function receives the current build context and should return
  /// a widget that represents the UI for the current state.
  final Widget Function(BuildContext context) builder;

  @override
  State<MultiPropertyBuilder<T>> createState() =>
      _MultiPropertyBuilderState<T>();
}

class _MultiPropertyBuilderState<T extends EasyViewModel>
    extends State<MultiPropertyBuilder<T>> {
  void _rebuildOnPropertyChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    for (final property in widget.propertyNames) {
      widget.viewModel.addPropertyListener(property, _rebuildOnPropertyChange);
    }
  }

  @override
  void didUpdateWidget(MultiPropertyBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.viewModel != widget.viewModel ||
        !listEquals(oldWidget.propertyNames, widget.propertyNames)) {
      // Remove old listeners
      for (final property in oldWidget.propertyNames) {
        oldWidget.viewModel.removePropertyListener(
          property,
          _rebuildOnPropertyChange,
        );
      }

      // Add new listeners
      for (final property in widget.propertyNames) {
        widget.viewModel.addPropertyListener(
          property,
          _rebuildOnPropertyChange,
        );
      }
    }
  }

  @override
  void dispose() {
    for (final property in widget.propertyNames) {
      widget.viewModel.removePropertyListener(
        property,
        _rebuildOnPropertyChange,
      );
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
