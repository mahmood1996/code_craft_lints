/// A powerful Dart analyzer plugin enforcing clean architecture, indentation limits,
/// and strict class modifiers with automated quick fixes.
///
/// This library exports all custom lint rules, automated quick fixes, and the plugin
/// entry point for static analysis configuration.
library code_craft_lints;

export 'main.dart';
export 'src/fixes/convert_to_ternary_fix.dart';
export 'src/fixes/make_class_final_fix.dart';
export 'src/fixes/make_class_interface_fix.dart';
export 'src/rules/final_implementation_class.dart';
export 'src/rules/one_level_of_indentation.dart';
export 'src/rules/one_statement_per_block.dart';
export 'src/rules/prefer_ternary.dart';
export 'src/rules/pure_contract_class.dart';
