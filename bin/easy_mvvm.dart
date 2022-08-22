// ignore_for_file: avoid_print

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:easy_mvvm/src/commands/create/create_command.dart';
import 'package:easy_mvvm/src/commands/init_command.dart';
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

void main(List<String> arguments) {
  CommandRunner? runner;
  try {
    PubspecYaml pubspecYaml = getPubspecInfo();
    runner = CommandRunner('easy_mvvm', 'Create mvvm project, services, and views with ease')
      ..addCommand(InitCommand(packageName: pubspecYaml.name))
      ..addCommand(CreateCommand(packageName: pubspecYaml.name))
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

  // final ArgParser serviceParser = ArgParser()
  //   ..addOption('singleton', abbr: 's', help: 'Creates a singleton service')
  //   ..addOption('lazy-singleton', abbr: 'l', help: 'Creates a lazy singleton service (Recommended')
  //   ..addOption('factory', abbr: 'f', help: 'Creates a factory for a service')
  //   ..addFlag('async', abbr: 'a', negatable: false);
  //
  // final ArgParser mainParser = ArgParser()
  //   ..addCommand('init')
  //   ..addCommand('service', serviceParser)
  //   ..addCommand('view')
  //   ..addFlag('help', abbr: 'h', help: 'Output command usage', negatable: false);
  //
  // final ArgResults results = mainParser.parse(arguments);
  //
  // if (results.wasParsed('help') || results.arguments.isEmpty) {
  //   print(mainParser.usage);
  //   exit(0);
  // }

  // final ArgParser parser = ArgParser()
  //   ..addOption('init', abbr: 'i', help: 'Creates the mvvm folder structure')
  //   ..addOption('service', abbr: 's',
  //       allowed: ['singleton', 'lazy-singleton', 'factory', ],
  //       allowedHelp: {
  //         'singleton': 'Creates a singleton service',
  //         'lazy-singleton': 'Creates a lazy singleton service (Recommended)',
  //         'factory': 'Creates a factory for a service',
  //       },
  //       defaultsTo: 'lazy-singleton', help: 'Creates a service')
  //   ..addOption('view', abbr: 'v', help: 'Creates a view with its view model')
  //   ..addFlag('help', abbr: 'h', help: 'Output command usage', negatable: false);
  //
  // final ArgResults results = parser.parse(arguments);
  //
  // if (results.wasParsed('help') || results.arguments.isEmpty) {
  //   print(parser.usage);
  //   exit(0);
  // }
  //
  // try {
  //   if (results.wasParsed('init')) {
  //
  //   } else if (results.wasParsed('service')) {
  //     print(results.arguments);
  //   } else if (results.wasParsed('view')) {
  //
  //   } else {
  //     print(parser.usage);
  //     exit(0);
  //   }
  // } catch(error) {
  //   print(error);
  // }
}