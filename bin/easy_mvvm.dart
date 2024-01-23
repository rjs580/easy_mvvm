// ignore_for_file: avoid_print

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:easy_mvvm/src/commands/create/create_command.dart';
import 'package:easy_mvvm/src/commands/init_command.dart';
import 'package:easy_mvvm/src/commands/version_command.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';

PubspecYaml getPubspecInfo() {
  final Directory directory = Directory.current;
  final String pubspecFilePath = '${directory.path}/pubspec.yaml';
  final File pubspecFile = File(pubspecFilePath);

  if (pubspecFile.existsSync()) {
    return pubspecFile.readAsStringSync().toPubspecYaml();
  } else {
    throw FileSystemException('Pubspec file not found', pubspecFilePath);
  }
}

extension on PackageDependencySpec {
  String? version() => iswitch(
        sdk: (p) => p.version.unsafe,
        git: (p) => null,
        path: (p) => null,
        hosted: (p) => p.version.unsafe,
      );
}

T? firstOrNull<T>(List<T> t) {
  var iterator = t.iterator;
  if (iterator.moveNext()) return iterator.current;
  return null;
}

void main(List<String> arguments) async {
  CommandRunner? runner;
  try {
    final PubspecYaml pubspecYaml = getPubspecInfo();

    final List<PackageDependencySpec> allDependencies = [
      ...pubspecYaml.dependencies,
      ...pubspecYaml.dependencyOverrides,
      ...pubspecYaml.devDependencies,
    ];

    final List<PackageDependencySpec> easyMvvms = allDependencies
        .where((dependency) =>
            dependency.version() != null && dependency.package() == 'easy_mvvm')
        .toList(growable: false);

    easyMvvms.sort((a, b) {
      return (a.version() ?? '').compareTo(b.version() ?? '');
    });

    runner = CommandRunner(
        'easy_mvvm', 'Create mvvm project, services, and views with ease')
      ..addCommand(InitCommand(packageName: pubspecYaml.name))
      ..addCommand(CreateCommand(packageName: pubspecYaml.name))
      ..addCommand(
          VersionCommand(easyMvvmVersion: firstOrNull(easyMvvms)?.version()))
      ..run(arguments).catchError((error) {
        if (error is UsageException && runner != null) {
          print(runner.commands[arguments.first]?.usage);
          exit(0);
        }

        print(error);
        exit(2);
      });
  } catch (error) {
    if (error is UsageException && runner != null) {
      print(runner.usage);
      exit(0);
    }

    print(error);
    exit(2);
  }
}
