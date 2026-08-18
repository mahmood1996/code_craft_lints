import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// A lint rule enforcing a maximum of 1 level of control flow indentation per function/method body.
///
/// Deeply nested control flow structures (e.g. nested `if`, `for`, `while`, `switch`, or `try`)
/// increase cyclomatic complexity, impair readability, and make code harder to maintain and test.
///
/// ### Example
///
/// **BAD:**
/// ```dart
/// void process(List<int> items) {
///   if (items.isNotEmpty) {
///     for (final item in items) { // LINT: indentation level >= 2
///       print(item);
///     }
///   }
/// }
/// ```
///
/// **GOOD:**
/// ```dart
/// void process(List<int> items) {
///   if (items.isEmpty) return;
///   _printItems(items);
/// }
/// ```
final class OneLevelOfIndentationLint extends AnalysisRule {
  /// Creates a new [OneLevelOfIndentationLint] instance.
  OneLevelOfIndentationLint()
    : super(
        name: 'one_level_of_indentation',
        description:
            'Only 1 level of indentation is supported. Extract this logic into a new function.',
      );

  /// The lint diagnostic code for [OneLevelOfIndentationLint].
  static const code = LintCode(
    'one_level_of_indentation',
    'Only 1 level of indentation is supported.',
    correctionMessage: 'Extract this logic into a new function.',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);

    registry
      ..addDoStatement(this, visitor)
      ..addIfStatement(this, visitor)
      ..addForStatement(this, visitor)
      ..addWhileStatement(this, visitor)
      ..addSwitchStatement(this, visitor)
      ..addTryStatement(this, visitor);
  }
}

/// AST visitor that computes indentation depth for control flow statements
/// and reports violations when nesting exceeds the allowed threshold.
final class _Visitor extends SimpleAstVisitor<void> {
  /// The lint rule instance reporting diagnostics.
  final AnalysisRule rule;

  /// Creates a new [_Visitor] associated with [rule].
  _Visitor(this.rule);

  /// Checks if [node] exceeds [maxIndentationLvl] and reports a lint warning if so.
  void _checkForIndentation(AstNode node, {int maxIndentationLvl = 1}) {
    if (_indentationLevel(node) >= maxIndentationLvl) {
      rule.reportAtNode(node);
    }
  }

  /// Calculates the control flow indentation level of [node] relative to its enclosing function body.
  int _indentationLevel(AstNode node) =>
      __indentationLevelFrom(node, node.parent);

  /// Recursively walks up the AST from [current] to count control flow indentation boundaries.
  int __indentationLevelFrom(AstNode previous, AstNode? current) {
    return switch (current) {
      null || FunctionBody _ => 0,
      DoStatement _ ||
      ForStatement _ ||
      TryStatement _ ||
      WhileStatement _ ||
      SwitchStatement _ => 1 + __indentationLevelFrom(current, current.parent),
      IfStatement _
          when (current.elseStatement != previous ||
              previous is! IfStatement) =>
        1 + __indentationLevelFrom(current, current.parent),
      _ => __indentationLevelFrom(current, current.parent),
    };
  }

  @override
  void visitDoStatement(DoStatement node) {
    _checkForIndentation(node);
  }

  @override
  void visitIfStatement(IfStatement node) {
    _checkForIndentation(node);
  }

  @override
  void visitForStatement(ForStatement node) {
    _checkForIndentation(node);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    _checkForIndentation(node);
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    _checkForIndentation(node);
  }

  @override
  void visitTryStatement(TryStatement node) {
    _checkForIndentation(node);
  }
}
