import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// A lint rule enforcing a maximum of 2 levels of indentation per function/method body.
///
/// Deeply nested control flow structures (e.g. nested `if`, `for`, `while`, `switch`, or `try`)
/// increase cyclomatic complexity, impair readability, and make code harder to maintain and test.
///
/// Indentation depth hierarchy:
/// - Level 0: Function declaration / signature
/// - Level 1: Function body and statements directly in function body
/// - Level 2: First-level control-flow blocks/statements and statements inside them
/// - Level 3+: Nested control-flow blocks (violations)
///
/// ### Example
///
/// **BAD:**
/// ```dart
/// void process(List<int> items) {
///   if (items.isNotEmpty) {
///     for (final item in items) { // LINT: indentation level == 3 (> 2)
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
final class MaxTwoLevelOfIndentationLint extends AnalysisRule {
  /// Creates a new [MaxTwoLevelOfIndentationLint] instance.
  MaxTwoLevelOfIndentationLint()
    : super(
        name: 'max_two_level_of_indentation',
        description:
            'Only 2 levels of indentation are supported. Extract this logic into a new function.',
      );

  /// The lint diagnostic code for [MaxTwoLevelOfIndentationLint].
  static const code = LintCode(
    'max_two_level_of_indentation',
    'Only 2 levels of indentation are supported.',
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

  /// Checks if [node] exceeds [maxIndentationLvl] and reports a lint warning if so.
  void _checkForIndentation(AstNode node, {int maxIndentationLvl = 2}) {
    if (_indentationLevel(node) > maxIndentationLvl) {
      rule.reportAtNode(node);
    }
  }

  /// Calculates the indentation level of [node] relative to its enclosing function body.
  int _indentationLevel(AstNode node) {
    var level = 0;
    AstNode? previous = node;
    AstNode? current = node;

    while (current != null) {
      level += switch (current) {
        FunctionBody _ ||
        DoStatement _ ||
        ForStatement _ ||
        TryStatement _ ||
        WhileStatement _ ||
        SwitchStatement _ => 1,
        IfStatement _
            when current.elseStatement != previous ||
                previous is! IfStatement =>
          1,
        _ => 0,
      };

      if (current is FunctionBody) break;

      previous = current;
      current = current.parent;
    }

    return level;
  }
}
