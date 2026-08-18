/// Plugin registration entry point for custom analyzer lints and quick fixes.
library main;

import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/fixes/convert_to_ternary_fix.dart';
import 'src/fixes/make_class_final_fix.dart';
import 'src/fixes/make_class_interface_fix.dart';
import 'src/rules/final_implementation_class.dart';
import 'src/rules/one_level_of_indentation.dart';
import 'src/rules/one_statement_per_block.dart';
import 'src/rules/prefer_ternary.dart';
import 'src/rules/pure_contract_class.dart';

/// The global [CustomLintsPlugin] instance required by the Dart analysis server.
final plugin = CustomLintsPlugin();

/// The custom linter analyzer plugin that registers lint rules and quick fixes
/// with the Dart analysis server plugin registry.
final class CustomLintsPlugin extends Plugin {
  /// The unique name of this analyzer plugin.
  @override
  String get name => 'custom_lints';

  /// Registers all warning rules and quick fixes supported by this plugin.
  @override
  void register(PluginRegistry registry) {
    registry
      ..registerWarningRule(PreferTernaryLint())
      ..registerWarningRule(PureContractClassLint())
      ..registerWarningRule(OneLevelOfIndentationLint())
      ..registerWarningRule(OneStatementPerBlockLint())
      ..registerWarningRule(FinalImplementationClassLint())
      ..registerFixForRule(
        FinalImplementationClassLint.code,
        MakeClassFinalFix.new,
      )
      ..registerFixForRule(
        FinalImplementationClassLint.code,
        MakeClassBaseFix.new,
      )
      ..registerFixForRule(
        PureContractClassLint.code,
        MakeClassInterfaceFix.new,
      )
      ..registerFixForRule(PreferTernaryLint.code, ConvertToTernaryFix.new);
  }
}
