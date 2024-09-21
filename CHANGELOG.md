## 0.0.11

* Deprecated `PopInvokedContextCallback` and `onPopInvoked`, use `PopInvokedContextWithResultCallback` and `onPopInvokedWithResult` instead.

## 0.0.10

* Updated dependencies
* Reformatted the README to improve readability and structure.

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