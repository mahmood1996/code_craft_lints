import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';

import '../shared/edit_code_command.dart';

/// A quick fix that adds the `final` modifier to a concrete class declaration.
final class MakeClassFinalFix extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    'dart.fix.code_craft_lints.makeClassFinal',
    DartFixKindPriority.standard,
    "Add 'final' modifier",
  );

  /// Creates a new [MakeClassFinalFix] with the given resolution [context].
  MakeClassFinalFix({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async =>
      switch (node.thisOrAncestorOfType<ClassDeclaration>()) {
        null => null,

        final classDeclaration => await EditCodeCommand.forAddingClassModifier(
          file: file,
          builder: builder,
          classDeclaration: classDeclaration,
          modifier: 'final ',
        ).call(),
      };
}

/// A quick fix that adds the `base` modifier to a concrete class declaration.
final class MakeClassBaseFix extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    'dart.fix.code_craft_lints.makeClassBase',
    DartFixKindPriority.standard - 1,
    "Add 'base' modifier",
  );

  /// Creates a new [MakeClassBaseFix] with the given resolution [context].
  MakeClassBaseFix({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossFiles;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async =>
      switch (node.thisOrAncestorOfType<ClassDeclaration>()) {
        null => null,

        final classDeclaration => await EditCodeCommand.forAddingClassModifier(
          file: file,
          builder: builder,
          classDeclaration: classDeclaration,
          modifier: 'base ',
        ).call(),
      };
}
