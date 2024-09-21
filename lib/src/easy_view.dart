import 'package:easy_mvvm/src/base_view.dart';
import 'package:easy_mvvm/src/locator.dart';
import 'package:easy_mvvm/src/route_info.dart';
import 'package:easy_mvvm/src/easy_view_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@Deprecated('Use [EasyView]')
typedef View<T extends EasyViewModel> = EasyView<T>;

/// A callback type for informing that a navigation pop has been invoked,
/// whether or not it was handled successfully.
///
/// Accepts a didPop boolean indicating whether or not back navigation
/// succeeded.
@Deprecated('Use [PopInvokedContextWithResultCallback]')
typedef PopInvokedContextCallback = void Function(
    BuildContext context, bool didPop);

/// A callback type for informing that a navigation pop has been invoked,
/// whether or not it was handled successfully.
///
/// Parameters:
/// - [context]: The BuildContext in which the pop was invoked.
/// - [didPop]: A boolean indicating whether or not back navigation succeeded.
/// - [result]: The optional result of the pop action.
typedef PopInvokedContextWithResultCallback<T> = void Function(
    BuildContext context, bool didPop, T? result);

/// Abstract class that simplifies the use of complicated mvvm
/// architecture.
abstract class EasyView<T extends EasyViewModel> extends Widget with RouteInfo {
  const EasyView({Key? key}) : super(key: key);

  /// Called when this view needs to be built.
  @required
  @protected
  Widget build(
      BuildContext context, ThemeData theme, T viewModel, Widget? child);

  /// It is used to register the [EasyViewModel] if not already registered to the [locator].
  @required
  @protected
  T viewModelFactory();

  /// Use this for optimizing expensive widgets that will or
  /// do not need to be rebuilt every time the model changes.
  @protected
  Widget? child(BuildContext context, ThemeData theme) => null;

  /// {@template flutter.widgets.PopScope.onPopInvoked}
  /// Called after a route pop was handled.
  /// {@endtemplate}
  ///
  /// It's not possible to prevent the pop from happening at the time that this
  /// method is called; the pop has already happened. Use [canPop] to
  /// disable pops in advance.
  ///
  /// This will still be called even when the pop is canceled. A pop is canceled
  /// when the relevant [Route.popDisposition] returns false, such as when
  /// [canPop] is set to false on a [PopScope]. The `didPop` parameter
  /// indicates whether or not the back navigation actually happened
  /// successfully.
  @protected
  @Deprecated('Use [onPopInvokedWithResult]')
  PopInvokedContextCallback? get onPopInvoked => null;

  /// {@template flutter.widgets.PopScope.onPopInvokedWithResult}
  ///
  /// Called after a route pop was handled. It's not possible to prevent the pop
  /// from happening at the time that this method is called; the pop has already
  /// happened. Use [canPop] to disable pops in advance.
  ///
  /// This will still be called even when the pop is canceled. A pop is canceled
  /// when the relevant [Route.popDisposition] returns false, such as when
  /// [canPop] is set to false on a [PopScope]. The `didPop` parameter
  /// indicates whether or not the back navigation actually happened
  /// successfully.
  ///
  /// {@endtemplate}
  @protected
  PopInvokedContextWithResultCallback<dynamic>? get onPopInvokedWithResult =>
      null;

  /// {@template flutter.widgets.PopScope.canPop}
  /// When false, blocks the current route from being popped.
  ///
  /// This includes the root route, where upon popping, the Flutter app would
  /// exit.
  ///
  /// If multiple [PopScope] widgets appear in a route's widget subtree, then
  /// each and every `canPop` must be `true` in order for the route to be
  /// able to pop.
  ///
  /// [Android's predictive back](https://developer.android.com/guide/navigation/predictive-back-gesture)
  /// feature will not animate when this boolean is false.
  /// {@endtemplate}
  @protected
  bool get canPop => true;

  /// Remove the [PopScope] from the tree.
  @protected
  bool get removePopScope => false;

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
@internal
class ViewElement<T extends EasyViewModel> extends ComponentElement {
  ViewElement(EasyView widget) : super(widget);

  @override
  EasyView<T> get widget => super.widget as EasyView<T>;

  @override
  Widget build() {
    final ThemeData theme = Theme.of(this);

    Widget child = BaseView<T>(
      viewModelFactory: widget.viewModelFactory,
      onInit: widget.init,
      onDispose: widget.dispose,
      child: widget.child?.call(this, theme),
      builder: (context, viewModel, child) =>
          widget.build(context, theme, viewModel, child),
    );

    if (!widget.removePopScope) {
      child = PopScope<dynamic>(
        canPop: widget.canPop,
        onPopInvoked: (didPop) => widget.onPopInvoked?.call(this, didPop),
        onPopInvokedWithResult: (didPop, result) =>
            widget.onPopInvokedWithResult?.call(this, didPop, result),
        child: child,
      );
    }

    return child;
  }

  @override
  void update(EasyView newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    rebuild();
  }
}
