## 0.1.0

* Raised minimum Dart SDK requirement from 2.16.1 to 2.17.0
* Enhanced `EasyViewModel` with proper lifecycle management:
    * Added `context` tracking with safe access patterns
    * Added `mounted` property to check if view model is still active
    * Implemented proper disposal mechanism to prevent memory leaks
    * Updated `init()` method to require a BuildContext and marked with `@mustCallSuper`
    * Added safety checks to prevent actions after disposal
* Added granular property-based reactivity system:
    * Implemented property-specific listeners with `addPropertyListener` and `removePropertyListener`
    * Added `notifyPropertyChange` and `notifyPropertiesChanged` for targeted UI updates
    * Added `PropertyBuilder` widget for single property reactive UI
    * Added `MultiPropertyBuilder` widget for multi-property reactive UI
* Improved `BaseView` initialization flow:
    * Added initialization tracking to prevent duplicate init calls
    * Moved ViewModel initialization to `didChangeDependencies` for safer context access
* Updated widget constructors to use the `super.key` syntax
* Fixed code formatting in `CustomPageRouteBuilder`
* Added lint rule suppressions for deprecated member usage
* Updated example app to use modern text styles
* Updated Flutter dependencies in the example app

## 0.0.9

* Updated dependencies
* Added `removePopScope` as part of `EasyView` so `PopScope` is removed from the `Widget` tree and enables the ability to add a custom one for more control

## 0.0.8

* Deprecated `ViewModel`, use `EasyViewModel` instead.
* Deprecated `View`, use `EasyView` instead.
* Updated create view command with `EasyView` and `EasyViewModel`
* Updated create view command with `super.key` instead of the named `Key?` parameter in the constructor
* Added command to check the version of `easy_mvvm` installed
* Removed `onWillPop` from `EasyView` in favor of `canPop` and `onPopInvoked`
* Updated dependencies

## 0.0.7

* Fixed compatibility with the [url_strategy](https://pub.dev/packages/url_strategy) package
* Updated creating a view model with `as mvvm` to make sure the class `View` within this package doesn't collide with the flutter class
* Updated dependencies

## 0.0.6

* Change the page width for dart formatter when creating new views

## 0.0.5

* Updated creating a view with `as mvvm` to make sure the class `View` doesn't collide with the flutter class

## 0.0.4

* App default transition for iOS devices

## 0.0.3-1

* Updated README

## 0.0.3

* Added transition background
* Updated README

## 0.0.2

* Commands to create services, views, and init mvvm project

## 0.0.1+1

* Replaced View.buildView to View.build for readability of code

## 0.0.1

* Initial release