import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../shared/smart_statement.dart';

/// A lint rule suggesting ternary operators over simple `if`/`else` returns and assignments.
///
/// Conditional expressions (`condition ? a : b`) provide clear, concise alternatives
/// to multi-line `if`/`else` structures when performing simple variable assignment or returns.
///
/// ### Example
///
/// **BAD:**
/// ```dart
/// if (isActive) {
///   status = 'active';
/// } else {
///   status = 'inactive';
/// }
/// ```
///
/// **GOOD:**
/// ```dart
/// status = isActive ? 'active' : 'inactive';
/// ```
final class PreferTernaryLint extends AnalysisRule {
  /// Creates a new [PreferTernaryLint] instance.
  PreferTernaryLint()
    : super(
        name: 'prefer_ternary',
        description:
            'Prefer using the ternary operator over if/else for simple conditional assignments/returns.',
      );

  /// The lint diagnostic code for [PreferTernaryLint].
  static const code = LintCode(
    'prefer_ternary',
    'Prefer using the ternary operator over if/else for simple conditional assignments/returns.',
    correctionMessage: 'Convert to ternary operator.',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) => registry.addIfStatement(this, _Visitor(this));
}

/// AST visitor that inspects `if`/`else` statements for single return or assignment statements
/// that can be converted into a ternary expression.
final class _Visitor extends SimpleAstVisitor<void> {
  /// The lint rule instance reporting diagnostics.
  final AnalysisRule rule;

  /// Creates a new [_Visitor] associated with [rule].
  _Visitor(this.rule);

  @override
  void visitIfStatement(IfStatement node) =>
      switch ((node.thenStatement.first, node.elseStatement?.first)) {
        (Statement thenStmt, Statement elseStmt) => () {
          _checkForReturnStatements(thenStmt, elseStmt, node);
          _checkForAssignmentStatements(thenStmt, elseStmt, node);
        },
        (_, null || IfStatement _) => () {},
        _ => () {},
      }.call();

  /// Inspects statements for assignments targeting the same variable and reports a lint warning if matched.
  void _checkForAssignmentStatements(
    Statement thenStmt,
    Statement elseStmt,
    IfStatement node,
  ) => switch ((thenStmt, elseStmt)) {
    (
      ExpressionStatement(expression: final AssignmentExpression thenExp),
      ExpressionStatement(expression: final AssignmentExpression elseExp),
    )
        when (thenExp.leftHandSide.toSource() ==
            elseExp.leftHandSide.toSource()) =>
      rule.reportAtNode(node),

    _ => null,
  };

  /// Inspects statements for matching return statements and reports a lint warning if matched.
  void _checkForReturnStatements(
    Statement thenStmt,
    Statement elseStmt,
    IfStatement node,
  ) => switch ((thenStmt, elseStmt)) {
    (
      ReturnStatement(expression: final Expression _),
      ReturnStatement(expression: final Expression _),
    ) =>
      rule.reportAtNode(node),
    _ => null,
  };
}
