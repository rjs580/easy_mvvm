import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@Deprecated('Use [EasyViewModel]')
typedef ViewModel = EasyViewModel;

/// ViewModel is the middleman for your model and the [EasyView]. Any
/// inputs from your [EasyView] will be forwarded to the [EasyViewModel] and
/// then it will update or change the model. Other way is when the model
/// updates, the state of the [EasyViewModel] changes and the [EasyView] will
/// automatically be asked to update.
class EasyViewModel extends ChangeNotifier {
  /// A map that holds property-specific listeners where:
  /// - The key is the property name as a string
  /// - The value is a list of callback functions that will be notified when the property changes
  final Map<String, List<VoidCallback>> _propertyListeners = {};

  /// The build context that is associated with this view model.
  /// This is set automatically when the view model is created.
  BuildContext? _context;

  /// Whether this view model has been disposed.
  /// Used internally to track disposal state.
  bool _disposed = false;

  /// Busy status for the view model
  bool _busy = false;

  /// Get busy status of the view model. Useful for disabling buttons
  /// or showing loading indicators
  bool get busy => _busy;

  /// Set the busy status and notify the associated view
  set busy(bool value) {
    if (_disposed) return;

    _busy = value;
    notifyListeners();
  }

  /// Called when the model is ready/initialized.
  @mustCallSuper
  void init(BuildContext context) {}

  /// Returns whether this view model is mounted or not by checking if the context exists.
  /// A view model is mounted when it is initialized and not disposed.
  bool get mounted => _context != null;

  /// The current build context associated with this view model.
  ///
  /// Throws a [FlutterError] if the context is null, which means the view model
  /// is either disposed or not yet initialized.
  ///
  /// Use [mounted] to check if the view model is still active before accessing context.
  /// Consider canceling any active work during dispose if getting context errors.
  BuildContext get context {
    assert(() {
      if (_context == null) {
        throw FlutterError(
          'This EasyViewModel has been disposed or not initialized, so it no longer has a context.\n'
          'Consider canceling any active work during "dispose" or using the "mounted" getter to determine if the EasyViewModel is still active.',
        );
      }
      return true;
    }());
    return _context!;
  }

  /// Update the view associated with this view model
  @nonVirtual
  @mustCallSuper
  void updateView() {
    if (_disposed) return;

    notifyListeners();
  }

  /// Registers a listener for a specific property
  void addPropertyListener(String propertyName, VoidCallback listener) {
    if (_disposed) return;

    _propertyListeners.putIfAbsent(propertyName, () => []);
    _propertyListeners[propertyName]!.add(listener);
  }

  /// Removes a listener for a specific property
  void removePropertyListener(String propertyName, VoidCallback listener) {
    if (_disposed) return;

    if (_propertyListeners.containsKey(propertyName)) {
      _propertyListeners[propertyName]!.remove(listener);
    }
  }

  /// Notifies listeners for a specific property that the value has changed
  void notifyPropertyChange(String propertyName) {
    if (_disposed) return;

    if (_propertyListeners.containsKey(propertyName)) {
      for (final listener in List.from(_propertyListeners[propertyName]!)) {
        listener();
      }
    }
  }

  /// Notifies listeners for multiple properties
  void notifyPropertiesChanged(List<String> propertyNames) {
    if (_disposed) return;

    final notifiedListeners = <VoidCallback>{};

    for (final property in propertyNames) {
      if (_propertyListeners.containsKey(property)) {
        for (final listener in _propertyListeners[property]!) {
          notifiedListeners.add(listener);
        }
      }
    }

    for (final listener in notifiedListeners) {
      listener();
    }
  }

  @mustCallSuper
  @override
  void dispose() {
    _disposed = true;
    _context = null;
    _propertyListeners.clear();

    super.dispose();
  }
}
