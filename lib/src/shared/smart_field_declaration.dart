import 'package:analyzer/dart/ast/ast.dart';

/// Extension on [FieldDeclaration] providing convenient helper properties.
extension SmartFieldDeclaration on FieldDeclaration {
  /// Whether this field is an instance field (i.e. not declared as `static`).
  bool get isInstanceField => !isStatic;
}
