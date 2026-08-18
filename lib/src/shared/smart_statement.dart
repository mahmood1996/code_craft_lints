import 'package:analyzer/dart/ast/ast.dart';

/// Extension on [Statement] providing helper methods for statement extraction.
extension SmartStatement on Statement {
  /// Returns the first inner statement if this is a [Block],
  /// or this statement itself if it is not a block.
  ///
  /// Returns `null` if this is an empty block.
  Statement? get first => switch (this) {
    Block block => block.statements.firstOrNull,
    _ => this,
  };
}
