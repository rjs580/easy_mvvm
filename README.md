easy_mvvm is a Flutter package that simplifies state management by following the Model-View-ViewModel (MVVM) architectural pattern. The MVVM pattern separates the user interface (View) from the business logic and data (Model), using a ViewModel to mediate between the two. With easy_mvvm, you can easily create views and services using the command-line interface, which is powered by the get_it package. The package also supports the service locator pattern, which enables you to create singleton, lazy singleton, and factory services. The package includes command-line options and arguments that allow you to quickly create views and services and customize their behavior. If you're looking for a simple yet powerful way to manage state in your Flutter application, easy_mvvm is a great choice.

Uses the [get_it](https://pub.dev/packages/get_it) package for the service locator pattern.

## Getting Started

### Installation

1) Add to your `pubspec.yaml`:

```yaml
dependencies:
  easy_mvvm: <last_version>
```

2) Run the `init` command in terminal `flutter pub run easy_mvvm init`

### Web Recommendation

Use [url_strategy](https://pub.dev/packages/url_strategy) to remove the '#' in the URL

## Reactive UI Widgets

### PropertyBuilder

The `PropertyBuilder` widget allows you to rebuild only specific parts of your UI when a single property in your ViewModel changes. This optimizes performance by avoiding unnecessary rebuilds of the entire widget tree.
```dart
PropertyBuilder<MyViewModel>(
  viewModel: myViewModel,
  propertyName: 'counter',
  builder: (context) {
    return Text('Counter: ${myViewModel.counter}');
  },
)
```

### MultiPropertyBuilder
The `MultiPropertyBuilder` widget extends the functionality of `PropertyBuilder` by allowing you to listen to multiple properties at once. This is useful when a UI component depends on several ViewModel properties.
```dart
MultiPropertyBuilder<MyViewModel>(
  viewModel: myViewModel,
  propertyNames: ['firstName', 'lastName'],
  builder: (context) {
    return Text('Name: ${myViewModel.firstName} ${myViewModel.lastName}');
  },
)
```
Both widgets ensure proper lifecycle management and efficiently update only when needed.

### Property Notification
When a property changes in your ViewModel, you need to notify the UI to rebuild. The `EasyViewModel` provides two methods for this:
```dart
// Notify listeners about a single property change
myViewModel.notifyPropertyChange('counter');

// Notify listeners about multiple property changes
myViewModel.notifyPropertiesChanged(['firstName', 'lastName']);
```
These methods will trigger rebuilds in any `PropertyBuilder` or `MultiPropertyBuilder` widgets that are listening to the specified properties, ensuring your UI stays in sync with your data model.

## Terminal Commands

### Command line options and arguments

| Options | Short | Description                                                                   | Usage                                        |
|---------|-------|-------------------------------------------------------------------------------|----------------------------------------------|
| create  |       | Quickly creates views, and services                                           | `flutter pub run easy_mvvm create <options>`             |
| init    |       | Initialize an mvvm project (creates the folder structure and necessary files) | `flutter pub run easy_mvvm init` |
| --help  | -h    | Print Usage Information                                                       | `flutter pub run easy_mvvm -h`     |

### Command line options and arguments for `create`
| Options | Short | Description                         | Usage                                                |
|---------|-------|-------------------------------------|------------------------------------------------------|
| service |       | Creates a service                   | `flutter pub run easy_mvvm create service <options>` |
| view    |       | Creates the view and the view model | `flutter pub run easy_mvvm create view <ClassName>`  |
| --help  | -h    | Print Usage Information             | `flutter pub run easy_mvvm <options> -h`             |

### Command line arguments for `create service`
| Arguments                   | Short | Description                                         | Usage                                                                     |
|-----------------------------|-------|-----------------------------------------------------|---------------------------------------------------------------------------|
| --singleton=<ClassName>     |       | Creates a singleton service                         | `flutter pub run easy_mvvm create service --singleton=ExampleView`        |
| --lazySingleton=<ClassName> |       | Creates a lazy singleton service (Recommended)      | `flutter pub run easy_mvvm create service --lazySingleton=ExampleView`    |
| --factory=<ClassName>       |       | Creates a factory for a service                     | `flutter pub run easy_mvvm create service --factory=ExampleView`          |
| --async                     | -a    | The service needs async function to be instantiated | `flutter pub run easy_mvvm create service --lazySingleton=ExampleView -a` |
| --help                      | -h    | Print Usage Information                             | `flutter pub run easy_mvvm <options> -h`                                  |

### Command line arguments for `create view <ClassName>`

| Arguments                   | Short | Description                                                        | Usage                                                               |
|-----------------------------|-------|--------------------------------------------------------------------|---------------------------------------------------------------------|
| --path=<path_name>          | -p    | Use if path name (route) for web is not the same as the class name | `flutter pub run easy_mvvm create view <ClassName> --path=routePath` |
| --help                      | -h    | Print Usage Information                                            | `flutter pub run easy_mvvm <options> -h`                            |
