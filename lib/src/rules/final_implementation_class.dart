import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../shared/smart_class_declaration.dart';

/// A lint rule requiring concrete implementation classes to be declared as `final class`.
///
/// Concrete classes that are not intended for inheritance should be marked `final`
/// (or `base` if subclassing is explicitly designed) to ensure strict encapsulation
/// and prevent brittle base class problems.
///
/// ### Example
///
/// **BAD:**
/// ```dart
/// class UserRepository {
///   void saveUser(User user) {}
/// }
/// ```
///
/// **GOOD:**
/// ```dart
/// final class UserRepository {
///   void saveUser(User user) {}
/// }
/// ```
final class FinalImplementationClassLint extends AnalysisRule {
  /// Creates a new [FinalImplementationClassLint] instance.
  FinalImplementationClassLint()
    : super(
        name: 'final_implementation_class',
        description:
            'Concrete implementation classes must be declared as `final class`.',
      );

  /// The lint diagnostic code for [FinalImplementationClassLint].
  static const code = LintCode(
    'final_implementation_class',
    'Concrete implementation classes must be declared as `final class`.',
    correctionMessage:
        'Add the `final` keyword, or use `base` if it must be inherited.',
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

/// AST visitor that checks if a class declaration violates [FinalImplementationClassLint].
final class _Visitor extends SimpleAstVisitor<void> {
  /// The lint rule instance reporting diagnostics.
  final AnalysisRule rule;

  /// Creates a new [_Visitor] associated with [rule].
  _Visitor(this.rule);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    // Concrete classes that are NOT marked final, sealed, base, abstract, interface, or mixin.
    if (node.isConcrete && !node.isFinal) {
      rule.reportAtNode(node);
    }
  }
}
