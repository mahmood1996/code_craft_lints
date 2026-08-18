import 'package:custom_lints/src/rules/final_implementation_class.dart';
import 'package:custom_lints/src/fixes/make_class_final_fix.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'fix_test_.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MakeClassFinalFixTest);
  });
}

@reflectiveTest
final class MakeClassFinalFixTest extends FixTest {
  @override
  void setUp() {
    rule = FinalImplementationClassLint();
    super.setUp();
  }

  Future<void> test_makeClassFinal() async {
    await assertFix(
      original: r'''
class C {}
''',
      expected: r'''
final class C {}
''',
      producerFactory: MakeClassFinalFix.new,
    );
  }

  Future<void> test_makeClassBase() async {
    await assertFix(
      original: r'''
class C {}
''',
      expected: r'''
base class C {}
''',
      producerFactory: MakeClassBaseFix.new,
    );
  }

  Future<void> test_makeClassFinal_withDocComments() async {
    await assertFix(
      original: r'''
/// Documentation comment
class C {}
''',
      expected: r'''
/// Documentation comment
final class C {}
''',
      producerFactory: MakeClassFinalFix.new,
    );
  }
}
