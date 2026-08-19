import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:code_craft_lints/src/rules/pure_contract_class.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PureContractClassTest);
  });
}

@reflectiveTest
final class PureContractClassTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = PureContractClassLint();
    super.setUp();
  }

  Future<void> test_abstractClassWithoutImplementation_reportsLint() async {
    await assertDiagnostics(
      r'''
abstract class C {
  void foo();
}
''',
      [lint(0, 34)],
    );
  }

  Future<void> test_abstractInterfaceClass_noLint() async {
    await assertNoDiagnostics(r'''
abstract interface class C {
  void foo();
}
''');
  }

  Future<void> test_abstractFinalClass_noLint() async {
    await assertNoDiagnostics(r'''
abstract final class C {
  static double PI = 3.14;
}
''');
  }

  Future<void> test_abstractClassWithMethodBody_noLint() async {
    await assertNoDiagnostics(r'''
abstract class C {
  void foo() {}
}
''');
  }

  Future<void> test_abstractClassWithInstanceField_noLint() async {
    await assertNoDiagnostics(r'''
abstract class C {
  int x = 0;
  void foo();
}
''');
  }

  Future<void> test_sealedClass_noLint() async {
    await assertNoDiagnostics(r'''
sealed class C {
  void foo();
}
''');
  }

  Future<void> test_abstractClassWithStaticMembers_reportsLint() async {
    await assertDiagnostics(
      r'''
abstract class C {
  static int x = 0;
  static void bar() {}
  void foo();
}
''',
      [lint(0, 77)],
    );
  }

  Future<void> test_concreteClass_noLint() async {
    await assertNoDiagnostics(r'''
class C {
  void foo() {}
}
''');
  }
}
