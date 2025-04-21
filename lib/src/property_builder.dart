import 'package:easy_mvvm/src/easy_view_model.dart';
import 'package:flutter/material.dart';

/// A widget that rebuilds its child when a specific property in a [EasyViewModel] changes.
///
/// This is useful when you want to optimize rebuilds to only occur when specific
/// properties change rather than when any property in the view model changes.
class PropertyBuilder<T extends EasyViewModel> extends StatefulWidget {
  /// Creates a [PropertyBuilder] widget.
  ///
  /// The [viewModel] parameter is the view model containing the property to watch.
  /// The [propertyName] is the name of the property to watch for changes.
  /// The [builder] function is called to build the child widget when the property changes.
  const PropertyBuilder({
    super.key,
    required this.viewModel,
    required this.propertyName,
    required this.builder,
  });

  /// The view model containing the property to watch for changes.
  final T viewModel;

  /// The name of the property in the view model to watch for changes.
  final String propertyName;

  /// Builder function called when the watched property changes.
  ///
  /// This function should return the widget tree that depends on the watched property.
  final Widget Function(BuildContext context) builder;

  @override
  State<PropertyBuilder<T>> createState() => _PropertyBuilderState<T>();
}

class _PropertyBuilderState<T extends EasyViewModel>
    extends State<PropertyBuilder<T>> {
  void _rebuildOnPropertyChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    widget.viewModel.addPropertyListener(
      widget.propertyName,
      _rebuildOnPropertyChange,
    );
  }

  @override
  void didUpdateWidget(PropertyBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.viewModel != widget.viewModel ||
        oldWidget.propertyName != widget.propertyName) {
      oldWidget.viewModel.removePropertyListener(
        oldWidget.propertyName,
        _rebuildOnPropertyChange,
      );

      widget.viewModel.addPropertyListener(
        widget.propertyName,
        _rebuildOnPropertyChange,
      );
    }
  }

  @override
  void dispose() {
    widget.viewModel.removePropertyListener(
      widget.propertyName,
      _rebuildOnPropertyChange,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
