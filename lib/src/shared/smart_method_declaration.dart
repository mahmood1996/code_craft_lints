import 'package:analyzer/dart/ast/ast.dart';

/// Extension on [MethodDeclaration] providing convenient helper properties.
extension SmartMethodDeclaration on MethodDeclaration {
  /// Whether this method has an implementation body (i.e. is not an empty/abstract method declaration).
  bool get hasBody => body is! EmptyFunctionBody;

  /// Whether this method is an instance method (i.e. not declared as `static`).
  bool get isInstanceMethod => !isStatic;
}
