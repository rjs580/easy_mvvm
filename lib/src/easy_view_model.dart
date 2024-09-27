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
  /// Busy status for the view model
  bool _busy = false;

  /// Get busy status of the view model. Useful for disabling buttons
  /// or showing loading indicators
  bool get busy => _busy;

  /// Set the busy status and notify the associated view
  set busy(bool value) {
    if (_busy != value) {
      _busy = value;
      notifyListeners();
    }
  }

  /// Called when the model is ready/initialized.
  void init(BuildContext? context) {}

  /// Update the view associated with this view model
  @nonVirtual
  @mustCallSuper
  void updateView() {
    notifyListeners();
  }
}
