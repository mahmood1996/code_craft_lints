import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';

import '../shared/edit_code_command.dart';

/// A quick fix that adds the `interface` modifier to an abstract class declaration.
final class MakeClassInterfaceFix extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    'dart.fix.custom_lints.makeClassInterface',
    DartFixKindPriority.standard,
    "Add 'interface' modifier",
  );

  /// Creates a new [MakeClassInterfaceFix] with the given resolution [context].
  MakeClassInterfaceFix({required super.context});

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
          modifier: 'interface ',
        ).call(),
      };
}
