import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

@internal
class VersionCommand extends Command {
  VersionCommand({required this.easyMvvmVersion});

  final String? easyMvvmVersion;

  @override
  String get name => 'version';

  @override
  List<String> get aliases => ['v'];

  @override
  String get description => 'Print the version';

  @override
  void run() {
    if (easyMvvmVersion?.isNotEmpty == true) {
      // ignore: avoid_print
      print('easy_mvvm $easyMvvmVersion');
    }
  }
}
