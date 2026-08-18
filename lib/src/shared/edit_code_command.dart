import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';

/// A reusable command encapsulation for executing Dart source code modifications
/// using [ChangeBuilder].
///
/// Encapsulates operations such as inserting class modifiers or replacing AST nodes
/// within a target source file.
final class EditCodeCommand {
  /// Creates an [EditCodeCommand] configured to insert a class [modifier] (e.g. `'final '`)
  /// immediately before the `class` keyword of the given [classDeclaration] in [file].
  EditCodeCommand.forAddingClassModifier({
    required String file,
    required String modifier,
    required ChangeBuilder builder,
    required ClassDeclaration classDeclaration,
  }) : this(
         file: file,
         builder: builder,
         editFile: (builder) => builder.addSimpleInsertion(
           classDeclaration.classKeyword.offset,
           modifier,
         ),
       );

  /// Creates an [EditCodeCommand] configured to replace a source code [range]
  /// with a new [replacement] string in [file].
  EditCodeCommand.forReplacement({
    required String file,
    required SourceRange range,
    required String replacement,
    required ChangeBuilder builder,
  }) : this(
         file: file,
         builder: builder,
         editFile: (builder) => builder.addReplacement(
           range,
           (builder) => builder.write(replacement),
         ),
       );

  /// Creates an [EditCodeCommand] with custom file edit operations.
  ///
  /// Takes the target [file] path, the active [builder], and a callback [editFile]
  /// to perform modifications on a [FileEditBuilder].
  EditCodeCommand({
    required String file,
    required ChangeBuilder builder,
    required FutureOr<void> Function(FileEditBuilder) editFile,
  }) : _file = file,
       _builder = builder,
       _editFile = editFile;

  final String _file;
  final ChangeBuilder _builder;
  final FutureOr<void> Function(FileEditBuilder) _editFile;

  /// Executes the configured code edit command on the target file.
  Future<void> call() async => await _builder.addDartFileEdit(_file, _editFile);
}
