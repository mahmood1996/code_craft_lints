import 'package:analyzer/dart/ast/ast.dart';

/// Extension on [ClassDeclaration] providing convenient helper properties
/// for inspecting class modifiers and abstractness.
extension SmartClassDeclaration on ClassDeclaration {
  /// Whether this class declaration includes the `base` modifier.
  bool get isBase => baseKeyword != null;

  /// Whether this class declaration includes the `final` modifier.
  bool get isFinal => finalKeyword != null;

  /// Whether this class declaration is a `mixin class`.
  bool get isMixin => mixinKeyword != null;

  /// Whether this class declaration includes the `sealed` modifier.
  bool get isSealed => sealedKeyword != null;

  /// Whether this class declaration includes the `abstract` modifier.
  bool get isAbstract => abstractKeyword != null;

  /// Whether this class declaration includes the `interface` modifier.
  bool get isInterface => interfaceKeyword != null;

  /// Whether this class is a concrete class with no modifiers
  /// (`base`, `mixin`, `sealed`, `abstract`, or `interface`).
  bool get isConcrete => [
    !isBase,
    !isMixin,
    !isSealed,
    !isAbstract,
    !isInterface,
  ].fold(true, (prev, current) => prev && current);
}
