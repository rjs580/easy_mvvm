import 'package:args/command_runner.dart';
import 'package:easy_mvvm/src/commands/create/create_service_command.dart';
import 'package:easy_mvvm/src/commands/create/create_view_command.dart';
import 'package:meta/meta.dart';

@internal
class CreateCommand extends Command {
  @override
  String get name => 'create';

  @override
  String get description => 'Quickly creates views, and services';

  String packageName;

  CreateCommand({required this.packageName}) {
    addSubcommand(CreateServiceCommand(packageName: packageName));
    addSubcommand(CreateViewCommand(packageName: packageName));
  }
}