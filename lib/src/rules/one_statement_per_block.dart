import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// A lint rule enforcing that control flow blocks contain at most one statement.
///
/// Blocks containing multiple statements often indicate doing too much within a single
/// scope. Extracting secondary logic into smaller helper functions improves modularity
/// and readability.
///
/// ### Example
///
/// **BAD:**
/// ```dart
/// if (condition) {
///   firstAction();
///   secondAction(); // LINT: block contains >1 statement
/// }
/// ```
///
/// **GOOD:**
/// ```dart
/// if (condition) {
///   handleCondition();
/// }
/// ```
final class OneStatementPerBlockLint extends AnalysisRule {
  /// Creates a new [OneStatementPerBlockLint] instance.
  OneStatementPerBlockLint()
    : super(
        name: 'one_statement_per_block',
        description: 'Blocks should contain at most one statement.',
      );

  /// The lint diagnostic code for [OneStatementPerBlockLint].
  static const code = LintCode(
    'one_statement_per_block',
    'Blocks should contain at most one statement.',
    correctionMessage: 'Extract the block logic into a separate function.',
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
      ..addIfStatement(this, visitor)
      ..addForStatement(this, visitor)
      ..addWhileStatement(this, visitor)
      ..addDoStatement(this, visitor)
      ..addTryStatement(this, visitor);
  }
}

/// AST visitor that inspects control flow statement bodies and reports blocks
/// containing more than one statement.
final class _Visitor extends SimpleAstVisitor<void> {
  /// The lint rule instance reporting diagnostics.
  final AnalysisRule rule;

  /// Creates a new [_Visitor] associated with [rule].
  _Visitor(this.rule);

  /// Checks if [block] contains more than one statement and reports a lint warning if so.
  void _checkBlock(Block? block) {
    if (block != null && block.statements.length > 1) {
      rule.reportAtNode(block);
    }
  }

  /// Evaluates [statement] and checks if it is a [Block] with multiple statements.
  void _checkStatement(Statement? statement) {
    if (statement is Block) _checkBlock(statement);
  }

  @override
  void visitIfStatement(IfStatement node) {
    _checkStatement(node.thenStatement);
    _checkStatement(node.elseStatement);
  }

  @override
  void visitForStatement(ForStatement node) {
    _checkStatement(node.body);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    _checkStatement(node.body);
  }

  @override
  void visitDoStatement(DoStatement node) {
    _checkStatement(node.body);
  }

  @override
  void visitTryStatement(TryStatement node) {
    _checkBlock(node.body);

    for (final catchClause in node.catchClauses) {
      _checkBlock(catchClause.body);
    }

    _checkBlock(node.finallyBlock);
  }
}
