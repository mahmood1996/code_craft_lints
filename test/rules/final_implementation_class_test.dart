import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:custom_lints/src/rules/final_implementation_class.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(FinalImplementationClassTest);
  });
}

@reflectiveTest
final class FinalImplementationClassTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = FinalImplementationClassLint();
    super.setUp();
  }

  Future<void> test_concreteClass_reportsLint() async {
    await assertDiagnostics(
      r'''
class C {}
''',
      [lint(0, 10)],
    );
  }

  Future<void> test_finalClass_noLint() async {
    await assertNoDiagnostics(r'''
final class C {}
''');
  }

  Future<void> test_baseClass_noLint() async {
    await assertNoDiagnostics(r'''
base class C {}
''');
  }

  Future<void> test_sealedClass_noLint() async {
    await assertNoDiagnostics(r'''
sealed class C {}
''');
  }

  Future<void> test_abstractClass_noLint() async {
    await assertNoDiagnostics(r'''
abstract class C {}
''');
  }

  Future<void> test_interfaceClass_noLint() async {
    await assertNoDiagnostics(r'''
interface class C {}
''');
  }

  Future<void> test_mixinClass_noLint() async {
    await assertNoDiagnostics(r'''
mixin class C {}
''');
  }
}
