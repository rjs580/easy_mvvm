import 'package:easy_mvvm/src/locator.dart';
import 'package:easy_mvvm/src/easy_view_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Listens to changes in in [EasyViewModel].
@internal
class BaseView<T extends EasyViewModel> extends StatefulWidget {
  const BaseView({
    super.key,
    required this.builder,
    required this.viewModelFactory,
    this.onInit,
    this.onDispose,
    this.child,
  });

  /// Builder to help use applicable values from the model to build its
  /// view (widget).
  final Widget Function(BuildContext context, T model, Widget? child) builder;

  /// Called when the model is ready/initialized.
  final void Function(T model)? onInit;

  /// Called when the model is about to be disposed.
  final void Function(T model)? onDispose;

  /// Called to register the view model to get_it so it can be used with [locator].
  final T Function() viewModelFactory;

  /// Use this for optimizing expensive widgets that will or
  /// do not need to be rebuilt every time the model changes.
  final Widget? child;

  @override
  BaseViewState<T> createState() => BaseViewState<T>();
}

class BaseViewState<T extends EasyViewModel> extends State<BaseView<T>> {
  /// Reference to the initialized [EasyViewModel]. It is lazy loaded.
  late final T _model;

  /// Track whether the view model has been initialized to prevent duplicate init calls
  bool _isInitialized = false;

  @override
  void initState() {
    if (!locator.isRegistered<T>()) {
      locator.registerFactory(widget.viewModelFactory);
    }

    _model = locator<T>();

    super.initState();

    widget.onInit?.call(_model);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized && mounted) {
      // Context can be safely used at this point
      _model.init(context);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    widget.onDispose?.call(_model);
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _model,
      builder: (context, child) => widget.builder(context, _model, child),
      child: widget.child,
    );
  }
}
