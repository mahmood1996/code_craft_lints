import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:custom_lints/src/shared/edit_code_command.dart';

import '../shared/smart_statement.dart';

/// A quick fix that converts qualifying `if`/`else` statements into concise ternary expressions.
///
/// Converts matching assignment or return statements inside conditional branches
/// into single ternary expressions (`condition ? a : b`).
final class ConvertToTernaryFix extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    'dart.fix.custom_lints.convertToTernary',
    DartFixKindPriority.standard,
    'Convert to ternary operator',
  );

  /// Creates a new [ConvertToTernaryFix] with the given resolution [context].
  ConvertToTernaryFix({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final ifStatement = node.thisOrAncestorOfType<IfStatement>();

    if (ifStatement == null) return;

    final replacement = _availableReplacementFor(ifStatement);

    if (replacement == null) return;

    await EditCodeCommand.forReplacement(
      file: file,

      builder: builder,

      replacement: replacement,

      range: range.node(ifStatement),
    ).call();
  }

  /// Computes the replacement ternary source string for [statement] if it matches
  /// a supported return or assignment pattern; returns `null` otherwise.
  String? _availableReplacementFor(IfStatement statement) {
    final conditionSource = statement.expression.toSource();

    return switch ((
      statement.thenStatement.first,

      statement.elseStatement?.first,
    )) {
      (
        ReturnStatement(expression: final thenExp?),
        ReturnStatement(expression: final elseExp?),
      ) =>
        'return $conditionSource ? ${thenExp.toSource()} : ${elseExp.toSource()};',
      (
        ExpressionStatement(
          expression: AssignmentExpression(
            operator: final op1,
            leftHandSide: final lhs1,
            rightHandSide: final rhs1,
          ),
        ),
        ExpressionStatement(
          expression: AssignmentExpression(
            operator: final op2,
            leftHandSide: final lhs2,
            rightHandSide: final rhs2,
          ),
        ),
      )
          when lhs1.toSource() == lhs2.toSource() && op1.lexeme == op2.lexeme =>
        '${lhs1.toSource()} ${op1.lexeme} $conditionSource ? ${rhs1.toSource()} : ${rhs2.toSource()};',
      _ => null,
    };
  }
}
