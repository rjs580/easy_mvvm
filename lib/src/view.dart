import 'package:easy_mvvm/src/base_view.dart';
import 'package:easy_mvvm/src/locator.dart';
import 'package:easy_mvvm/src/route_info.dart';
import 'package:easy_mvvm/src/view_model.dart';
import 'package:flutter/material.dart';

/// Abstract class that simplifies the use of complicated mvvm
/// architecture.
abstract class View<T extends ViewModel> extends Widget with RouteInfo {
  const View({
    Key? key
  }) : super(key: key);

  /// Called when this view needs to be built.
  @required
  @protected
  Widget build(BuildContext context, ThemeData theme, T viewModel, Widget? child);

  /// It is used to register the [ViewModel] if not already registered to the [locator].
  @required
  @protected
  T viewModelFactory();

  /// Called to veto attempts by the user to dismiss the enclosing [ModalRoute].
  ///
  /// If the callback returns a Future that resolves to false, the enclosing
  /// route will not be popped.
  @protected
  Future<bool> onWillPop(BuildContext context) {
    // exiting the app
    return Future<bool>.value(true);
  }

  /// Called when this object is inserted into the tree.
  ///
  /// The framework will call this method exactly once for each [State] object
  /// it creates.
  ///
  /// Override this method to perform initialization that depends on the
  /// location at which this object was inserted into the tree (i.e., [context])
  /// or on the widget used to configure this object (i.e., [widget]).
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.init()`.
  @protected
  @mustCallSuper
  void init(T viewModel) {}

  /// Called when this object is removed from the tree permanently.
  ///
  /// The framework calls this method when this [State] object will never
  /// build again. After the framework calls [dispose], the [State] object is
  /// considered unmounted and the [mounted] property is false.
  ///
  /// Subclasses should override this method to release any resources retained
  /// by this object (e.g., stop any active animations).
  ///
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.dispose()`.
  @protected
  @mustCallSuper
  void dispose(T viewModel) {}

  @override
  ViewElement<T> createElement() => ViewElement<T>(this);
}

/// An element that builds up other elements like widgets or views
class ViewElement<T extends ViewModel> extends ComponentElement {
  ViewElement(View widget) : super(widget);

  @override
  View<T> get widget => super.widget as View<T>;

  @override
  Widget build() {
    final ThemeData theme = Theme.of(this);

    return WillPopScope(
      onWillPop: () => widget.onWillPop(this),
      child: BaseView<T>(
        viewModelFactory: widget.viewModelFactory,
        onInit: widget.init,
        onDispose: widget.dispose,
        builder: (context, viewModel, child) => widget.build(context, theme, viewModel, child),
      ),
    );
  }

  @override
  void update(View newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    rebuild();
  }
}
