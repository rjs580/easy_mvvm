import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:colorize/colorize.dart';
import 'package:meta/meta.dart';

@internal
class InitCommand extends Command {
  InitCommand({required this.packageName});

  final String packageName;

  @override
  String get name => 'init';

  @override
  String get description => 'Initialize an mvvm project (creates the folder structure and necessary files)';

  @override
  void run() {
    createLocatorFile();
    createRoutesFile();
    modifyMainFile();
  }

  void modifyMainFile() {
    const String mainFilePath = 'lib/main.dart';

    final Colorize modifyingMainFile = Colorize('** Updating main.dart file')
      ..bold();
    stdout.writeln(modifyingMainFile);

    final File mainFile = File(mainFilePath);
    if (mainFile.existsSync()) {
      final List<String> mainFileContents = mainFile.readAsLinesSync();

      final int importMaterialIndex = mainFileContents.indexWhere((ln) => ln.contains('import \'package:flutter/material.dart\';'));
      final int easyMvvmIndex = mainFileContents.indexWhere((ln) => ln.contains('import \'package:easy_mvvm/easy_mvvm.dart\';'));
      if (importMaterialIndex != -1 && easyMvvmIndex == -1) {
        String mainImportsAdd =
            'import \'package:easy_mvvm/easy_mvvm.dart\';\n'
            'import \'package:$packageName/app/locator.dart\';\n'
            'import \'package:$packageName/app/routes.dart\';';
        mainFileContents.insert(importMaterialIndex, mainImportsAdd);
      } else {
        if (easyMvvmIndex != -1) {
        } else {
          throw Exception('import of material library was not found in main.dart');
        }
      }

      final int mainFuncIndex = mainFileContents.indexWhere((ln) => ln.contains('void main'));
      final int setupLocatorIndex = mainFileContents.indexWhere((ln) => ln.contains('setupLocator'));
      if (mainFuncIndex != -1 && setupLocatorIndex == -1) {
        const String mainCodeAdd =
            ' // Setup the locator\n'
            'setupLocator();\n\n'
            ' // Setup the routes\n'
            'setupRoutes();\n\n';
        mainFileContents.insert(mainFuncIndex + 1, mainCodeAdd);
      } else {
        if (setupLocatorIndex != -1) {
        } else {
          throw Exception('main void function was not found in main.dart');
        }
      }

      final int homeIndex = mainFileContents.indexWhere((ln) => ln.contains('home:'));
      if (homeIndex != -1) {
        mainFileContents[homeIndex] = '     // add the initial route (it can also be the `RouteService().homeView`)\n'
            'initialRoute: RouteService.path<HomeView>(),\n'
            '     // this allows the [RouteService] to generate the necessary routes\n'
            'onGenerateRoute: RouteService().onGenerateRoute,';
      } else {
        final int initialRouteIndex = mainFileContents.indexWhere((ln) => ln.contains('initialRoute:'));
        final int initialRouteInitIndex = mainFileContents.indexWhere((ln) => ln.contains('initialRoute: RouteService.path'));
        if (initialRouteIndex != -1 && initialRouteInitIndex == -1) {
          mainFileContents[initialRouteIndex] = '     // add the initial route (it can also be the `RouteService().homeView`)\n'
              'initialRoute: RouteService.path<HomeView>(),';
        }

        final int onGenerateRouteIndex = mainFileContents.indexWhere((ln) => ln.contains('onGenerateRoute:'));
        final int onGenerateRouteInitIndex = mainFileContents.indexWhere((ln) => ln.contains('onGenerateRoute: RouteService().onGenerateRoute'));
        if (onGenerateRouteIndex != -1 && onGenerateRouteInitIndex == -1) {
          mainFileContents[onGenerateRouteIndex] = '      // this allows the [RouteService] to generate the necessary routes\n'
              'onGenerateRoute: RouteService().onGenerateRoute,';
        }
      }

      final String mainFileAsString = mainFileContents.join('\n');
      final String formattedCode = DartFormatter().format(mainFileAsString);
      mainFile.writeAsStringSync(formattedCode, mode: FileMode.writeOnly);
    } else {
      final Colorize fileAlreadyExists = Colorize('- main.dart file does not exist')
        ..red();
      stdout.writeln(fileAlreadyExists);
    }

    final Colorize fileCreated = Colorize('- done updating main.dart file')
      ..green();
    stdout.writeln(fileCreated);
  }

  void createRoutesFile() {
    const String routesPath = 'lib/app/routes.dart';

    final Colorize creatingRouteString = Colorize('** Creating routes.dart file')
      ..bold();
    stdout.writeln(creatingRouteString);

    final File routesFile = File(routesPath);
    if (routesFile.existsSync()) {
      final Colorize fileAlreadyExists = Colorize('- routes.dart file already exists')
        ..red();
      stdout.writeln(fileAlreadyExists);
    } else {
      final routesFileContentsCode = Library((b) => b
        ..directives.addAll([
          Directive.import('package:easy_mvvm/easy_mvvm.dart', show: const ['RouteService']),
        ])
        ..body.addAll([
          Method.returnsVoid((a) => a
            ..docs.addAll([
              '/// Setup all the routes in here'
            ])
            ..body = const Code(
                'final RouteService router = RouteService();\n'
                    ' // define the homeView if this project as web\n'
                    ' // router.homeView = const SplashView();\n'
                    ' // set isAuthenticated so protectedRoutes aren\'t accessible to everyone\n'
                    ' // router.isAuthenticated = () { return locator<UserService>().isUserSignedIn; };\n'
                    ' // this is how you define a regular route\n'
                    ' // router.defineRoute<SplashView>(instance: () => const SplashView(), path: \'splash\', className: \'SplashView\');\n'
            )
            ..name = 'setupRoutes'
          ),
        ])
      );
      final DartEmitter emitter = DartEmitter.scoped(useNullSafetySyntax: true);
      final String routesFileContents = DartFormatter().format('${routesFileContentsCode.accept(emitter)}');

      routesFile.createSync(recursive: true);
      routesFile.writeAsStringSync(routesFileContents);

      final Colorize fileCreated = Colorize('- routes.dart file created')
        ..green();
      stdout.writeln(fileCreated);
    }
  }

  void createLocatorFile() {
    const String locatorPath = 'lib/app/locator.dart';

    final Colorize creatingLocatorString = Colorize('** Creating locator.dart file')
      ..bold();
    stdout.writeln(creatingLocatorString);

    final File locatorFile = File(locatorPath);
    if (locatorFile.existsSync()) {
      final Colorize fileAlreadyExists = Colorize('- locator.dart file already exists')
        ..red();
      stdout.writeln(fileAlreadyExists);
    } else {
      final locatorFileContentsCode = Library((b) => b
        ..directives.addAll([
          Directive.import('package:easy_mvvm/easy_mvvm.dart', show: const ['locator']),
        ])
        ..body.addAll([
          Method.returnsVoid((a) => a
            ..docs.addAll([
              '/// Register any services here'
            ])
            ..body = const Code('// locator.registerLazySingleton<DBService>(() => DBService()); \n')
            ..name = 'setupLocator'
          ),
        ])
      );
      final DartEmitter emitter = DartEmitter.scoped(useNullSafetySyntax: true);
      final String locatorFileContents = DartFormatter().format('${locatorFileContentsCode.accept(emitter)}');

      locatorFile.createSync(recursive: true);
      locatorFile.writeAsStringSync(locatorFileContents);

      final Colorize fileCreated = Colorize('- locator.dart file created')
        ..green();
      stdout.writeln(fileCreated);
    }
  }
}