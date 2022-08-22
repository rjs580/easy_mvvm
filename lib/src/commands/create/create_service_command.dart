import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:code_builder/code_builder.dart';
import 'package:colorize/colorize.dart';
import 'package:dart_style/dart_style.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';

@internal
class CreateServiceCommand extends Command {
  CreateServiceCommand({required this.packageName}) {
    argParser
      ..addOption('singleton', valueHelp: 'ClassName', help: 'Creates a singleton service')
      ..addOption('lazySingleton', valueHelp: 'ClassName', help: 'Creates a lazy singleton service (Recommended)')
      ..addOption('factory', valueHelp: 'ClassName', help: 'Creates a factory for a service')
      ..addFlag('async', abbr: 'a', help: 'The service needs async function to be instantiated', negatable: false);
  }

  @override
  String get name => 'service';

  @override
  String get description => 'Creates a service';

  final String packageName;

  @override
  void run() {
    if (argResults?.wasParsed('singleton') ?? false) {
      final String className = (argResults?['singleton'] as String?)?.trim() ?? '';
      final bool isAsync = argResults?.wasParsed('async') ?? false;

      createService(className, isAsync);
    } else if (argResults?.wasParsed('lazySingleton') ?? false) {
      final String className = (argResults?['lazySingleton'] as String?)?.trim() ?? '';
      final bool isAsync = argResults?.wasParsed('async') ?? false;

      createService(className, isAsync, isLazy: true);
    } else if (argResults?.wasParsed('factory') ?? false) {
      final String className = (argResults?['factory'] as String?)?.trim() ?? '';
      final bool isAsync = argResults?.wasParsed('async') ?? false;

      createService(className, isAsync, isFactory: true);
    } else {
      stdout.writeln(argParser.usage);
    }
  }

  void createService(String className, bool isAsync, {bool isLazy = false, bool isFactory = false}) {
    const String locatorPath = 'lib/app/locator.dart';
    final String fileName = className.snakeCase;

    final File locatorFile = File(locatorPath);
    if (locatorFile.existsSync()) {
      final String serviceFilePath = 'lib/services/$fileName.dart';
      final File serviceFile = File(serviceFilePath);
      if (serviceFile.existsSync()) {
        throw Exception('File with the name $fileName.dart already exists at path $serviceFilePath');
      } else {
        final serviceContentCode = Class((b) {
          b.name = className;
          if (isAsync) {
            b.methods.add(
              Method((a) {
                a.name = 'init';
                a.static = true;
                a.modifier = MethodModifier.async;
                a.body = Code('return $className();');
                a.returns = refer('Future<$className>');
              })
            );
          }
        });

        final DartEmitter emitter = DartEmitter.scoped(useNullSafetySyntax: true);
        final String serviceFileContents = DartFormatter().format('${serviceContentCode.accept(emitter)}');

        // create the service file
        serviceFile.createSync(recursive: true);
        serviceFile.writeAsStringSync(serviceFileContents);

        // modify the locator.dart file
        final List<String> locatorFileLines = locatorFile.readAsLinesSync();
        locatorFileLines.insert(0, 'import \'package:$packageName/services/$fileName.dart\';');

        final int classEndIndex = locatorFileLines.lastIndexWhere((e) => e.contains(RegExp(r'^\}$')));
        if (classEndIndex != -1) {
          if (isAsync) {
            if (isLazy) {
              locatorFileLines.insert(classEndIndex, 'locator.registerLazySingletonAsync<$className>(() => $className.init());');
            } else if (isFactory) {
              locatorFileLines.insert(classEndIndex, 'locator.registerFactoryAsync<$className>(() => $className.init());');
            } else {
              locatorFileLines.insert(classEndIndex, 'locator.registerSingletonAsync<$className>(() => $className.init());');
            }
          } else {
            if (isLazy) {
              locatorFileLines.insert(classEndIndex, 'locator.registerLazySingleton<$className>(() => $className());');
            } else if (isFactory) {
              locatorFileLines.insert(classEndIndex, 'locator.registerFactory<$className>(() => $className());');
            } else {
              locatorFileLines.insert(classEndIndex, 'locator.registerSingleton<$className>($className());');
            }
          }

          final String locatorFileAsStringOut = locatorFileLines.join('\n');
          final String locatorFileContents = DartFormatter().format(locatorFileAsStringOut);
          locatorFile.writeAsStringSync(locatorFileContents, mode: FileMode.write);
        }
      }
    } else {
      final Colorize fileDoesNotExist = Colorize('lib/app/locator.dart file does not exist')
        ..red();
      stdout.writeln(fileDoesNotExist);
    }
  }
}