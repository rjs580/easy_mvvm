import 'package:easy_mvvm/src/base_view.dart';
import 'package:easy_mvvm/src/locator.dart';
import 'package:easy_mvvm/src/route_info.dart';
import 'package:easy_mvvm/src/view_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// abstract class TestView<T extends ViewModel> extends Widget with RouteInfo {
//   const TestView({Key? key}) : super(key: key);
//
//   @protected
//   Widget build(BuildContext context, T viewModel);
//
//   @required
//   @protected
//   T viewModelFactory();
// }
//
// class _TestViewElement<T extends ViewModel> extends ComponentElement {
//   _TestViewElement(TestView widget) : super(widget);
//
//   @override
//   TestView get widget => super.widget as TestView<T>;
//
//   @override
//   Widget build() =>
//       widget.build(this, widget.viewModelFactory());
//
//   @override
//   void update(TestView newWidget) {
//     super.update(newWidget);
//     assert(widget == newWidget);
//     rebuild();
//   }
// }

/// Abstract class that simplifies the use of complicated mvvm
/// architecture.
abstract class View<T extends ViewModel> extends StatelessWidget with RouteInfo {
  const View({
    Key? key
  }) : super(key: key);

  /// Called when this view needs to be built.
  @required
  @protected
  Widget buildView(BuildContext context, ThemeData theme, T viewModel, Widget? child);

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
  @nonVirtual
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: BaseView<T>(
        viewModelFactory: viewModelFactory,
        onInit: init,
        onDispose: dispose,
        builder: (context, viewModel, child) => buildView(context, theme, viewModel, child),
      ),
    );
  }
}