import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../shared/smart_class_declaration.dart';
import '../shared/smart_field_declaration.dart';
import '../shared/smart_method_declaration.dart';

/// A lint rule requiring pure contract classes to be declared as `abstract interface class`.
///
/// Abstract classes that have no instance field declarations and no method bodies serve purely
/// as interface contracts. In Dart 3+, adding the `interface` modifier ensures callers implement
/// the contract rather than extending it, preventing accidental inheritance bugs.
///
/// ### Example
///
/// **BAD:**
/// ```dart
/// abstract class AuthGateway {
///   Future<void> signIn();
/// }
/// ```
///
/// **GOOD:**
/// ```dart
/// abstract interface class AuthGateway {
///   Future<void> signIn();
/// }
/// ```
final class PureContractClassLint extends AnalysisRule {
  /// Creates a new [PureContractClassLint] instance.
  PureContractClassLint()
    : super(
        name: 'pure_contract_class',
        description:
            'Pure contracts must be declared as `abstract interface class`.',
      );

  /// The lint diagnostic code for [PureContractClassLint].
  static const code = LintCode(
    'pure_contract_class',
    'Pure contracts must be declared as `abstract interface class`.',
    correctionMessage: 'Add the `interface` keyword.',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) => registry.addClassDeclaration(this, _Visitor(this));
}

/// AST visitor that checks whether an abstract class declaration is a pure contract
/// missing the `interface` modifier.
final class _Visitor extends SimpleAstVisitor<void> {
  /// The lint rule instance reporting diagnostics.
  final AnalysisRule rule;

  /// Creates a new [_Visitor] associated with [rule].
  _Visitor(this.rule);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    // Check if it's an abstract class but NOT already an interface, not sealed, and not final.
    if (!node.isAbstract) return;
    if (node.isSealed || node.isInterface || node.isFinal) return;

    final hasImplementation = node.body.members
        .whereType<MethodDeclaration>()
        .any((m) => m.isInstanceMethod && m.hasBody);

    final hasInstanceFields = node.body.members
        .whereType<FieldDeclaration>()
        .any((f) => f.isInstanceField);

    // If it has no implementation and no instance fields, it's a pure contract.
    if (!hasImplementation && !hasInstanceFields) {
      rule.reportAtNode(node);
    }
  }
}
