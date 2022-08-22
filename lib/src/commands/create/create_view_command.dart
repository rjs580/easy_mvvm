import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:code_builder/code_builder.dart';
import 'package:colorize/colorize.dart';
import 'package:dart_style/dart_style.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';

@internal
class CreateViewCommand extends Command {
  CreateViewCommand({required this.packageName}) {
    argParser
      .addOption('path', abbr: 'p', valueHelp: 'path_name', help: 'Use if path name is not the same as the class name');
  }

  @override
  String get name => 'view';

  @override
  String get description => 'Creates the view and the view model';

  @override
  String get usage => super.usage.replaceFirst('view [arguments]', 'view <ClassName>');

  final String packageName;

  @override
  void run() {
    if (argResults?.rest.isNotEmpty ?? false) {
      final String className = argResults?.rest[0].trim() ?? '';
      final String classModelName = className.contains('View') ? '${className}Model': '${className}ViewModel';
      final String pathName = (argResults?.wasParsed('path') ?? false) ? (argResults?['path']) : (className.replaceAll('View', '').snakeCase);
      final String viewFileName = className.snakeCase;
      final String viewModelFileName = classModelName.snakeCase;

      const String routePath = 'lib/app/routes.dart';

      final File routeFile = File(routePath);
      if (routeFile.existsSync()) {
        final String viewFilePath = 'lib/ui/views/$viewFileName/$viewFileName.dart';
        final String viewModelFilePath = 'lib/ui/views/$viewFileName/$viewModelFileName.dart';
        final File viewFile = File(viewFilePath);
        final File viewModelFile = File(viewModelFilePath);

        if (viewFile.existsSync() || viewModelFile.existsSync()) {
          if (viewFile.existsSync()) {
            throw Exception('File with the name $viewFileName.dart already exists at path $viewFilePath');
          }

          if (viewModelFile.existsSync()) {
            throw Exception('File with the name $viewModelFileName.dart already exists at path $viewModelFilePath');
          }
        } else {
          final viewContentCode = Library((b) {
            b.name = className;
            b.directives.addAll([
              Directive.import('package:easy_mvvm/easy_mvvm.dart'),
              Directive.import('package:flutter/material.dart'),
              Directive.import('package:$packageName/ui/views/$viewFileName/$viewModelFileName.dart')
            ]);
            b.body.add(Class((c) {
              c.name = className;
              c.extend = refer('View<$classModelName>');
              c.constructors.addAll([
                Constructor((d) {
                  d.optionalParameters.addAll([
                    Parameter((e) {
                      e.name = 'key';
                      e.named = true;
                      e.type = refer('Key?');
                    }),
                  ]);
                  d.constant = true;
                  d.initializers.addAll([
                    const Code('super(key: key)'),
                  ]);
                }),
              ]);
              c.methods.addAll([
                Method((d) {
                  d.name = 'build';
                  d.annotations.addAll([
                    const CodeExpression(Code('override')),
                  ]);
                  d.returns = refer('Widget');
                  d.requiredParameters.addAll([
                    Parameter((e) {
                      e.name = 'context';
                      e.type = refer('BuildContext');
                    }),
                    Parameter((e) {
                      e.name = 'theme';
                      e.type = refer('ThemeData');
                    }),
                    Parameter((e) {
                      e.name = 'viewModel';
                      e.type = refer(classModelName);
                    }),
                    Parameter((e) {
                      e.name = 'child';
                      e.type = refer('Widget?');
                    }),
                  ]);
                  d.body = const Code('return const SizedBox.shrink();');
                }),
                Method((d) {
                  d.name = 'viewModelFactory';
                  d.annotations.addAll([
                    const CodeExpression(Code('override')),
                  ]);
                  d.lambda = true;
                  d.body = Code('$classModelName()');
                  d.returns = refer(classModelName);
                }),
              ]);
            }));
          });

          final DartEmitter emitter = DartEmitter.scoped(useNullSafetySyntax: true);
          String viewFileContents = DartFormatter(pageWidth: 999).format('${viewContentCode.accept(emitter)}');
          // remove first line with the library import
          viewFileContents = DartFormatter(pageWidth: 999).format(viewFileContents.substring(viewFileContents.indexOf('\n')+1));

          // create the view file
          viewFile.createSync(recursive: true);
          viewFile.writeAsStringSync(viewFileContents);

          final viewModelContentCode = Library((b) {
            b.name = classModelName;
            b.directives.addAll([
              Directive.import('package:easy_mvvm/easy_mvvm.dart'),
            ]);
            b.body.add(Class((c) {
              c.name = classModelName;
              c.extend = refer('ViewModel');
            }));
          });

          String viewModelFileContents = DartFormatter(pageWidth: 999).format('${viewModelContentCode.accept(emitter)}');
          // remove first line with the library import
          viewModelFileContents = DartFormatter(pageWidth: 999).format(viewModelFileContents.substring(viewModelFileContents.indexOf('\n')+1));

          // create the view model file
          viewModelFile.createSync(recursive: true);
          viewModelFile.writeAsStringSync(viewModelFileContents);

          // modify the routes.dart file
          final List<String> routesFileLines = routeFile.readAsLinesSync();
          routesFileLines.insert(0, 'import \'package:$packageName/ui/views/$viewFileName/$viewFileName.dart\';');

          final int classEndIndex = routesFileLines.lastIndexWhere((e) => e.contains(RegExp(r'^\}$')));
          if (classEndIndex != -1) {
            routesFileLines.insert(classEndIndex, 'router.defineRoute<$className>(instance: () => const $className(), path: \'$pathName\', className: \'$className\');');

            final String routesFileAsStringOut = routesFileLines.join('\n');
            final String routesFileContents = DartFormatter(pageWidth: 999).format(routesFileAsStringOut);
            routeFile.writeAsStringSync(routesFileContents, mode: FileMode.write);
          }
        }
      } else {
        final Colorize fileDoesNotExist = Colorize('lib/app/routes.dart file does not exist')
          ..red();
        stdout.writeln(fileDoesNotExist);
      }
    } else {
      stdout.writeln(argParser.usage);
    }
  }
}