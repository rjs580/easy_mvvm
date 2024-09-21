# easy_mvvm

This is a Flutter package that simplifies state management by following the Model-View-ViewModel (MVVM) architectural pattern. The MVVM pattern separates the user interface (View) from the business logic and data (Model), using a ViewModel to mediate between the two. With easy_mvvm, you can easily manage routes, views, and viewmodels within your Flutter application.

## Features

- Simplifies state management in Flutter applications. 
- Enables quick [scaffolding](#quick-scaffolding) of [views and services](#views-and-services) using [command-line options](#command-line-options). 
- [Manages routes](#route-management) with custom page route builders and defined routes. 
- Supports the service locator pattern for easy dependency injection using the [get_it](https://pub.dev/packages/get_it) package.

## Detailed Features

### Quick Scaffolding

The easy_mvvm package allows you to quickly generate the basic structure of views and services using command-line tools. This saves significant development time and ensures consistency by following standardized patterns.

### Views and Services

- **Views**: Components responsible for displaying the UI.
- **Services**: Components that handle business logic, data retrieval, and other functionalities outside the UI layer.

### Command-Line Options

Developers can use specific commands in their terminal (command-line interface) to generate views and services efficiently. For example:

- To create a view named `ExampleView`:
    ```sh
    flutter pub run easy_mvvm create view ExampleView
    ```

- To create a lazy singleton service named `ExampleService`:
    ```sh
    flutter pub run easy_mvvm create service --lazySingleton=ExampleService 
    ```

### Route Management

Managing navigation is seamless with easy_mvvm, which provides custom page route builders and predefined routes. This feature ensures that navigation logic is clear and maintainable.

- **Custom Page Route Builders**: You can define custom page transitions using the `RouteTransition` class.
- **Defined Routes**: Predefined routes (`DefinedRoutes`) help standardize and simplify the management of different routes in your application.
- **Route Services**: The `RouteService` class handles routing, ensuring that navigation logic is consolidated in one place.
- **Error Handling**: Use the `RouteErrorTemplate` to define custom templates for displaying errors related to routing.

Example:
```dart
// Example of using RouteService for navigation
RouteService.navigateTo(context, RouteInfo.home);
```

## Getting Started

### Installation

1. Add easy_mvvm to your `pubspec.yaml`:
    ```dart
    dependencies:
      easy_mvvm: <latest_version>
    ```

2. Initialize your MVVM project:
    ```dart
    flutter pub run easy_mvvm init
    ```
### Web Recommendation

For Flutter web applications, it's recommended to use the [url_strategy](https://pub.dev/packages/url_strategy) package to remove the `#` from the URL.

## Usage

### Importing easy_mvvm

To use easy_mvvm in your Flutter project, import it as follows:
```dart
import 'package:easy_mvvm/easy_mvvm.dart';
```

## Command-Line Interface

### General Options

| Option  | Short | Description                                                                               | Usage                                             |
|---------|-------|-------------------------------------------------------------------------------------------|---------------------------------------------------|
| create  |       | Quickly creates views, and services                                                       | `flutter pub run easy_mvvm create <options>`      |
| init    |       | Initializes an MVVM project (creates the folder structure and necessary files)             | `flutter pub run easy_mvvm init`                  |
| --help  | -h    | Prints usage information                                                                   | `flutter pub run easy_mvvm -h`                    |

### Create Command Options

| Option  | Short | Description                  | Usage                                                |
|---------|-------|------------------------------|------------------------------------------------------|
| service |       | Creates a service            | `flutter pub run easy_mvvm create service <options>` |
| view    |       | Creates a view and view model| `flutter pub run easy_mvvm create view <ClassName>`  |
| --help  | -h    | Prints usage information      | `flutter pub run easy_mvvm create <options> -h`      |

### Service Creation Options

| Argument                   | Short | Description                                         | Usage                                                                     |
|----------------------------|-------|-----------------------------------------------------|---------------------------------------------------------------------------|
| --singleton=<ClassName>    |       | Creates a singleton service                         | `flutter pub run easy_mvvm create service --singleton=<ClassName>`        |
| --lazySingleton=<ClassName>|       | Creates a lazy singleton service (Recommended)      | `flutter pub run easy_mvvm create service --lazySingleton=<ClassName>`    |
| --factory=<ClassName>      |       | Creates a factory for a service                     | `flutter pub run easy_mvvm create service --factory=<ClassName>`          |
| --async                    | -a    | The service needs async function to be instantiated | `flutter pub run easy_mvvm create service --lazySingleton=<ClassName> -a` |
| --help                     | -h    | Prints usage information                             | `flutter pub run easy_mvvm create service <options> -h`                   |

### View Creation Options

| Argument                   | Short | Description                                                        | Usage                                                                  |
|----------------------------|-------|--------------------------------------------------------------------|------------------------------------------------------------------------|
| --path=<path_name>         | -p    | Use if path name (route) for web is not the same as the class name | `flutter pub run easy_mvvm create view <ClassName> --path=routePath`   |
| --help                     | -h    | Prints usage information                                           | `flutter pub run easy_mvvm create view <ClassName> -h`                 |

## API Documentation

### Router

- **RouteTransition**: Class for custom page route transitions.
- **RouteInfo**: Class containing route information.
- **RouteErrorTemplate**: Class for defining route error templates.
- **RouteService**: Class for managing routing.
- **CustomPageRouteBuilder**: (Internal) Custom page route builder.
- **DefinedRoutes**: (Internal) Predefined routes.

### MVVM

- **ViewModel**: Base class for view models.
- **View**: Base class for views.
- **locator**: The service locator for dependency injection.

## Contributing

If you'd like to contribute, please submit a pull request or open an issue.