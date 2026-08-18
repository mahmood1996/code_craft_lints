# Contributing to custom_lints

Thank you for your interest in contributing to `custom_lints`! We are committed to building a reliable, high-quality analysis plugin for the Dart and Flutter ecosystem.

---

## 🚨 Cardinal Rule: 100% Test Coverage

> **Every single line of code, AST branch, and correction producer must be covered by comprehensive unit tests.**
> 
> Pull requests that introduce new features, rules, fixes, or refactors without 100% test coverage covering both positive (lint reported / fix applied) and negative (no lint reported / fix not triggered) scenarios will not be accepted.

---

## Repository Architecture

```text
lib/
├── custom_lints.dart          # Public exports
├── main.dart                  # CustomLintsPlugin entrypoint & rule/fix registry
└── src/
    ├── rules/                 # AnalysisRule implementations
    ├── fixes/                 # ResolvedCorrectionProducer implementations
    └── shared/                # AST inspection and code manipulation helpers
test/
├── rules/                     # Rule unit tests with test_reflective_loader
└── fixes/                     # Fix unit tests with FixTest harness
```

---

## Adding a New Lint Rule

1. **Create the Rule File**:
   Create a new file in `lib/src/rules/<rule_name>.dart`.
   Extend `AnalysisRule` and provide a unique `LintCode`.

   ```dart
   import 'package:analyzer/analysis_rule/analysis_rule.dart';
   import 'package:analyzer/analysis_rule/rule_context.dart';
   import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
   import 'package:analyzer/dart/ast/ast.dart';
   import 'package:analyzer/dart/ast/visitor.dart';
   import 'package:analyzer/error/error.dart';

   final class MyCustomLint extends AnalysisRule {
     MyCustomLint()
       : super(
           name: 'my_custom_lint',
           description: 'Description of the rule.',
         );

     static const code = LintCode(
       'my_custom_lint',
       'Message displayed when rule triggers.',
       correctionMessage: 'Suggested correction.',
       severity: DiagnosticSeverity.WARNING,
     );

     @override
     LintCode get diagnosticCode => code;

     @override
     void registerNodeProcessors(RuleVisitorRegistry registry, RuleContext context) {
       registry.addClassDeclaration(this, _Visitor(this));
     }
   }

   final class _Visitor extends SimpleAstVisitor<void> {
     final AnalysisRule rule;
     _Visitor(this.rule);

     @override
     void visitClassDeclaration(ClassDeclaration node) {
       // AST logic
     }
   }
   ```

2. **Register the Rule**:
   - Register the rule in `lib/main.dart` inside `CustomLintsPlugin.register(PluginRegistry registry)`.
   - Export the rule from `lib/custom_lints.dart`.

3. **Add Comprehensive Tests**:
   Create `test/rules/<rule_name>_test.dart`:
   - Test cases where the lint **must** trigger.
   - Test cases where the lint **must NOT** trigger (boundary conditions, already-compliant code, comments, edge-cases).

---

## Adding a Quick Fix

1. **Create the Fix Producer**:
   Create a new file in `lib/src/fixes/<fix_name>.dart`.
   Extend `ResolvedCorrectionProducer`.

   ```dart
   import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
   import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
   import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
   import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
   import '../shared/edit_code_command.dart';

   final class MyCustomFix extends ResolvedCorrectionProducer {
     static const _kind = FixKind(
       'dart.fix.custom_lints.myCustomFix',
       DartFixKindPriority.standard,
       "Apply my custom fix",
     );

     MyCustomFix({required super.context});

     @override
     CorrectionApplicability get applicability => CorrectionApplicability.acrossFiles;

     @override
     FixKind get fixKind => _kind;

     @override
     Future<void> compute(ChangeBuilder builder) async {
       // AST analysis and code transformation
     }
   }
   ```

2. **Register the Fix**:
   - Register the fix in `lib/main.dart` using `registry.registerFixForRule(MyCustomLint.code, MyCustomFix.new)`.
   - Export the fix from `lib/custom_lints.dart`.

3. **Add Fix Unit Tests**:
   Create `test/fixes/<fix_name>_test.dart` inheriting from `FixTest`:
   - Test exact string transformation from before-state to after-state.
   - Test various code formats (with/without braces, multiple declarations, indentation).

---

## Pre-Submission Verification

Before submitting a Pull Request, verify that all local checks pass without warnings or errors:

```bash
# 1. Format all code
dart format --set-exit-if-changed .

# 2. Run static analysis (must have 0 infos/warnings/errors)
dart analyze --fatal-infos

# 3. Run all unit tests
dart test

# 4. Verify package metadata for pub.dev
dart pub publish --dry-run
```

---

## Pull Request Checklist

When submitting a PR, ensure:
- [ ] Every modified or added line of Dart code has corresponding test coverage.
- [ ] All tests pass (`dart test`).
- [ ] No analyzer issues (`dart analyze --fatal-infos`).
- [ ] Code is formatted (`dart format .`).
- [ ] `README.md` is updated if new rules or fixes are introduced.
- [ ] `CHANGELOG.md` reflects the changes under an `[Unreleased]` or target version section.
