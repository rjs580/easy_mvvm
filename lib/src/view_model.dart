import 'package:easy_mvvm/src/view.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// ViewModel is the middleman for your model and the [View]. Any
/// inputs from your [View] will be forwarded to the [ViewModel] and
/// then it will update or change the model. Other way is when the model
/// updates, the state of the [ViewModel] changes and the [View] will
/// automatically be asked to update.
class ViewModel extends ChangeNotifier {
  /// Busy status for the view model
  bool _busy = false;

  /// Get busy status of the view model. Useful for disabling buttons
  /// or showing loading indicators
  bool get busy => _busy;

  /// Set the busy status and notify the associated view
  set busy(bool value) {
    _busy = value;
    notifyListeners();
  }

  /// Called when the model is ready/initialized.
  void init(BuildContext? context) {
  }

  /// Update the view associated with this view model
  @nonVirtual
  @mustCallSuper
  void updateView() {
    notifyListeners();
  }
}